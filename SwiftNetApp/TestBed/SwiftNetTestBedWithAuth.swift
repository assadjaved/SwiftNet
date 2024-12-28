//
//  SwiftNetTestBedWithAuth.swift
//  SwiftNetApp
//
//  Created by Asad Javed on 27/12/2024.
//

import SwiftNet

class SwiftNetTestBedWithAuth {
    private let swiftNet: SwiftNetType
    private var refreshToken: String?
    
    init() {
        swiftNet = SwiftNet()
        clearCache()
        testApi()
    }
    
    private func testApi() {
        Task { @MainActor in
            try await login()
            try await fetchUser()
        }
    }
    
    private func clearCache() {
        URLCache.shared.removeAllCachedResponses()
        if let cookieStorage = URLSession.shared.configuration.httpCookieStorage {
            for cookie in cookieStorage.cookies ?? [] {
                cookieStorage.deleteCookie(cookie)
            }
        }
    }
    
    private func login() async throws {
        let request = AuthLoginRequest(requestDto: LoginRequestDto(username: "emilys", password: "emilyspass"))
        do {
            let response = try await swiftNet.request(request)
            print(response)
            let tokenRepository = SwiftNetTokenRepository(accessToken: response.accessToken, refreshToken: response.refreshToken)
            swiftNet.setHttpAuthorization(
                SwiftNetAuthorization(tokenRepository: tokenRepository)
            )
            refreshToken = response.refreshToken
        } catch {
            print(error)
            throw error
        }
    }
    
    private func fetchUser() async throws {
        let request = AuthGetUserRequest()
        do {
            let response = try await swiftNet.request(request)
            print(response)
        } catch {
            print(error)
            throw error
        }
    }
    
    private func refresh(_ refreshToken: String) async throws -> SwiftNetTokenRepository {
        let request = AuthRefreshTokenRequest(requestDto: AuthRefreshRequestDto(refreshToken: refreshToken))
        do {
            let response = try await swiftNet.request(request)
            print(response)
            return SwiftNetTokenRepository(accessToken: response.accessToken, refreshToken: response.refreshToken)
        } catch {
            print(error)
            throw error
        }
    }
}
