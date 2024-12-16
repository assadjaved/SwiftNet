//
//  SwiftNetMethod.swift
//  SwiftNetApp
//
//  Created by Asad Javed on 02/12/2024.
//

public enum SwiftNetRequestMethod {
    // HTTP methods
    case get
    case post
    case put
    case delete
    
    // HTTP method raw values
    var value: String {
        switch self {
        case .get: return "GET"
        case .post: return "POST"
        case .put: return "PUT"
        case .delete: return "DELETE"
        }
    }
}
