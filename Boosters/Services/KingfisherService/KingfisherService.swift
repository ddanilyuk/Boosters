//
//  KingfisherService.swift
//  Boosters
//
//  Created by Denys Danyliuk on 16.07.2022.
//

import Foundation
import Kingfisher

struct KingfisherService {

    var imageCache: ImageCache

}

// MARK: - Live

extension KingfisherService {

    static func live() -> Self {
        Self(
            imageCache: ImageCache.default
        )
    }

}

// MARK: - Mock

extension KingfisherService {

    static var mock: Self {
        Self(
            imageCache: ImageCache(name: "mock")
        )
    }

}
