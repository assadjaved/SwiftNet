//
//  SwiftNet.swift
//  SwiftNetApp
//
//  Created by Asad Javed on 01/12/2024.
//

import Foundation

public class SwiftNet: SwiftNetType {
    let network: SwiftNetNetworkType
    
    public init() {
        self.network = SwiftNetNetwork()
    }
    
    init(network: SwiftNetNetworkType) {
        self.network = network
    }
}
