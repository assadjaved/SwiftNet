//
//  GetToDoItemRequest.swift
//  SwiftNetApp
//
//  Created by Asad Javed on 02/12/2024.
//

import SwiftNet

class GetToDoItemRequest: BaseToDoRequest<GetToDoItemDTO> {
    private let id: Int
    
    init(id: Int) {
        self.id = id
    }
    
    override var path: String {
        "todos/\(id)"
    }
    
    override var method: SwiftNetRequestMethod {
        .get
    }
    
    override var parameters: [SwiftNetRequestParameter] {
        [.query(key: "foo", value: "bar")]
    }
}

struct GetToDoItemDTO: Decodable {
    let userId: Int
    let id: Int
    let title: String
    let completed: Bool
}
