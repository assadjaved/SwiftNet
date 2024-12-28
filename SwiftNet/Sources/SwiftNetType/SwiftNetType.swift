//
//  SwiftNetType.swift
//  Pods
//
//  Created by Asad Javed on 04/12/2024.
//

import Foundation
import RxSwift

public protocol SwiftNetType {
    func setHttpAuthorization(_ httpAuthorization: SwiftNetAuthorization)
    func request<T: SwiftNetRequest>(_ request: T, completion: @escaping (Result<T.Response, SwiftNetError>) -> Void)
    func request<T: SwiftNetRequest>(_ request: T) async throws -> T.Response
    func request<T: SwiftNetRequest>(_ request: T) -> Single<T.Response>
}
