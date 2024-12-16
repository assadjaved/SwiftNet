//
//  BaseToDoRequest.swift
//  SwiftNetApp
//
//  Created by Asad Javed on 02/12/2024.
//

import Foundation
import SwiftNet

class BaseToDoRequest<Response: Decodable>: SwiftNetRequest {
    var baseUrl: String {
        "https://jsonplaceholder.typicode.com"
    }
    
    var path: String { fatalError("override in subclass") }
    
    var method: SwiftNetRequestMethod { fatalError("override in subclass") }
    
    var headers: [SwiftNetRequestHeader] {
        [
            .contentType(value: .json),
            .accept(value: .json),
            .authorization(token: "Bearer token")
        ]
    }
    
    var additionalHeaders: [SwiftNetRequestHeader] { [] }
    
    var parameters: [SwiftNetRequestParameter] { fatalError("override in subclass") }
    
    func decode(data: Data) throws -> Response {
        let decoder = JSONDecoder()
        return try decoder.decode(Response.self, from: data)
    }
}
