//
//  ContentType.swift
//  Boosters
//
//  Created by Denys Danyliuk on 15.07.2022.
//

import Foundation

enum ContentType {
    case json

    var typeString: String {
        switch self {
        case .json:
            return "application/json"
        }
    }
    
}
