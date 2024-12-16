//
//  SwiftNet+Single.swift
//  Pods
//
//  Created by Asad Javed on 15/12/2024.
//

import RxSwift

extension SwiftNet {
    public func request<T: SwiftNetRequest>(_ request: T) -> Single<T.Response> {
        return Single.create { [weak self] single in
            guard let self else { return Disposables.create() }
            let task = Task(priority: .background) {
                do {
                    let response = try await self.request(request)
                    await MainActor.run { single(.success(response)) }
                } catch {
                    await MainActor.run { single(.failure(error)) }
                }
            }
            return Disposables.create {
                task.cancel()
            }
        }
    }
}
