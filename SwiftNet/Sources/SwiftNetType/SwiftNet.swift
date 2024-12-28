//
//  SwiftNet.swift
//  SwiftNetApp
//
//  Created by Asad Javed on 01/12/2024.
//

import Foundation

public class SwiftNet: SwiftNetType {
    let network: SwiftNetNetworkType
    
    public init(httpAuthorization: SwiftNetAuthorization? = nil) {
        self.network = SwiftNetNetwork(httpAuthorization: httpAuthorization)
    }
    
    public func setHttpAuthorization(_ httpAuthorization: SwiftNetAuthorization) {
        network.setHttpAuthorization(httpAuthorization)
    }
    
    // Internal init for testing
    init(network: SwiftNetNetworkType) {
        self.network = network
    }
}
