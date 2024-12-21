//
//  SwiftNet+Result.swift
//  Pods
//
//  Created by Asad Javed on 05/12/2024.
//


extension SwiftNet {
    public func request<T: SwiftNetRequest>(_ request: T, completion: @escaping (Result<T.Response, SwiftNetError>) -> Void) {
        network.process(request) { result in
            switch result {
            case .success(let data):
                do {
                    let response = try request.decode(data: data)
                    completion(.success(response))
                } catch {
                    completion(.failure(.decodingError(error: error)))
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
