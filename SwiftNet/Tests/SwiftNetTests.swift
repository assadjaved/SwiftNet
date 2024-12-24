//
//  SwiftNetTests.swift
//  Pods
//
//  Created by Asad Javed on 16/12/2024.
//

import Quick
import Nimble
import RxSwift
import RxTest
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
    
    
    // MARK: - SwiftNet+Single
    
    func test_SwiftNet_Single_Success() {
        let network = SwiftNetNetworkMock()
        let swiftNet = SwiftNet(network: network)
        let request = SwiftNetRequestMock()
        let disposeBag = DisposeBag()
        
        var receivedResponse: SwiftNetRequestMock.ResponseMockDto?
        var receivedError: Error?
        
        swiftNet.request(request)
            .subscribe { value in
                receivedResponse = value
            } onFailure: { error in
                receivedError = error
            }
            .disposed(by: disposeBag)
        
        expect(receivedResponse).toEventually(equal(SwiftNetRequestMock.ResponseMockDto(foo: "foo", bar: "bar")), timeout: .seconds(3))
        expect(receivedError).toEventually(beNil(), timeout: .seconds(3))
    }
    
    func test_SwiftNet_Single_Failure() {
        let network = SwiftNetNetworkMock()
        let swiftNet = SwiftNet(network: network)
        let request = SwiftNetRequestMock()
        let disposeBag = DisposeBag()
        
        var receivedResponse: SwiftNetRequestMock.ResponseMockDto?
        var receivedError: Error?
        
        network.error = .serverError(errorCode: "foo", message: "bar")
        
        swiftNet.request(request)
            .subscribe { value in
                receivedResponse = value
            } onFailure: { error in
                receivedError = error
            }
            .disposed(by: disposeBag)
        
        expect(receivedResponse).toEventually(beNil(), timeout: .seconds(3))
        expect(receivedError).toEventually(matchError(SwiftNetError.serverError(errorCode: "foo", message: "bar")), timeout: .seconds(3))
    }
    
    func test_SwiftNet_Single_Decoding_Failure() {
        let network = SwiftNetNetworkMock()
        let swiftNet = SwiftNet(network: network)
        let request = SwiftNetRequestMock()
        let disposeBag = DisposeBag()
        
        var receivedResponse: SwiftNetRequestMock.ResponseMockDto?
        var receivedError: Error?
        
        request.forceDecodingError = true
        
        swiftNet.request(request)
            .subscribe { value in
                receivedResponse = value
            } onFailure: { error in
                receivedError = error
            }
            .disposed(by: disposeBag)
        
        expect(receivedResponse).toEventually(beNil(), timeout: .seconds(3))
        expect(receivedError).toEventually(matchError(SwiftNetError.decodingError(error: NSError(domain: "com.swiftnet.mock", code: 1, userInfo: nil))), timeout: .seconds(3))
    }
    
    
    // MARK: - SwiftNetNetwork+Result
    
    func test_SwiftNetNetwork_Result_Success() {
        let httpClient = SwiftNetHttpClientMock()
        let network = SwiftNetNetwork(httpClient: httpClient)
        let request = SwiftNetRequestMock()
        
        httpClient.data = try! JSONEncoder().encode(SwiftNetRequestMock.ResponseMockDto(foo: "foo", bar: "bar"))
        httpClient.urlResponse = HTTPURLResponse(url: URL(string: "https://foo.bar.com")!, statusCode: 200, httpVersion: nil, headerFields: nil)
        
        waitUntil(timeout: .seconds(3)) { done in
            network.process(request) { result in
                expect(result).to(beSuccess { data in
                    expect(try! request.decode(data: data)).to(equal(SwiftNetRequestMock.ResponseMockDto(foo: "foo", bar: "bar")))
                })
            }
            done()
        }
    }
    
    func test_SwiftNetNetwork_Result_Failure_Generic_Error() {
        let httpClient = SwiftNetHttpClientMock()
        let network = SwiftNetNetwork(httpClient: httpClient)
        let request = SwiftNetRequestMock()
        
        httpClient.error = NSError.swiftNetMockError
        
        waitUntil(timeout: .seconds(3)) { done in
            network.process(request) { result in
                expect(result).to(beFailure { error in
                    expect(error).to(matchError(SwiftNetError.genericError(message: NSError.swiftNetMockError.localizedDescription)))
                })
            }
            done()
        }
    }
    
    func test_SwiftNetNetwork_Result_Failure_Invalid_Data() {
        let httpClient = SwiftNetHttpClientMock()
        let network = SwiftNetNetwork(httpClient: httpClient)
        let request = SwiftNetRequestMock()
        
        waitUntil(timeout: .seconds(3)) { done in
            network.process(request) { result in
                expect(result).to(beFailure { error in
                    expect(error).to(matchError(SwiftNetError.invalidData))
                })
            }
            done()
        }
    }
    
    func test_SwiftNetNetwork_Result_Failure_Invalid_Response() {
        let httpClient = SwiftNetHttpClientMock()
        let network = SwiftNetNetwork(httpClient: httpClient)
        let request = SwiftNetRequestMock()
        
        httpClient.data = Data()
        
        waitUntil(timeout: .seconds(3)) { done in
            network.process(request) { result in
                expect(result).to(beFailure { error in
                    expect(error).to(matchError(SwiftNetError.invalidResponse))
                })
            }
            done()
        }
    }
    
    func test_SwiftNetNetwork_Result_Failure_Error_In_Response_And_Status_Code_200() {
        let httpClient = SwiftNetHttpClientMock()
        let network = SwiftNetNetwork(httpClient: httpClient)
        let request = SwiftNetRequestMock()
        
        httpClient.data = ErrorMockDto(errorCode: "foo", message: "bar").toData()
        httpClient.urlResponse = HTTPURLResponse(url: URL(string: "https://foo.bar.com")!, statusCode: 200, httpVersion: nil, headerFields: nil)
        
        waitUntil(timeout: .seconds(3)) { done in
            network.process(request) { result in
                expect(result).to(beFailure { error in
                    expect(error).to(matchError(SwiftNetError.serverError(errorCode: "foo", message: "bar")))
                })
            }
            done()
        }
    }
    
    func test_SwiftNetNetwork_Result_Failure_Error_In_Response_And_Status_Code_Not_200() {
        let httpClient = SwiftNetHttpClientMock()
        let network = SwiftNetNetwork(httpClient: httpClient)
        let request = SwiftNetRequestMock()
        
        httpClient.data = ErrorMockDto(errorCode: "foo", message: "bar").toData()
        httpClient.urlResponse = HTTPURLResponse(url: URL(string: "https://foo.bar.com")!, statusCode: 500, httpVersion: nil, headerFields: nil)
        
        waitUntil(timeout: .seconds(3)) { done in
            network.process(request) { result in
                expect(result).to(beFailure { error in
                    expect(error).to(matchError(SwiftNetError.serverError(errorCode: "foo", message: "bar")))
                })
            }
            done()
        }
    }
    
    func test_SwiftNetNetwork_Result_Failure_No_Error_In_Response_And_Status_Code_Not_200() {
        let httpClient = SwiftNetHttpClientMock()
        let network = SwiftNetNetwork(httpClient: httpClient)
        let request = SwiftNetRequestMock()
        
        httpClient.data = try! JSONEncoder().encode(SwiftNetRequestMock.ResponseMockDto(foo: "foo", bar: "bar"))
        httpClient.urlResponse = HTTPURLResponse(url: URL(string: "https://foo.bar.com")!, statusCode: 500, httpVersion: nil, headerFields: nil)
        
        waitUntil(timeout: .seconds(3)) { done in
            network.process(request) { result in
                expect(result).to(beFailure { error in
                    expect(error).to(matchError(SwiftNetError.serverError(errorCode: "500", message: "Server error")))
                })
            }
            done()
        }
    }
}
