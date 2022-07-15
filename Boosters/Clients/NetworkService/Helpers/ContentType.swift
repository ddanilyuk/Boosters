//
//  ContentType.swift
//  Boosters
//
//  Created by Denys Danyliuk on 15.07.2022.
//

import Foundation

enum ContentType {
    case json
    case formData(boundaryId: UUID)

    var typeString: String {
        switch self {
        case .json:
            return "application/json"
        case .formData(let boundaryId):
            return "multipart/form-data; boundary=\(boundaryId.uuidString)"
        }
    }
}
