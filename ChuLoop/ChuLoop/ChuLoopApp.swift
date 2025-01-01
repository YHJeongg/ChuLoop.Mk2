//
//  ChuLoopApp.swift
//  ChuLoop
//

import SwiftUI

@main
struct ChuLoopApp: App {
    init() {
        configNavigationBarAppearance()
    }
    
    var body: some Scene {
        WindowGroup {
            LoginScreen()
        }
    }
}
