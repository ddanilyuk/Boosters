//
//  APIResponse.swift
//  Boosters
//
//  Created by Denys Danyliuk on 15.07.2022.
//

import Foundation

struct APIResponse<Data: Decodable>: Decodable {
    let data: Data
}
