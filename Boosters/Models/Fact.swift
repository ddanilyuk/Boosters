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

// MARK: - Identifiable

extension Fact: Identifiable {

    var id: String {
        fact
    }

}

// MARK: - Decodable

extension Fact: Decodable {

}

// MARK: - Equatable

extension Fact: Equatable {

}

// MARK: - Hashable

extension Fact: Hashable {

}

// MARK: - Mock

extension Fact {

    static let mock = Fact(
        fact: "During the Renaissance, detailed portraits of the dog as a symbol of fidelity and loyalty appeared in mythological, allegorical, and religious art throughout Europe, including works by Leonardo da Vinci, Diego Velázquez, Jan van Eyck, and Albrecht Durer. ",
        image: "https://images.dog.ceo/breeds/basenji/n02110806_4150.jpg"
    )

}
