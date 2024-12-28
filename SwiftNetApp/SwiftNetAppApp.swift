//
//  SwiftNetAppApp.swift
//  SwiftNetApp
//
//  Created by Asad Javed on 01/12/2024.
//

import SwiftUI

@main
struct SwiftNetAppApp: App {
    let testBed = SwiftNetTestBedWithAuth()
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
