//
//  SwiftNet+Async.swift
//  Pods
//
//  Created by Asad Javed on 05/12/2024.
//

extension SwiftNet {
    public func request<T>(_ request: T) async throws -> T.Response where T : SwiftNetRequest {
        do {
            let data = try await network.process(request)
            do {
                return try request.decode(data: data)
            } catch {
                throw SwiftNetError.decodingError(error: error)
            }
        } catch {
            throw error
        }
    }
}
