//
//  API.swift
//  Example
//
//  Created by Carlos Garcia Nieto on 31/07/2019.
//  Copyright © 2019 Carlos Garcia Nieto. All rights reserved.
//

import Foundation
import Autobahn
import Combine

class API: Autobahn {
    
    var decoder: JSONDecoder = JSONDecoder()
    let urlSession: URLSession = URLSession.shared
    let commonHeaders: [String: String] = [:]
    let commonParameters: [String: String] = [:]

    let baseURL: URL = {
        guard let baseURL = URL(string: "https://reqres.in")
            else { fatalError("Unable to get baseURL for API") }
        return baseURL
    }()
    
    static let shared = API()
    private init() {}
    
    func getListUsers(page: Int) -> AnyPublisher<UserListResponse, Error> {
        return get(path: "/api/users", parameters: ["page": "\(page)"])
    }
    
    func getSingleUser(id: Int) -> AnyPublisher<SingleUserResponse, Error> {
        return get(path: "/api/users/\(id)")
    }
    
    func getListResources(page: Int) -> AnyPublisher<ResourceListResponse, Error> {
        return get(path: "/api/unknown", parameters: ["page": "\(page)"])
    }
    
    func getSingleResource(id: Int) -> AnyPublisher<SingleResourceResponse, Error> {
        return get(path: "/api/unknown/\(id)")
    }
    
}
