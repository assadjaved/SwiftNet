//
//  AuthGetUserRequest.swift
//  SwiftNetApp
//
//  Created by Asad Javed on 27/12/2024.
//

import SwiftNet

class AuthGetUserRequest: BaseAuthRequest<AuthUserDto> {
    override var path: String {
        "auth/me"
    }
    
    override var method: SwiftNetRequestMethod {
        .get
    }
}

struct AuthUserDto: Decodable {
    let id: Int
    let firstName: String
    let lastName: String
    let email: String
    let phone: String
}
