//
//  SwiftNet.swift
//  SwiftNetApp
//
//  Created by Asad Javed on 01/12/2024.
//

import Foundation

public protocol SwiftNetType {
    func request<T: SwiftNetRequest>(_ request: T, completion: @escaping (Result<T.Response, SwiftNetError>) -> Void)
}

public class SwiftNet: SwiftNetType {
    private let network: SwiftNetNetworkType
    
    public init(network: SwiftNetNetworkType = SwiftNetNetwork()) {
        self.network = network
    }
    
    public func request<T: SwiftNetRequest>(_ request: T, completion: @escaping (Result<T.Response, SwiftNetError>) -> Void) {
        network.process(request) { result in
            switch result {
            case .success(let data):
                do {
                    let response = try request.decode(data: data)
                    completion(.success(response))
                } catch {
                    completion(.failure(.decodingError(data: data, error: error)))
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
