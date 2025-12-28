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
    
    @StateObject var commonController = CommonController.shared  // @StateObject로 관리

    
    init() {
        configNavigationBarAppearance()
//        configTabView()
        NaverLoginController().configure()
        KakaoLoginController().configure()
    }
    
    var body: some Scene {
        WindowGroup {
            if(!commonController.isLoggedOut) {
                MainTabView()
                    .onAppear(perform: UIApplication.shared.addTapGestureRecognizer)
                    .environmentObject(commonController)  // 여기에 추가
                    
            } else {
                LoginScreen()
//                    .environmentObject(commonController)
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
                    .environmentObject(commonController)  // 로그인 화면에서도 유지
            }
            
        }
    }
}
