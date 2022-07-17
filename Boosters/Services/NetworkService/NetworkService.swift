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

    // MARK: - Live

    static func live(baseURL: URL) -> Self {
        let session = URLSession.shared
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
