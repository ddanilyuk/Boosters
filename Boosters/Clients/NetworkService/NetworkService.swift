//
//  NetworkService.swift
//  Boosters
//
//  Created by Denys Danyliuk on 15.07.2022.
//

import Foundation
import Combine

struct NetworkService {

    var buildRequest: (_ requestBuilder: RequestBuilder) -> URLRequest
    var executeRequest: (_ request: URLRequest) -> AnyPublisher<Data, NetworkError>

}

extension NetworkService {

    static func live() -> Self {
        let session = URLSession.shared
        let baseURL = URL(string: "https://drive.google.com")!
        return Self(
            buildRequest: { requestBuilder in
                let fullURL: URL = {
                    let url = requestBuilder.path.isEmpty
                        ? baseURL
                        : baseURL.appendingPathComponent(requestBuilder.path)

                    guard var components = URLComponents(url: url, resolvingAgainstBaseURL: false) else {
                        return url
                    }

                    if !requestBuilder.queryItems.isEmpty {
                        components.queryItems = requestBuilder.queryItems
                    }

                    guard let fullURL = components.url else {
                        return url
                    }

                    return fullURL
                }()

                var request = URLRequest(url: fullURL)
                request.httpMethod = requestBuilder.method.rawValue
                request.setValue(requestBuilder.contentType?.typeString, forHTTPHeaderField: "Content-Type")
                request.httpBody = requestBuilder.body()
                return request
            },
            executeRequest: { request in
                session.dataTaskPublisher(for: request)
                    .on(
                        value: { data, response in logResponse(data: data, response, request: request) },
                        error: { error in logError(error: error) }
                    )
                    .mapError { error in NetworkError.requestError(code: error.errorCode, message: error.localizedDescription) }
                    .tryMap { data, response -> Result<Data, NetworkError> in
                        guard let response = response as? HTTPURLResponse else {
                            return .failure(.apiError(message: "Can't proceed with response"))
                        }

                        switch response.statusCode {
                        case 200..<300:
                            return .success(data)

                        case 400..<500:
                            return .failure(.requestError(code: response.statusCode, message: response.description))

                        default:
                            print("Unknown Status code: \(response.statusCode)")
                            return .success(data)
                        }
                    }
                    .eraseToAnyPublisher()
            }
        )
    }

    private static func logResponse(data: Data, _ response: URLResponse, request: URLRequest) {
        let statusCode = (response as? HTTPURLResponse)?.statusCode ?? 0
        let jsonData = try? JSONSerialization.jsonObject(with: data, options: [])
        let prettyPrintedJSON = jsonData.flatMap {
            try? JSONSerialization.data(withJSONObject: $0, options: [.prettyPrinted])
        }

        let formattedData = prettyPrintedJSON.flatMap { String(data: $0, encoding: .utf8) }
        ?? String(data: data, encoding: .utf8)
        ?? "unknown"

        print(
            "Response: \(request.description) [\(statusCode)] \(formattedData)"
        )
    }

    private static func logError(error: Error) {
        print("Network Error: \(error)")
    }

}




//extension Anim



