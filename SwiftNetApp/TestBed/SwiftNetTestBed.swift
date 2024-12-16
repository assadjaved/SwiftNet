//
//  SwiftNetTestBed.swift
//  SwiftNetApp
//
//  Created by Asad Javed on 01/12/2024.
//

import Foundation
import SwiftNet

class SwiftNetTestBed {
    let swiftNet: SwiftNetType
    
    init(swiftNet: SwiftNetType = SwiftNet()) {
        self.swiftNet = swiftNet
        testApi()
    }
    
    private func testApi() {
//        testGetToDoItemRequest()
        testPostToDoItemRequest()
    }
    
    private func testGetToDoItemRequest() {
        let request = GetToDoItemRequest(id: 1)
        swiftNet.request(request) { result in
            switch result {
            case .success(let response):
                print(response)
            case .failure(let error):
                print(error)
            }
        }
    }
    
    private func testPostToDoItemRequest() {
        let request = PostToDoItemRequest(
            requestDTO: PostToDoItemRequestDTO(
                title: "foo",
                body: "bar",
                userId: 1
            )
        )
        swiftNet.request(request) { result in
            switch result {
            case .success(let response):
                print(response)
            case .failure(let error):
                print(error)
            }
        }
    }
}
