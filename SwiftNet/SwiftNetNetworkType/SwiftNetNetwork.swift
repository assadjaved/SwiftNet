//
//  SwiftNetNetwork.swift
//  SwiftNetApp
//
//  Created by Asad Javed on 02/12/2024.
//

import Foundation

public class SwiftNetNetwork: SwiftNetNetworkType {
    enum Constants {
        static let serverError = "Server error"
    }
    
    public init() {}
    
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
        for requestHeader in request.headers {
            let httpHeader = requestHeader.httpHeader
            urlRequest.setValue(httpHeader.value, forHTTPHeaderField: httpHeader.key)
        }
        
        // set body
        urlRequest.httpBody = requestBody
        
        return urlRequest
    }
}
