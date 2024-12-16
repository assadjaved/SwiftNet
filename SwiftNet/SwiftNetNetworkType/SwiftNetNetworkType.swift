//
//  SwiftNetNetworkType.swift
//  Pods
//
//  Created by Asad Javed on 04/12/2024.
//

import Foundation

public protocol SwiftNetNetworkType {
    func process<T: SwiftNetRequest>(_ request: T, completion: @escaping (Result<Data, SwiftNetError>) -> Void)
    func process<T: SwiftNetRequest>(_ request: T) async throws -> Data
}
