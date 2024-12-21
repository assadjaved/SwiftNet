//
//  SwiftNetTests.swift
//  Pods
//
//  Created by Asad Javed on 16/12/2024.
//

import Quick
import Nimble
@testable import SwiftNet

class SwiftNetTests: AsyncSpec {
    
    // MARK: - SwiftNet
    
    func test_SwiftNetInit() {
        let swiftNet = SwiftNet()
        expect(swiftNet).toNot(beNil())
        expect(swiftNet.network).toNot(beNil())
        expect(swiftNet).to(beAKindOf(SwiftNetType.self))
        expect(swiftNet.network).to(beAKindOf(SwiftNetNetworkType.self))
    }
    
    
    // MARK: - SwiftNet+Result
    
    func test_SwiftNet_Result_Success() {
        let network = SwiftNetNetworkMock()
        let swiftNet = SwiftNet(network: network)
        let request = SwiftNetRequestMock()
        
        waitUntil(timeout: .seconds(3)) { done in
            swiftNet.request(request) { result in
                expect(result).to(beSuccess { value in
                    expect(value).to(beAKindOf(SwiftNetRequestMock.ResponseMockDto.self))
                    expect(value.foo).to(equal("foo"))
                    expect(value.bar).to(equal("bar"))
                })
                done()
            }
        }
    }
    
    func test_SwiftNet_Result_Failure() {
        let network = SwiftNetNetworkMock()
        let swiftNet = SwiftNet(network: network)
        let request = SwiftNetRequestMock()
        
        network.error = .serverError(errorCode: "foo", message: "bar")
        
        waitUntil(timeout: .seconds(3)) { done in
            swiftNet.request(request) { result in
                expect(result).to(beFailure { error in
                    expect(error).to(beAKindOf(SwiftNetError.self))
                    expect(error).to(equal(SwiftNetError.serverError(errorCode: "foo", message: "bar")))
                })
                done()
            }
        }
    }
    
    func test_SwiftNet_Result_Decoding_Failure() {
        let network = SwiftNetNetworkMock()
        let swiftNet = SwiftNet(network: network)
        let request = SwiftNetRequestMock()
        
        request.forceDecodingError = true
        
        waitUntil(timeout: .seconds(3)) { done in
            swiftNet.request(request) { result in
                expect(result).to(beFailure { error in
                    expect(error).to(beAKindOf(SwiftNetError.self))
                    if case let .decodingError(error) = error, let nsError = error as NSError? {
                        expect(nsError.domain).to(equal("com.swiftnet.mock"))
                        expect(nsError.code).to(equal(1))
                    } else {
                        fail("Expected decoding error")
                    }
                })
                done()
            }
        }
    }
    
    
    // MARK: - SwiftNet+Async
    
    func test_SwiftNet_Async_Success() async {
        let network = SwiftNetNetworkMock()
        let swiftNet = SwiftNet(network: network)
        let request = SwiftNetRequestMock()
        
        await expecta(try await swiftNet.request(request)).to(
            equal(SwiftNetRequestMock.ResponseMockDto(foo: "foo", bar: "bar"))
        )
    }
    
    func test_SwiftNet_Async_Failure() async {
        let network = SwiftNetNetworkMock()
        let swiftNet = SwiftNet(network: network)
        let request = SwiftNetRequestMock()
        
        network.error = .serverError(errorCode: "foo", message: "bar")
        
        await expecta(try await swiftNet.request(request)).to(throwError { error in
            expect(error).to(matchError(SwiftNetError.serverError(errorCode: "foo", message: "bar")))
        })
    }
    
    func test_SwiftNet_Async_Decoding_Failure() async {
        let network = SwiftNetNetworkMock()
        let swiftNet = SwiftNet(network: network)
        let request = SwiftNetRequestMock()
        
        request.forceDecodingError = true
        
        await expecta(try await swiftNet.request(request)).to(throwError { error in
            expect(error).to(matchError(SwiftNetError.decodingError(error: NSError(domain: "com.swiftnet.mock", code: 1, userInfo: nil)))
            )
        })
    }
}
