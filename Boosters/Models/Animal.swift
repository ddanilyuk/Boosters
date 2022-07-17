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

// MARK: - Equatable

extension Animal: Equatable {

}

// MARK: - Mock

extension Animal {

    static var mock = Animal(
        title: "Horses 🐕",
        description: "Different facts about horses",
        image: "https://upload.wikimedia.org/wikipedia/commons/2/2b/WelshCorgi.jpeg",
        order: 2,
        status: .paid,
        content: [Fact.mock]
    )

    static var redacted1 = Animal(
        title: String(repeating: " ", count: 10),
        description: String(repeating: " ", count: 15),
        image: "https://upload.wikimedia.org/wikipedia/commons/2/2b/WelshCorgi.jpeg",
        order: 1,
        status: .free,
        content: [ ]
    )

    static var redacted2 = Animal(
        title: String(repeating: " ", count: 5),
        description: String(repeating: " ", count: 35),
        image: "https://upload.wikimedia.org/wikipedia/commons/2/2b/WelshCorgi.jpeg",
        order: 2,
        status: .paid,
        content: [ ]
    )

}
