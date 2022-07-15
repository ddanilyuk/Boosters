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
