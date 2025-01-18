//
//  ChuLoopApp.swift
//  ChuLoop
//

import SwiftUI
import GoogleSignIn
import NaverThirdPartyLogin

@main
struct ChuLoopApp: App {
    init() {
        configNavigationBarAppearance()
    }
    
    var body: some Scene {
        WindowGroup {
            LoginScreen()
                .onOpenURL { url in
                    GIDSignIn.sharedInstance.handle(url)
                }
                .onOpenURL(perform: { url in
                    NaverThirdPartyLoginConnection
                        .getSharedInstance()
                        .receiveAccessToken(url)
                })
        }
    }
}
