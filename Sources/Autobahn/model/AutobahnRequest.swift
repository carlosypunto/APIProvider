//
//  AutobahnRequest.swift
//  Autobahn
//
//  Created by Carlos Garcia Nieto on 01/08/2019.
//  Copyright © 2019 Carlos Garcia Nieto. All rights reserved.
//

import Foundation

public struct Request<ResponseType: Codable> {
    
    public let method: HTTPMethod
    public let baseURL: URL
    public let path: String
    public let parameters: [String: String]
    public let headers: [String: String]
    public let bodyObjects: [String: Codable]

    var urlRequest: URLRequest {
        
        let url = baseURL.appendingPathComponent(path)
        
        guard var components = URLComponents(url: url, resolvingAgainstBaseURL: false) else {
            fatalError("Unable to create URLComponents from url: \(url)")
        }

        if !parameters.isEmpty {
            components.queryItems = parameters.map {
                URLQueryItem(name: $0, value: $1 )
            }
        }

        guard let finalURL = components.url else {
            fatalError("Unable to retrieve final URL")
        }

        var request = URLRequest(url: finalURL)
        request.httpMethod = method.rawValue.uppercased()
        
        if !bodyObjects.isEmpty {
            let jsonData = try? JSONSerialization.data(withJSONObject: bodyObjects)
            request.httpBody = jsonData
        }

        request.addValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")
        if !headers.isEmpty {
            for (_, header) in headers.enumerated() {
                request.addValue(header.value, forHTTPHeaderField: header.key)
            }
        }
        
        return request
    }
    
    public init(method: HTTPMethod, baseURL: URL, path: String, parameters: [String: String] = [:], headers: [String: String] = [:], bodyObjects: [String: Codable] = [:]) {
        self.method = method
        self.baseURL = baseURL
        self.path = path
        self.parameters = parameters
        self.headers = headers
        self.bodyObjects = bodyObjects
    }
    
}
