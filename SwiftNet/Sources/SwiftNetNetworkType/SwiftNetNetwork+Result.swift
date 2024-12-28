//
//  SwiftNetNetwork+Result.swift
//  Pods
//
//  Created by Asad Javed on 05/12/2024.
//

extension SwiftNetNetwork {
    func process<T: SwiftNetRequest>(_ request: T, completion: @escaping (Result<Data, SwiftNetError>) -> Void) {
        // create request URL
        guard var urlRequest = createRequestURL(from: request) else {
            completion(.failure(SwiftNetError.invalidURL))
            return
        }
        
        // set HTTP method
        urlRequest.httpMethod = request.method.value
        
        // create task
        httpClient.requestDataTask(with: urlRequest) { [weak self] data, response, error in
            
            // check error
            if let error {
                completion(.failure(.genericError(message: error.localizedDescription)))
                return
            }
            
            // check data
            guard let data else {
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
            
            // scan response for error
            if let error = self?.scanResponseForError(statusCode, responseJSON: responseJSON) {
                completion(.failure(error))
                return
            }
            
            // return data
            completion(.success(data))
        }
    }
}
