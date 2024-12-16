//
//  SwiftNetNetwork.swift
//  SwiftNetApp
//
//  Created by Asad Javed on 02/12/2024.
//

import Foundation

public protocol SwiftNetNetworkType {
    func process<T: SwiftNetRequest>(_ request: T, completion: @escaping (Result<Data, SwiftNetError>) -> Void)
}

public class SwiftNetNetwork: SwiftNetNetworkType {
    private enum Constants {
        static let serverError = "Server error"
    }
    
    public init() {}
    
    public func process<T: SwiftNetRequest>(_ request: T, completion: @escaping (Result<Data, SwiftNetError>) -> Void) {
        // create request URL
        guard var urlRequest = createRequestURL(from: request) else {
            completion(.failure(SwiftNetError.invalidURL))
            return
        }
        
        // set HTTP method
        urlRequest.httpMethod = request.method.value
        
        // create task
        let task = URLSession.shared.dataTask(with: urlRequest) { data, response, error in
            
            // check error
            if let error {
                completion(.failure(.genericError(message: error.localizedDescription)))
                return
            }
            
            // check data
            guard let data = data else {
                completion(.failure(.invalidData))
                return
            }
            
            // check response
            guard let httpResponse = response as? HTTPURLResponse else {
                completion(.failure(.invalidResponse))
                return
            }
            let statusCode = httpResponse.statusCode
            let responseJSON = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
            switch statusCode {
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
                    completion(.failure(.serverError(errorCode: errorCode, message: message)))
                    return
                }
            default:
                let message = (
                    responseJSON?["message"] ??
                    responseJSON?["msg"]
                ) as? String ?? Constants.serverError
                completion(.failure(.serverError(errorCode: String(statusCode), message: message)))
                return
            }
            
            completion(.success(data))
        }
        
        task.resume()
    }
    
    private func createRequestURL(from request: any SwiftNetRequest) -> URLRequest? {
        // create URL
        guard var url = URL(string: request.baseUrl) else { return nil }
        
        // create query parameters if any
        var queryParameters = [URLQueryItem]()
        var requestBody: Data?
        for parameter in request.parameters {
            switch parameter {
            case let .query(key, value):
                queryParameters.append(URLQueryItem(name: key, value: value))
            case let .body(data):
                requestBody = data
            }
        }
        
        // append path
        url.append(path: request.path)
        
        // append query parameters
        url.append(queryItems: queryParameters)
        
        // create request
        var urlRequest = URLRequest(url: url)
        
        // set headers
        for requestHeader in request.headers {
            let httpHeader = requestHeader.httpHeader
            urlRequest.setValue(httpHeader.value, forHTTPHeaderField: httpHeader.key)
        }
        
        // set body
        urlRequest.httpBody = requestBody
        
        return urlRequest
    }
}
