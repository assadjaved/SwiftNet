//
//  SwiftNetHttpClient.swift
//  Pods
//
//  Created by Asad Javed on 23/12/2024.
//


protocol SwiftNetHttpClient {
    func requestDataTask(with request: URLRequest, _ completion: @escaping @Sendable (Data?, URLResponse?, (any Error)?) -> Void)
    func requestData(for request: URLRequest) async throws -> (Data, URLResponse)
}