//import Foundation
//import Combine
//
//protocol NetworkClient {
//    func request<T: TargetType>(_ target: T) -> AnyPublisher<T.Response, NetworkError>
//    func executeRequest(_ request: URLRequest) -> AnyPublisher<Data, NetworkError>
//}
//
//final class NetworkClientImpl: NetworkClient {
//    private let baseURL: URL
//    private let plugin: CompositePlugin
//    private let asyncPlugin: AsyncNetworkPlugin?
//    private let session: URLSession
//    private let decoder: JSONDecoder
//
//    init(
//        baseURL: URL,
//        plugins: [NetworkPlugin] = [],
//        asyncPlugin: AsyncNetworkPlugin? = nil,
//        session: URLSession = URLSession(configuration: URLSessionConfiguration.default),
//        decoder: JSONDecoder = JSONDecoder()
//    ) {
//        self.baseURL = baseURL
//        self.plugin = CompositePlugin(plugins: plugins)
//        self.asyncPlugin = asyncPlugin
//        self.session = session
//        self.decoder = decoder
//    }
//
//    func request<T: TargetType>(_ target: T) -> AnyPublisher<T.Response, NetworkError> {
//        return buildRequest(from: target)
//            .flatMap { [unowned self] request in
//                applyPlugins(request: request)
//                    .setFailureType(to: NetworkError.self)
//            }
//            .flatMap { [unowned self] request in executeRequest(request) }
//            .flatMap { [unowned self] data -> AnyPublisher<T.Response, NetworkError> in
//                do {
//                    let response = try decoder.decode(APIResponse<T.Response>.self, from: data)
//
//                    return Just(response.data)
//                        .setFailureType(to: NetworkError.self)
//                        .eraseToAnyPublisher()
//                } catch {
//                    if let response = try? decoder.decode(APIError.self, from: data) {
//                        let message = response.error.message
//                        log.error("Parse API error: \(message)")
//                        return Fail(outputType: T.Response.self, failure: NetworkError.apiError(message: message))
//                            .eraseToAnyPublisher()
//                    }
//
//                    log.error("Couldn't parse model: \(error)")
//                    let networkError = NetworkError.serializationError(message: error.localizedDescription)
//                    return Fail(outputType: T.Response.self, failure: networkError).eraseToAnyPublisher()
//                }
//            }
//            .eraseToAnyPublisher()
//    }
//
//    /// Builds a `URLRequest` by provided `TargetType`.
//    ///
//    /// - Parameter target: `TargetType` that is used to build the request.
//    /// - Returns: `AnyPublisher` that emits a request or `serializationError`.
//    private func buildRequest<T: TargetType>(from target: T) -> AnyPublisher<URLRequest, NetworkError> {
//        let fullURL: URL = {
//            let url = target.path.isEmpty ? baseURL: baseURL.appendingPathComponent(target.path)
//
//            guard var components = URLComponents(url: url, resolvingAgainstBaseURL: false) else {
//                return url
//            }
//
//            if !target.queryItems.isEmpty {
//                components.queryItems = target.queryItems
//                components.percentEncodedQuery = components.percentEncodedQuery?
//                    .replacingOccurrences(of: "+", with: "%2B")
//            }
//
//            guard let fullURL = components.url else {
//                return url
//            }
//
//            return fullURL
//        }()
//
//        var request = URLRequest(url: fullURL)
//        request.httpMethod = target.method.rawValue
//        request.setValue(target.contentType?.typeString, forHTTPHeaderField: "Content-Type")
//        request.httpBody = target.getBodyData()
//
//        return Just(request)
//            .setFailureType(to: NetworkError.self)
//            .eraseToAnyPublisher()
//    }
//
//    /// Executes request
//    ///
//    /// - Parameter request: `URLRequest` to execute.
//    /// - Returns: `AnyPublisher` with a received `Response`. All errors are mapped into `NetworkError.api`.
//    func executeRequest(_ request: URLRequest) -> AnyPublisher<Data, NetworkError> {
//        return session.dataTaskPublisher(for: request)
//            .on(
//                value: { data, response in logResponse(data: data, response, request: request) },
//                error: { error in log.error("Network Error: \(error)") }
//            )
//            .mapError { error in NetworkError.requestError(code: error.errorCode, message: error.localizedDescription) }
//            .tryMap { data, response -> Result<Data, NetworkError> in
//                guard let response = response as? HTTPURLResponse else {
//                    return .failure(.apiError(message: "Can't proceed with response"))
//                }
//
//                switch response.statusCode {
//                case 200..<300:
//                    return .success(data)
//
//                case 400..<500:
//                    return .failure(.requestError(code: response.statusCode, message: response.description))
//
//                default:
//                    log.info("Unknown Status code: \(response.statusCode)")
//                    return .success(data)
//                }
//            }
//            .eraseToAnyPublisher()
//    }
//
//    private func applyPlugins(request: URLRequest) -> AnyPublisher<URLRequest, Never> {
//        var request = request
//        plugin.modifyRequest(&request)
//
//        if let plugin = asyncPlugin {
//            return plugin.modifyRequest(urlRequest: request)
//        } else {
//            return Just(request).eraseToAnyPublisher()
//        }
//    }
//}
//
//private func logResponse(data: Data, _ response: URLResponse, request: URLRequest) {
//    let statusCode = (response as? HTTPURLResponse)?.statusCode ?? 0
//    let jsonData = try? JSONSerialization.jsonObject(with: data, options: [])
//    let prettyPrintedJSON = jsonData.flatMap {
//        try? JSONSerialization.data(withJSONObject: $0, options: [.prettyPrinted])
//    }
//
//    let formattedData = prettyPrintedJSON.flatMap { String(data: $0, encoding: .utf8) }
//    ?? String(data: data, encoding: .utf8)
//    ?? "unknown"
//
//    log.debug(
//        "Response: \(request.description) [\(statusCode)] \(formattedData)"
//    )
//}
