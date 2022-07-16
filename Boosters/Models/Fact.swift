//
//  Fact.swift
//  Boosters
//
//  Created by Denys Danyliuk on 15.07.2022.
//

import Foundation

struct Fact {
    let fact: String
    let image: String

    var imageURL: URL? {
        URL(string: image)
    }

    var imageCacheKey: String {
        image + fact
    }

}

// MARK: - Decodable

extension Fact: Decodable {

}


// MARK: - Identifiable

extension Fact: Identifiable {

    var id: String {
        fact
    }

}

// MARK: - Equatable

extension Fact: Equatable {

}

// MARK: - Hashable

extension Fact: Hashable {

}
