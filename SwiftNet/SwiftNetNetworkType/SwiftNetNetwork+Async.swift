//
//  SwiftNetNetwork+Async.swift
//  Pods
//
//  Created by Asad Javed on 05/12/2024.
//

extension SwiftNetNetwork {
    public func process<T: SwiftNetRequest>(_ request: T) async throws -> Data {
        // create request URL
        guard var urlRequest = createRequestURL(from: request) else {
            throw SwiftNetError.invalidURL
        }
        
        // set HTTP method
        urlRequest.httpMethod = request.method.value
        
        do {
            let (data, response) = try await URLSession.shared.data(for: urlRequest)
            
            // check response
            guard let httpResponse = response as? HTTPURLResponse else {
                throw SwiftNetError.invalidResponse
            }
            
            let statusCode = httpResponse.statusCode
            let responseJSON = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
            
            switch statusCode {
            // handle success status code
            case 200...299:
                // check if response contains an error code and message
                let errorCode = (
                    responseJSON?["error_code"] ??
                    responseJSON?["errorCode"] ??
                    responseJSON?["err"]
                ) as? String ?? ""
                if !errorCode.isEmpty {
                    let message = (
                        responseJSON?["message"] ??
                        responseJSON?["msg"]
                    ) as? String ?? Constants.serverError
                    throw SwiftNetError.serverError(errorCode: errorCode, message: message)
                }
            // handle other status codes
            default:
                let message = (
                    responseJSON?["message"] ??
                    responseJSON?["msg"]
                ) as? String ?? Constants.serverError
                throw SwiftNetError.serverError(errorCode: String(statusCode), message: message)
            }
            
            return data
            
        } catch {
            throw SwiftNetError.genericError(message: error.localizedDescription)
        }
    }
}
