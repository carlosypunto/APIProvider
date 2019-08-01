//
//  SingleUserResponse.swift
//  Example
//
//  Created by Carlos García on 31/07/2019.
//  Copyright © 2019 Carlos Garcia Nieto. All rights reserved.
//

struct SingleUserResponse: Codable {
    
    let user: User

    enum CodingKeys: String, CodingKey {
        case user = "data"
    }
    
    
}
