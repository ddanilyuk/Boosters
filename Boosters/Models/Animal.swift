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
