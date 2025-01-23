//
//  KakaoLoginController.swift
//  ChuLoop
//

import SwiftUI
import KakaoSDKCommon
import KakaoSDKAuth
import KakaoSDKUser

class KakaoLoginController: ObservableObject {
    @Published var isLoading: Bool = false
    @Published var loginMessage: String = ""
    @Published var errorMessage: String?
    @Published private var loginController = LoginController()
    
    private let authService = AuthSerivce()
    
    func configure() {
        guard let kakaoAppKey = Bundle.main.object(forInfoDictionaryKey: "KAKAO_APP_KEY") as? String else {
            fatalError("카카오 앱 키를 찾을 수 없습니다. Secrets.xcconfig를 확인하세요.")
        }
        
        // Kakao SDK 초기화
        KakaoSDK.initSDK(appKey: kakaoAppKey)
        print("카카오 SDK 초기화 완료")
    }
    
    func signIn() {
        isLoading = true
        if UserApi.isKakaoTalkLoginAvailable() {
            // 카카오톡으로 로그인
            UserApi.shared.loginWithKakaoTalk { [weak self] oauthToken, error in
                guard let self = self else { return }
                self.isLoading = false
                
                if let error = error {
                    self.errorMessage = "카카오톡 로그인 실패: \(error.localizedDescription)"
                } else if let oauthToken = oauthToken {
                    self.handleKakaoLoginSuccess(accessToken: oauthToken.accessToken)
                }
            }
        } else {
            // 카카오 계정으로 로그인
            UserApi.shared.loginWithKakaoAccount { [weak self] oauthToken, error in
                guard let self = self else { return }
                self.isLoading = false
                
                if let error = error {
                    self.errorMessage = "카카오 계정 로그인 실패: \(error.localizedDescription)"
                } else if let oauthToken = oauthToken {
                    self.handleKakaoLoginSuccess(accessToken: oauthToken.accessToken)
                }
            }
        }
    }
    
    func signOut() {
        UserApi.shared.logout { error in
            if let error = error {
                print("카카오 로그아웃 실패: \(error.localizedDescription)")
            } else {
                print("카카오 로그아웃 성공")
            }
        }
    }
    
    private func handleKakaoLoginSuccess(accessToken: String) {
        // 유저 데이터를 생성하여 서버로 전달
        let data = UserDataModel(accessToken: accessToken)
        loginController.login(service: .kakao, data: data)
        
        if loginController.navigateToMain {
            self.loginMessage = "카카오 로그인 성공!"
        } else {
            self.loginMessage = "카카오 로그인 실패: \(loginController.loginMessage)"
        }
    }
}
