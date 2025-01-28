//
//  ChuLoopApp.swift
//  ChuLoop
//

import SwiftUI
import GoogleSignIn
import NaverThirdPartyLogin
import KakaoSDKAuth
import KakaoSDKCommon

@main
struct ChuLoopApp: App {
    @StateObject var appState = AppState()
    
    init() {
        configNavigationBarAppearance()
        NaverLoginController().configure()
        KakaoLoginController().configure()
    }
    
    var body: some Scene {
        WindowGroup {
//            if appState.isLoggedIn {
//                MainTabView().environmentObject(appState)
//            } else {
                LoginScreen()
                    .onOpenURL { url in
                        GIDSignIn.sharedInstance.handle(url)
                    }
                    .onOpenURL(perform: { url in
                        NaverThirdPartyLoginConnection
                            .getSharedInstance()
                            .receiveAccessToken(url)
                    })
                    .onOpenURL { url in
                        if (AuthApi.isKakaoTalkLoginUrl(url)) {
                            _ = AuthController.handleOpenUrl(url: url)
                        }
                    }
//                    .environmentObject(appState)
//            }
        }
    }
}
