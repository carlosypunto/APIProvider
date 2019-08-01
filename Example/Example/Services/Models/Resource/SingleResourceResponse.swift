//
//  SingleResourceResponse.swift
//  Example
//
//  Created by Carlos García on 31/07/2019.
//  Copyright © 2019 Carlos Garcia Nieto. All rights reserved.
//

struct SingleResourceResponse: Codable {
    
    let data: User

    enum CodingKeys: String, CodingKey {
        case data = "data"
    }
    
    
}
