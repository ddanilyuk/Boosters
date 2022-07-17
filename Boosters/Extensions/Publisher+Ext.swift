//
//  Publisher+Ext.swift
//  Boosters
//
//  Created by Denys Danyliuk on 15.07.2022.
//

import Combine
import Foundation

extension Publisher {

    func on(
        value: ((Output) -> Void)? = nil,
        error: ((Failure) -> Void)? = nil,
        finished: (() -> Void)? = nil
    ) -> AnyPublisher<Output, Failure> {
        handleEvents(
            receiveOutput: { output in
                value?(output)
            },
            receiveCompletion: { completion in
                switch completion {
                case .failure(let failure):
                    error?(failure)
                case .finished:
                    finished?()
                }
            }
        )
        .eraseToAnyPublisher()
    }

    func sink() -> AnyCancellable {
        sink(receiveCompletion: { _ in }, receiveValue: { _ in })
    }

    func tryMap<V>(_ transform: @escaping (Output) -> Result<V, Failure>) -> AnyPublisher<V, Failure> {
        flatMap { value -> AnyPublisher<V, Failure> in
            switch transform(value) {
            case .success(let success):
                return Just(success)
                    .setFailureType(to: Failure.self)
                    .eraseToAnyPublisher()

            case .failure(let failure):
                return Fail(error: failure).eraseToAnyPublisher()
            }
        }
        .eraseToAnyPublisher()
    }

}

extension Publisher where Output == Data, Failure == NetworkError {

    func handleResponse<T: Decodable>(with decoder: JSONDecoder) -> AnyPublisher<T, NetworkError> {
        flatMap { data -> AnyPublisher<T, NetworkError> in
            do {
                let response = try decoder.decode(T.self, from: data)
                return Just(response)
                    .setFailureType(to: NetworkError.self)
                    .eraseToAnyPublisher()
            } catch {
                if let response = try? decoder.decode(APIError.self, from: data) {
                    let message = response.error.message
                    return Fail(
                        outputType: T.self,
                        failure: NetworkError.apiError(message: message)
                    )
                    .eraseToAnyPublisher()
                }
                let networkError = NetworkError.serializationError(message: "\(error)")
                return Fail(outputType: T.self, failure: networkError).eraseToAnyPublisher()
            }
        }
        .eraseToAnyPublisher()
    }

}

extension Publisher where Output == Never {

    func setOutputType<NewOutput>(to _: NewOutput.Type) -> AnyPublisher<NewOutput, Failure> {
        func absurd<A>(_ never: Never) -> A {}
        return self.map(absurd).eraseToAnyPublisher()
    }

}

extension Publisher {

    func ignoreOutput<NewOutput>(
        setOutputType: NewOutput.Type
    ) -> AnyPublisher<NewOutput, Failure> {
        self
            .ignoreOutput()
            .setOutputType(to: NewOutput.self)
    }

    func ignoreFailure<NewFailure>(
        setFailureType: NewFailure.Type
    ) -> AnyPublisher<Output, NewFailure> {
        self
            .catch { _ in Empty() }
            .setFailureType(to: NewFailure.self)
            .eraseToAnyPublisher()
    }

    func ignoreFailure() -> AnyPublisher<Output, Never> {
        self
            .catch { _ in Empty() }
            .setFailureType(to: Never.self)
            .eraseToAnyPublisher()
    }

}
