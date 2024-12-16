//
//  SwiftNetType.swift
//  Pods
//
//  Created by Asad Javed on 04/12/2024.
//

import Foundation

public protocol SwiftNetType {
    func request<T: SwiftNetRequest>(_ request: T, completion: @escaping (Result<T.Response, SwiftNetError>) -> Void)
    func request<T: SwiftNetRequest>(_ request: T) async throws -> T.Response
}
