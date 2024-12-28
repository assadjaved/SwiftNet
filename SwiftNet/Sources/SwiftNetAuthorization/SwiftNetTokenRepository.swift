//
//  SwiftNetTokenRepository.swift
//  Pods
//
//  Created by Asad Javed on 26/12/2024.
//

public struct SwiftNetTokenRepository {
    // Authorization token
    let accessToken: Token
    
    // Refresh token
    let refreshToken: Token
    
    public init(accessToken: Token, refreshToken: Token) {
        self.accessToken = accessToken
        self.refreshToken = refreshToken
    }
}
