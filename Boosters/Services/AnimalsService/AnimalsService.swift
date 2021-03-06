//
//  AnimalsService.swift
//  Boosters
//
//  Created by Denys Danyliuk on 15.07.2022.
//

import Foundation
import ComposableArchitecture

struct AnimalsService {

    var getAnimals: () -> Effect<[Animal], NetworkError>

}

// MARK: - Live

extension AnimalsService {

    static func live(networkService: NetworkService) -> Self {
        let jsonDecoder = JSONDecoder()
        return Self(
            getAnimals: {
                let requestBuilder = RequestBuilder(
                    path: "uc",
                    method: .get,
                    contentType: .json,
                    queryItems: [
                        URLQueryItem(name: "export", value: "download"),
                        URLQueryItem(name: "id", value: "12L7OflAsIxPOF47ssRdKyjXoWbUrq4V5")
                    ]
                )
                let request = networkService.buildRequest(requestBuilder)
                return networkService
                    .executeRequest(request)
                    .handleResponse(with: jsonDecoder)
                    .eraseToEffect()
            }
        )
    }

}

// MARK: - Mock

extension AnimalsService {

    static var mock: Self {
        Self(
            getAnimals: {
                Effect(value: [.mock])
                    .delay(for: 1, scheduler: DispatchQueue.main)
                    .eraseToEffect()
            }
        )
    }
    
}
