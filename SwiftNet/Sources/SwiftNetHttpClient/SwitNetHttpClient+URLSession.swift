//
//  SwitNetHttpClient+URLSession.swift
//  Pods
//
//  Created by Asad Javed on 23/12/2024.
//

extension URLSession: SwiftNetHttpClient {
    func requestDataTask(with request: URLRequest, _ completion: @escaping @Sendable (Data?, URLResponse?, (any Error)?) -> Void) {
        let task = self.dataTask(with: request) { data, response, error in
            completion(data, response, error)
        }
        task.resume()
    }
    
    func requestData(for request: URLRequest) async throws -> (Data, URLResponse) {
        do {
            return try await self.data(for: request)
        } catch {
            throw error
        }
    }
}
