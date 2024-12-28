//
//  SwiftNetNetwork+Async.swift
//  Pods
//
//  Created by Asad Javed on 05/12/2024.
//

extension SwiftNetNetwork {
    func process<T: SwiftNetRequest>(_ request: T) async throws -> Data {
        // create request URL
        guard var urlRequest = createRequestURL(from: request) else {
            throw SwiftNetError.invalidURL
        }
        
        // set HTTP method
        urlRequest.httpMethod = request.method.value
        
        // make request
        let (data, response) = try await httpClient.requestData(for: urlRequest)
        
        // check response
        guard let httpResponse = response as? HTTPURLResponse else {
            throw SwiftNetError.invalidResponse
        }
        
        let statusCode = httpResponse.statusCode
        let responseJSON = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
        
        // scan response for error
        if let error = scanResponseForError(statusCode, responseJSON: responseJSON) {
            throw error
        }
        
        // return data
        return data
    }
}
