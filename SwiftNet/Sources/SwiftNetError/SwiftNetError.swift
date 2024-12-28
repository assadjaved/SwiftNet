//
//  SwiftNetError.swift
//  SwiftNetApp
//
//  Created by Asad Javed on 02/12/2024.
//

import Foundation

public enum SwiftNetError: Error {
    case invalidURL
    case invalidData
    case invalidResponse
    case genericError(message: String)
    case serverError(errorCode: String, message: String)
    case failedAuthorization
    case decodingError(error: Error)
}
