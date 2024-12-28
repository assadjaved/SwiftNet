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
    
    // base url
    var baseUrl: String { get }
    
    // path
    var path: String { get }
    
    // request method
    var method: SwiftNetRequestMethod { get }
    
    // common request headers - e.g. authorization, content type, accept
    var headers: [SwiftNetRequestHeader] { get }
    
    // additional request headers - e.g. custom headers
    var additionalHeaders: [SwiftNetRequestHeader] { get }
    
    // request parameters
    var parameters: [SwiftNetRequestParameter] { get }
    
    // decode response
    func decode(data: Data) throws -> Response
}
