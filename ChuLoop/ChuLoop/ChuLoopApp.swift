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
    init() {
        configNavigationBarAppearance()
        NaverLoginController().configure()
        KakaoLoginController().configure()
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
                .onOpenURL { url in
                    if (AuthApi.isKakaoTalkLoginUrl(url)) {
                        _ = AuthController.handleOpenUrl(url: url)
                    }
                }
        }
    }
}
