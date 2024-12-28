//
//  SwiftNetError+Equatable.swift
//  Pods
//
//  Created by Asad Javed on 17/12/2024.
//

extension SwiftNetError: Equatable {
    public static func == (lhs: SwiftNetError, rhs: SwiftNetError) -> Bool {
        switch (lhs, rhs) {
        case (.invalidURL, .invalidURL):
            return true
        case (.invalidData, .invalidData):
            return true
        case (.invalidResponse, .invalidResponse):
            return true
        case (.genericError(let messageLhs), .genericError(let messageRhs)):
            return messageLhs == messageRhs
        case (.serverError(let errorCodeLhs, let messageLhs), .serverError(let errorCodeRhs, let messageRhs)):
            return errorCodeLhs == errorCodeRhs && messageLhs == messageRhs
        case (.failedAuthorization, .failedAuthorization):
            return true
        case (.decodingError(let errorLhs), .decodingError(let errorRhs)):
            return errorLhs.localizedDescription == errorRhs.localizedDescription
        default:
            return false
        }
    }
}
