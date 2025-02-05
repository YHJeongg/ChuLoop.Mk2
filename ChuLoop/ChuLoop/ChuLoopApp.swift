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
    
    @StateObject private var loginController = LoginController()
    @State private var isAutoLogin: Bool = false
        
       
    
    init() {
//        getAccessToken()
        configNavigationBarAppearance()
        NaverLoginController().configure()
        KakaoLoginController().configure()
    }
    
    var body: some Scene {
        WindowGroup {
            if(loginController.getAccessToken()) {
                MainTabView()
            } else {
                LoginScreen()
                    .environmentObject(loginController)
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
            
//            MainTabView()
        }
    }
}
