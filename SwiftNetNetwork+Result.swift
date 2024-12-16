//
//  SwiftNetNetwork+Result.swift
//  Pods
//
//  Created by Asad Javed on 05/12/2024.
//

extension SwiftNetNetwork {
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
                    completion(.failure(.serverError(errorCode: errorCode, message: message)))
                    return
                }
            // handle other status codes
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
}
