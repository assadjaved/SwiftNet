//
//  SwiftNetAuthorization.swift
//  Pods
//
//  Created by Asad Javed on 25/12/2024.
//

// Authorization token for network requests
public struct SwiftNetAuthorization {
    
    // Token repository
    let tokenRepository: SwiftNetTokenRepository
    
    // Initialize with a token repository
    public init(tokenRepository: SwiftNetTokenRepository) {
        self.tokenRepository = tokenRepository
    }
}
