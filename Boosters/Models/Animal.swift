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
    let status: String
    let content: [Fact]?
}

// MARK: - Decodable

extension Animal: Decodable {

}

// MARK: - Equatable

extension Animal: Equatable {

}

// MARK: - Identifiable

extension Animal: Identifiable {

    var id: String {
        title
    }
    
}

extension Animal {

    static var mock = Animal(
        title: "Dogs 🐕",
        description: "Different facts about dogs",
        image: "https://upload.wikimedia.org/wikipedia/commons/2/2b/WelshCorgi.jpeg",
        order: 2,
        status: "paid",
        content: [
            Fact(
                fact: "During the Renaissance, detailed portraits of the dog as a symbol of fidelity and loyalty appeared in mythological, allegorical, and religious art throughout Europe, including works by Leonardo da Vinci, Diego Velázquez, Jan van Eyck, and Albrecht Durer.",
                image: "https://images.dog.ceo/breeds/basenji/n02110806_4150.jpg"
            )
        ]
    )

}
