//
//  User.swift
//  Example
//
//  Created by Carlos Garcia Nieto on 31/07/2019.
//  Copyright © 2019 Carlos Garcia Nieto. All rights reserved.
//

struct User: Codable {
    
    let id: Int
    let email: String
    let firstName: String
    let lastName: String
    let avatar: String

    enum CodingKeys: String, CodingKey {
        case id = "id"
        case email = "email"
        case firstName = "first_name"
        case lastName = "last_name"
        case avatar = "avatar"
    }
    
}
