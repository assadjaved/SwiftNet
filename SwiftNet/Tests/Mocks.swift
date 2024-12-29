//
//  Mocks.swift
//  Pods
//
//  Created by Asad Javed on 17/12/2024.
//

@testable import SwiftNet

class SwiftNetNetworkMock: SwiftNetNetworkType {
    var error: SwiftNetError?
    var httpAuthorization: SwiftNetAuthorization?
    
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
    
    func setHttpAuthorization(_ httpAuthorization: SwiftNetAuthorization) {
        self.httpAuthorization = httpAuthorization
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
            throw NSError.swiftNetMockError
        }
        return try JSONDecoder().decode(Response.self, from: data)
    }
}

class SwiftNetHttpClientMock: SwiftNetHttpClient {
    var error: Error?
    var urlResponse: URLResponse?
    var data: Data?
    
    func requestDataTask(with request: URLRequest, _ completion: @escaping @Sendable (Data?, URLResponse?, (any Error)?) -> Void) {
        completion(data, urlResponse, error)
    }
    
    func requestData(for request: URLRequest) async throws -> (Data, URLResponse) {
        if let error {
            throw error
        } else if let data, let urlResponse {
            return (data, urlResponse)
        } else {
            throw NSError.swiftNetMockError
        }
    }
}

extension NSError {
    static var swiftNetMockError: Error {
        NSError(domain: "com.swiftnet.mock", code: 1, userInfo: nil)
    }
}

struct ErrorMockDto: Encodable, Equatable {
    let errorCode: String
    let message: String
    
    func toData() -> Data {
        try! JSONEncoder().encode(self)
    }
}
