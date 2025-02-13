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
    
    var commonController = CommonController.shared
    
    init() {
        configNavigationBarAppearance()
        configTabView()
        NaverLoginController().configure()
        KakaoLoginController().configure()
    }
    
    var body: some Scene {
        WindowGroup {
            if(commonController.getAccessToken()) {
                MainTabView()
                    .onAppear(perform: UIApplication.shared.addTapGestureRecognizer)
            } else {
                LoginScreen()
                    .environmentObject(commonController)
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
                    .onAppear(perform: UIApplication.shared.addTapGestureRecognizer)
            }
            
        }
    }
}
