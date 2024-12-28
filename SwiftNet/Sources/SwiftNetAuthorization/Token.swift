//
//  Token.swift
//  Pods
//
//  Created by Asad Javed on 26/12/2024.
//


public typealias Token = String

extension Token {
    func asBearerToken() -> String {
        let trimmed = self.trimmingCharacters(in: .whitespaces)
        return trimmed.hasPrefix("Bearer ") ? trimmed : "Bearer \(trimmed)"
    }
}
