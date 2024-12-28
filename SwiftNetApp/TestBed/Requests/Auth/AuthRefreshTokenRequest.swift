//
//  AuthRefreshToken.swift
//  SwiftNetApp
//
//  Created by Asad Javed on 27/12/2024.
//

import SwiftNet

class AuthRefreshTokenRequest: BaseAuthRequest<TokenDto> {
    
    private let requestDto: AuthRefreshRequestDto
    
    init(requestDto: AuthRefreshRequestDto) {
        self.requestDto = requestDto
    }

    override var path: String {
        "auth/refresh"
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

struct AuthRefreshRequestDto: Encodable {
    let refreshToken: String
}
    
