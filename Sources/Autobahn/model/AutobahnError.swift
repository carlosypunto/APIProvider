//
//  File.swift
//  Autobahn
//
//  Created by Carlos Garcia Nieto on 01/08/2019.
//  Copyright © 2019 Carlos Garcia Nieto. All rights reserved.
//

import Foundation

public enum AutobahnError: Error {
    case request(code: Int, request: URLRequest, error: Error?)
    case unknown(request: URLRequest)
    case canNotDecode(Data, URLRequest)
}
