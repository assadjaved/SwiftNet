//
//  SwiftNetParameter.swift
//  SwiftNetApp
//
//  Created by Asad Javed on 02/12/2024.
//

import Foundation

public enum SwiftNetRequestParameter {
    // query parameters
    case query(key: String, value: String)
    
    // body parameters
    case body(data: Data)
}
