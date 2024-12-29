//
//  SwiftNetNetwork.swift
//  SwiftNetApp
//
//  Created by Asad Javed on 02/12/2024.
//

import Foundation

class SwiftNetNetwork: SwiftNetNetworkType {
    enum Constants {
        static let serverError = "Server error"
    }
    
    let httpClient: SwiftNetHttpClient
    private var httpAuthorization: SwiftNetAuthorization?
    
    init(
        httpClient: SwiftNetHttpClient = URLSession.shared,
        httpAuthorization: SwiftNetAuthorization? = nil
    ) {
        self.httpClient = httpClient
        self.httpAuthorization = httpAuthorization
    }
    
    func setHttpAuthorization(_ httpAuthorization: SwiftNetAuthorization) {
        self.httpAuthorization = httpAuthorization
    }
    
    func createRequestURL(from request: any SwiftNetRequest) -> URLRequest? {
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
        var requestHeaders = request.headers + request.additionalHeaders
        if let token = httpAuthorization?.tokenRepository.accessToken {
            requestHeaders.append(.authorization(token: token))
        }
        for requestHeader in requestHeaders {
            let httpHeader = requestHeader.httpHeader
            urlRequest.setValue(httpHeader.value, forHTTPHeaderField: httpHeader.key)
        }
        
        // set body
        urlRequest.httpBody = requestBody
        
        // set timeout
        urlRequest.timeoutInterval = 30 // 30 seconds
        
        return urlRequest
    }
    
    func scanResponseForError(_ statusCode: Int, responseJSON: [String: Any]?) -> SwiftNetError? {
        func firstValidValue(from possibleValues: [Any?]) -> String? {
            possibleValues.compactMap {
                if let stringValue = $0 as? String {
                    return stringValue
                } else if let intValue = $0 as? Int {
                    return String(intValue)
                }
                return nil
            }.first
        }
        
        let errorCode = firstValidValue(from: [
            responseJSON?["error_code"],
            responseJSON?["errorCode"],
            responseJSON?["err"]
        ])
        
        let message = firstValidValue(from: [
            responseJSON?["message"],
            responseJSON?["msg"],
            responseJSON?["errorMsg"],
            responseJSON?["errorMessage"],
            responseJSON?["error_msg"],
            responseJSON?["error_message"]
        ]) ?? Constants.serverError
        
        switch statusCode {
        // handle success status code
        case 200...299:
            if let errorCode {
                return .serverError(errorCode: errorCode, message: message)
            }
        // handle authorization error
        case 401, 403:
            return .failedAuthorization
        // handle other status codes
        default:
            return .serverError(errorCode: errorCode ?? String(statusCode), message: message)
        }
        
        return nil
    }
}
