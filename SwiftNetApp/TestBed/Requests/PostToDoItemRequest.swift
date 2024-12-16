//
//  PostToDoItemRequest.swift
//  SwiftNetApp
//
//  Created by Asad Javed on 02/12/2024.
//

import Foundation
import SwiftNet

class PostToDoItemRequest: BaseToDoRequest<PostToDoItemDTO> {
    private let requestDTO: PostToDoItemRequestDTO
    
    init(requestDTO: PostToDoItemRequestDTO) {
        self.requestDTO = requestDTO
    }
    
    override var path: String {
        "posts"
    }
    
    override var method: SwiftNetRequestMethod {
        .post
    }
    
    override var parameters: [SwiftNetRequestParameter] {
        let jsonEncoder = JSONEncoder()
        guard let jsonData = try? jsonEncoder.encode(requestDTO) else { return [] }
        return [.body(data: jsonData)]
    }
}

struct PostToDoItemDTO: Decodable {
    let id: Int
    let title: String
    let body: String
    let userId: Int
}

struct PostToDoItemRequestDTO: Encodable {
    let title: String
    let body: String
    let userId: Int
}
