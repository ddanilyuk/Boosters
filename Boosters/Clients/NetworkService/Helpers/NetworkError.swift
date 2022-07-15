//
//  NetworkError.swift
//  Boosters
//
//  Created by Denys Danyliuk on 15.07.2022.
//

import Foundation

enum NetworkError: Error, Equatable {
    case serializationError(message: String)
    case apiError(message: String)
    case requestError(code: Int, message: String)
    case invalidParametersError
}

extension NetworkError: CustomStringConvertible, LocalizedError {
    var description: String {
        switch self {
        case let .serializationError(message):
            return message
        case let .apiError(message):
            return message
        case let .requestError(_, message):
            return message
        case .invalidParametersError:
            return "Request has invalid parameters"
        }
    }

    var errorDescription: String? {
        description
    }
}
