//
//  SwiftNetTestBed.swift
//  SwiftNetApp
//
//  Created by Asad Javed on 01/12/2024.
//

import Foundation
import SwiftNet
import RxSwift

class SwiftNetTestBed {
    private let swiftNet: SwiftNetType
    private let disposeBag = DisposeBag()
    
    init(swiftNet: SwiftNetType = SwiftNet()) {
        self.swiftNet = swiftNet
        testApi()
    }
    
    // MARK: - Test
    
    private func testApi() {
        testGetToDoItemRequest()
        testPostToDoItemRequest()
        
        Task { @MainActor in
            await testGetToDoItemRequest_Async()
            await testPostToDoItemRequest_Async()
        }
        
        testGetToDoItemRequest_Single()
        testPostToDoItemRequest_Single()
    }
    
    // MARK: - Result
    
    private func testGetToDoItemRequest() {
        let request = GetToDoItemRequest(id: 1)
        swiftNet.request(request) { result in
            switch result {
            case .success(let response):
                print(response)
            case .failure(let error):
                print(error)
            }
        }
    }
    
    private func testPostToDoItemRequest() {
        let request = PostToDoItemRequest(
            requestDTO: PostToDoItemRequestDTO(
                title: "foo",
                body: "bar",
                userId: 1
            )
        )
        swiftNet.request(request) { result in
            switch result {
            case .success(let response):
                print(response)
            case .failure(let error):
                print(error)
            }
        }
    }
    
    
    // MARK: - Async/Await
    
    private func testGetToDoItemRequest_Async() async {
        let request = GetToDoItemRequest(id: 1)
        do {
            let response = try await swiftNet.request(request)
            print(response)
        } catch {
            print(error)
        }
    }
    
    private func testPostToDoItemRequest_Async() async {
        let request = PostToDoItemRequest(
            requestDTO: PostToDoItemRequestDTO(
                title: "foo",
                body: "bar",
                userId: 1
            )
        )
        do {
            let response = try await swiftNet.request(request)
            print(response)
        } catch {
            print(error)
        }
    }
    
    // MARK: - Single
    
    private func testGetToDoItemRequest_Single() {
        let request = GetToDoItemRequest(id: 1)
        swiftNet.request(request)
            .observe(on: MainScheduler.instance)
            .subscribe { dto in
                print(dto)
            } onFailure: { error in
                print(error)
            }
            .disposed(by: disposeBag)
    }
    
    private func testPostToDoItemRequest_Single() {
        let request = PostToDoItemRequest(
            requestDTO: PostToDoItemRequestDTO(
                title: "foo",
                body: "bar",
                userId: 1
            )
        )
        swiftNet.request(request)
            .observe(on: MainScheduler.instance)
            .subscribe { dto in
                print(dto)
            } onFailure: { error in
                print(error)
            }
            .disposed(by: disposeBag)
    }
}
