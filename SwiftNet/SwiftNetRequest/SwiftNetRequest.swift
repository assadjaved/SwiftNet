//
//  SwiftNetRequest.swift
//  SwiftNetApp
//
//  Created by Asad Javed on 02/12/2024.
//

import Foundation

public protocol SwiftNetRequest {
    // response type
    associatedtype Response: Decodable
    
    var baseUrl: String { get }
    var path: String { get }
    var method: SwiftNetRequestMethod { get }
    var headers: [SwiftNetRequestHeader] { get }
    var parameters: [SwiftNetRequestParameter] { get }
    
    // decode response
    func decode(data: Data) throws -> Response
}
