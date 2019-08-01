//
//  Autobahn.swift
//  Autobahn
//
//  Created by Carlos Garcia Nieto on 01/08/2019.
//  Copyright © 2019 Carlos Garcia Nieto. All rights reserved.
//

import Foundation
import SwiftUI
import Combine

public protocol Autobahn {
    var decoder: JSONDecoder { get }
    var urlSession: URLSession { get }
    var baseURL: URL { get }
    var commonParameters: [String: String] { get }
    var commonHeaders: [String: String] { get }
}

public extension Autobahn {
    
    func getCommonParams(with parameters: [String: String]) -> [String: String] {
        return parameters.reduce(commonParameters, { var x = $0; x[$1.key] = $1.value; return x })
    }
    
    func getCommonHeaders(with headers: [String: String]) -> [String: String] {
        return headers.reduce(commonHeaders, { var x = $0; x[$1.key] = $1.value; return x })
    }
    
    private func publisher<T: Codable>(with request: Request<T>) -> AnyPublisher<T, Error> {
        let decoder = self.decoder
        return urlSession.dataTaskPublisher(for: request.urlRequest)
            .tryMap { data, response -> Data in
                 let httpResponse = response as? HTTPURLResponse
                 if let httpResponse = httpResponse, 200..<300 ~= httpResponse.statusCode {
                     return data
                 }
                 else if let httpResponse = httpResponse {
                    throw AutobahnError.request(code: httpResponse.statusCode, request: request.urlRequest, error: NSError(domain: httpResponse.description, code: httpResponse.statusCode, userInfo: httpResponse.allHeaderFields as? [String : Any]))
                 } else {
                     throw AutobahnError.unknown(request: request.urlRequest)
                 }
            }
            // Better than .decode(type: T.self, decoder: decoder)
            .tryMap { data -> T in
                do {
                    return try decoder.decode(T.self, from: data)
                }
                catch {
                    throw AutobahnError.canNotDecode(data, request.urlRequest)
                }
            }
            .eraseToAnyPublisher()
    }
    
    
    func get<T: Codable>(path: String,
                         parameters: [String: String] = [:],
                         headers: [String: String] = [:],
                         bodyObjects: [String: Codable] = [:]) -> AnyPublisher<T, Error> {
        return publisher(with: Request<T>(method: .get,
                                          baseURL: baseURL,
                                          path: path,
                                          parameters: getCommonParams(with: parameters),
                                          headers: getCommonHeaders(with: headers)))
    }
    
    func post<T: Codable>(path: String,
                          parameters: [String: String] = [:],
                          headers: [String: String] = [:],
                          bodyObjects: [String: Codable] = [:]) -> AnyPublisher<T,
        Error> {
        return publisher(with: Request<T>(method: .post,
                                          baseURL: baseURL,
                                          path: path,
                                          parameters: getCommonParams(with: parameters),
                                          headers: getCommonHeaders(with: headers),
                                          bodyObjects: bodyObjects))
    }
    
    func put<T: Codable>(path: String,
                         parameters: [String: String] = [:],
                         headers: [String: String] = [:],
                         bodyObjects: [String: Codable] = [:]) -> AnyPublisher<T,
        Error> {
        return publisher(with: Request<T>(method: .put,
                                          baseURL: baseURL,
                                          path: path,
                                          parameters: getCommonParams(with: parameters),
                                          headers: getCommonHeaders(with: headers),
                                          bodyObjects: bodyObjects))
    }
    
    func update<T: Codable>(path: String,
                            parameters: [String: String] = [:],
                            headers: [String: String] = [:],
                            bodyObjects: [String: Codable] = [:]) -> AnyPublisher<T,
        Error> {
        return publisher(with: Request<T>(method: .update,
                                          baseURL: baseURL,
                                          path: path,
                                          parameters: getCommonParams(with: parameters),
                                          headers: getCommonHeaders(with: headers),
                                          bodyObjects: bodyObjects))
    }
    
    func delete<T: Codable>(path: String,
                            parameters: [String: String] = [:],
                            headers: [String: String] = [:],
                            bodyObjects: [String: Codable] = [:]) -> AnyPublisher<T,
        Error> {
        return publisher(with: Request<T>(method: .get,
                                          baseURL: baseURL,
                                          path: path,
                                          parameters: getCommonParams(with: parameters),
                                          headers: getCommonHeaders(with: headers),
                                          bodyObjects: bodyObjects))
    }
    
}
