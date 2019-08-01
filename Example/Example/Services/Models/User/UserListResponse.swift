//
//  UserListResponse.swift
//  Example
//
//  Created by Carlos García on 31/07/2019.
//  Copyright © 2019 Carlos Garcia Nieto. All rights reserved.
//

struct UserListResponse: Codable {
    
    let page: Int
    let perPage: Int
    let total: Int
    let totalPages: Int
    let data: [User]

    enum CodingKeys: String, CodingKey {
        case page = "page"
        case perPage = "per_page"
        case total = "total"
        case totalPages = "total_pages"
        case data = "data"
    }
    
}
