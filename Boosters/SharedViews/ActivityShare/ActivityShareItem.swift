//
//  ActivityShareItem.swift
//  Boosters
//
//  Created by Denys Danyliuk on 16.07.2022.
//

import Foundation

struct ActivityShareItem: Identifiable {

    let id = UUID()
    let values: [Any]

}

// MARK: - Equatable

extension ActivityShareItem: Equatable {

    static func == (lhs: ActivityShareItem, rhs: ActivityShareItem) -> Bool {
        lhs.id == rhs.id
    }

}
