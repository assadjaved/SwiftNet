//
//  SwiftNetRequestHeader.swift
//  SwiftNetApp
//
//  Created by Asad Javed on 03/12/2024.
//

// Request headers for the network request
public enum SwiftNetRequestHeader {
    // Content-Type e.g. application/json
    case contentType(value: SwiftNetHeaderContentType)
    
    // Accept e.g. application/json
    case accept(value: SwiftNetHeaderAcceptType)
    
    // Authorization e.g. Bearer <token>
    case authorization(token: String)
    
    // Custom header
    case custom(key: String, value: String)
    
    // header key and value
    var httpHeader: (key: String, value: String) {
        switch self {
        case .contentType(let value):
            return ("Content-Type", value.rawValue)
        case .accept(let value):
            return ("Accept", value.rawValue)
        case .authorization(let token):
            return ("Authorization", token.asBearerToken())
        case let .custom (key, value):
            return (key, value)
        }
    }
}

// Content-Type header type
public enum SwiftNetHeaderContentType: String {
    case json = "application/json"
}

// Accept header type
public enum SwiftNetHeaderAcceptType: String {
    case json = "application/json"
}
