//
//  Animal.swift
//  Boosters
//
//  Created by Denys Danyliuk on 15.07.2022.
//

import Foundation

struct Animal {
    let title: String
    let description: String
    let image: String
    let order: Int
    let status: Status
    let content: [Fact]?

    enum Status: String, Decodable {
        case paid
        case free
        case comingSoon
    }
}

// MARK: - Decodable

extension Animal: Decodable {

    enum CodingKeys: String, CodingKey {
        case title
        case description
        case image
        case order
        case status
        case content
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        title = try container.decode(String.self, forKey: .title)
        description = try container.decode(String.self, forKey: .description)
        image = try container.decode(String.self, forKey: .image)
        order = try container.decode(Int.self, forKey: .order)
        content = try container.decodeIfPresent([Fact].self, forKey: .content)
        if content?.isEmpty ?? true {
            status = .comingSoon
        } else {
            status = try container.decode(Status.self, forKey: .status)
        }
    }
    
}

// MARK: - Equatable

extension Animal: Equatable {

}

// MARK: - Comparable

extension Animal: Comparable {

    static func < (lhs: Animal, rhs: Animal) -> Bool {
        lhs.order < rhs.order
    }

}


// MARK: - Identifiable

extension Animal: Identifiable {

    var id: String {
        title
    }
    
}

extension Animal {

    static var mock = Animal(
        title: "Horses 🐕",
        description: "Different facts about horses",
        image: "https://upload.wikimedia.org/wikipedia/commons/2/2b/WelshCorgi.jpeg",
        order: 2,
        status: .paid,
        content: [
            Fact(
                fact: "During the Renaissance, detailed portraits of the dog as a symbol of fidelity and loyalty appeared in mythological, allegorical, and religious art throughout Europe, including works by Leonardo da Vinci, Diego Velázquez, Jan van Eyck, and Albrecht Durer. ",
                image: "https://images.dog.ceo/breeds/basenji/n02110806_4150.jpg"
            )
        ]
    )

}
