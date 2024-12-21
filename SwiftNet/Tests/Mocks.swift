//
//  Mocks.swift
//  Pods
//
//  Created by Asad Javed on 17/12/2024.
//

@testable import SwiftNet

class SwiftNetNetworkMock: SwiftNetNetworkType {
    var error: SwiftNetError?
    
    func process<T: SwiftNetRequest>(_ request: T, completion: @escaping (Result<Data, SwiftNetError>) -> Void) {
        if let error {
            completion(.failure(error))
        } else {
            let response = SwiftNetRequestMock.ResponseMockDto(foo: "foo", bar: "bar")
            let data = try! JSONEncoder().encode(response)
            completion(.success(data))
        }
    }
    
    func process<T: SwiftNetRequest>(_ request: T) async throws -> Data {
        if let error {
            throw error
        } else {
            let response = SwiftNetRequestMock.ResponseMockDto(foo: "foo", bar: "bar")
            let data = try! JSONEncoder().encode(response)
            return data
        }
    }
}

class SwiftNetRequestMock: SwiftNetRequest {
    struct ResponseMockDto: Codable, Equatable {
        let foo: String
        let bar: String
    }
    
    typealias Response = ResponseMockDto
    
    var baseUrl: String = "https://foo.bar.com"
    
    var path: String = "/foo-bar"
    
    var method: SwiftNetRequestMethod = .get
    
    var headers: [SwiftNetRequestHeader] = [
        .contentType(value: .json),
        .accept(value: .json),
        .authorization(token: "Bearer <some-foo-bar-token>")
    ]
    
    var additionalHeaders: [SwiftNetRequestHeader] = []
    
    var parameters: [SwiftNetRequestParameter] = [
        .query(key: "foo", value: "foo"),
        .query(key: "bar", value: "bar"),
        .body(data: try! JSONEncoder().encode(ResponseMockDto(foo: "foo", bar: "bar")))
    ]
    
    var forceDecodingError: Bool = false
    
    func decode(data: Data) throws -> Response {
        guard !forceDecodingError else {
            throw NSError(domain: "com.swiftnet.mock", code: 1, userInfo: nil)
        }
        return try JSONDecoder().decode(Response.self, from: data)
    }
}
