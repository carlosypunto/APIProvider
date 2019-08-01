//
//  ViewController.swift
//  Example
//
//  Created by Carlos Garcia Nieto on 31/07/2019.
//  Copyright © 2019 Carlos Garcia Nieto. All rights reserved.
//

import UIKit
import Combine
import Autobahn

class ViewController: UIViewController {
    
    private var cancelables: [Cancellable] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        
        makeListUsersCall(page: 1)
        makeListUsersCall(page: 2)
        makeSingleUserCall(id: 1)
        makeSingleUserCall(id: 2)
        makeSingleUserCall(id: 23)

        makeListResourcesCall(page: 1)
        makeListResourcesCall(page: 2)
        makeSingleResourceCall(id: 1)
        makeSingleResourceCall(id: 2)
        makeSingleResourceCall(id: 23)
    }
    
    func makeListUsersCall(page: Int) {
        cancelables.append(API.shared.getListUsers(page: page)
        .sink(
            receiveCompletion: receiveCompletion,
            receiveValue: { response in
                print("\n--")
                print(response)
        }))
    }
    
    func makeSingleUserCall(id: Int) {
        cancelables.append(API.shared.getSingleUser(id: id)
        .sink(
            receiveCompletion: receiveCompletion,
            receiveValue: { response in
                print("\n--")
                print(response)
        }))
    }
    
    func makeListResourcesCall(page: Int) {
        cancelables.append(API.shared.getListResources(page: page)
        .sink(
            receiveCompletion: receiveCompletion,
            receiveValue: { response in
                print("\n--")
                print(response)
        }))
    }
    
    // MARK: - Helpers
    
    func makeSingleResourceCall(id: Int) {
        cancelables.append(API.shared.getSingleResource(id: id)
        .sink(
            receiveCompletion: receiveCompletion,
            receiveValue: { response in
                print("\n--")
                print(response)
        }))
    }
    
    // Common for the example
    
    func receiveCompletion(completion: Subscribers.Completion<Error>) {
        switch completion {
            case .finished:
            break
            case .failure(let error):
                switch error {
                    case AutobahnError.request(let code, _, _):
                        if code == 404 {
                            print("\n--")
                            print("Not found")
                        }
                    case AutobahnError.unknown(let request):
                        print("\n--")
                        print("Unknown error in \(request.httpMethod ?? "-") call to \(request.url?.absoluteString ?? "-")")
                    case AutobahnError.canNotDecode(let data, let request):
                        print("Cannot parse data in \(request.httpMethod ?? "-") call to \(request.url?.absoluteString ?? "-")")
                        print(String(data: data, encoding: .utf8) ?? "Not UTF 8 string response.")
                    default:
                        let error = error as NSError
                        print("\n--")
                        print(error.code)
                        print(error)
                        print(error.localizedDescription)
                }
        }
    }
    
    
}

