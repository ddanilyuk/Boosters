//
//  ActivityShareItem.swift
//  Boosters
//
//  Created by Denys Danyliuk on 16.07.2022.
//

import Foundation

struct ActivityShareItem: Identifiable, Equatable {

    let id = UUID()
    var values: [Any]

    static func == (lhs: ActivityShareItem, rhs: ActivityShareItem) -> Bool {
        lhs.id == rhs.id
    }

}
