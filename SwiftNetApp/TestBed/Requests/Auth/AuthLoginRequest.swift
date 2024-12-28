//
//  AuthLoginRequest.swift
//  SwiftNetApp
//
//  Created by Asad Javed on 27/12/2024.
//

import SwiftNet

class AuthLoginRequest: BaseAuthRequest<TokenDto> {
    
    private let requestDto: LoginRequestDto
    
    init(requestDto: LoginRequestDto) {
        self.requestDto = requestDto
    }
    
    override var path: String {
        "auth/login"
    }
    
    override var method: SwiftNetRequestMethod {
        .post
    }
    
    override var parameters: [SwiftNetRequestParameter] {
        let jsonEncoder = JSONEncoder()
        guard let jsonData = try? jsonEncoder.encode(requestDto) else { return [] }
        return [.body(data: jsonData)]
    }
}

struct TokenDto: Decodable {
    let accessToken: String
    let refreshToken: String
}

struct LoginRequestDto: Encodable {
    let username: String
    let password: String
}
