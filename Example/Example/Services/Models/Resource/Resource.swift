//
//  Resource.swift
//  Example
//
//  Created by Carlos García on 31/07/2019.
//  Copyright © 2019 Carlos Garcia Nieto. All rights reserved.
//

struct Resource: Codable {
    
    let id: Int
    let name: String
    let year: Int
    let color: String
    let pantoneValue: String

    enum CodingKeys: String, CodingKey {
        case id = "id"
        case name = "name"
        case year = "year"
        case color = "color"
        case pantoneValue = "pantone_value"
    }
    
}
