//
//  BaseAuthRequest.swift
//  SwiftNetApp
//
//  Created by Asad Javed on 27/12/2024.
//

import SwiftNet

class BaseAuthRequest<Response: Decodable>: SwiftNetRequest {
    
    var baseUrl: String {
        "https://dummyjson.com"
    }
    
    var path: String {
        fatalError("override in subclass")
    }
    
    var method: SwiftNetRequestMethod {
        fatalError("override in subclass")
    }
    
    var headers: [SwiftNetRequestHeader] = [
        .contentType(value: .json)
    ]
    
    var additionalHeaders: [SwiftNetRequestHeader] {
        []
    }
    
    var parameters: [SwiftNetRequestParameter] {
        []
    }
    
    func decode(data: Data) throws -> Response {
        let decoder = JSONDecoder()
        return try decoder.decode(Response.self, from: data)
    }
}
