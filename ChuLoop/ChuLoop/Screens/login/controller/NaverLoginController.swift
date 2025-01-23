//
//  NaverLoginController.swift
//  ChuLoop
//

import SwiftUI
import NaverThirdPartyLogin

class NaverLoginController: NSObject, ObservableObject {
    @Published var isLoading: Bool = false
    @Published var loginMessage: String = ""
    @Published var errorMessage: String?
    @Published private var loginController = LoginController()
    
    private let authService = AuthSerivce()
    private let naverLoginInstance = NaverThirdPartyLoginConnection.getSharedInstance()
    
    func configure() {
        guard let urlScheme = Bundle.main.object(forInfoDictionaryKey: "NAVER_URL_SCHEMA") as? String,
              let clientId = Bundle.main.object(forInfoDictionaryKey: "NAVER_CLIENT_ID") as? String,
              let clientSecret = Bundle.main.object(forInfoDictionaryKey: "NAVER_CLIENT_SECRET") as? String else {
            self.errorMessage = "네이버 로그인 설정 오류: Secrets.xcconfig를 확인하세요."
            return
        }
        
        naverLoginInstance?.delegate = self
        naverLoginInstance?.isNaverAppOauthEnable = true
        naverLoginInstance?.isInAppOauthEnable = true
        naverLoginInstance?.serviceUrlScheme = urlScheme
        naverLoginInstance?.consumerKey = clientId
        naverLoginInstance?.consumerSecret = clientSecret
        naverLoginInstance?.appName = "ChuLoop"
    }
    
    func signIn() {
        guard let instance = naverLoginInstance else {
            self.errorMessage = "네이버 로그인 인스턴스를 초기화하지 못했습니다."
            return
        }
        isLoading = true
        instance.requestThirdPartyLogin()
        
        self.handleNaverLoginSuccess()
    }
    
    func signOut() {
        naverLoginInstance?.resetToken()
        print("네이버 로그아웃 완료")
    }
    
    private func handleNaverLoginSuccess() {
        guard let accessToken = naverLoginInstance?.accessToken else {
            self.errorMessage = "액세스 토큰을 가져오지 못했습니다."
            return
        }
        
        // 유저 데이터를 생성하여 서버로 전달
        let data = UserDataModel(accessToken: accessToken)
        loginController.login(service: .naver, data: data) // 로그인 처리

        if loginController.navigateToMain {
            self.loginMessage = "네이버 로그인 성공!"
        } else {
            self.loginMessage = "네이버 로그인 실패: \(loginController.loginMessage)"
        }
    }
    
    private func handleNaverLoginFailure(error: Error?) {
        self.errorMessage = "네이버 로그인 실패: \(error?.localizedDescription ?? "알 수 없는 오류")"
    }
}

extension NaverLoginController: NaverThirdPartyLoginConnectionDelegate {
    func oauth20ConnectionDidFinishRequestACTokenWithAuthCode() {
        handleNaverLoginSuccess()
        isLoading = false
    }
    
    func oauth20ConnectionDidFinishRequestACTokenWithRefreshToken() {
        print("네이버 토큰 갱신 성공")
        handleNaverLoginSuccess()
    }
    
    func oauth20ConnectionDidFinishDeleteToken() {
        print("네이버 토큰 삭제 완료")
    }
    
    func oauth20Connection(_ oauthConnection: NaverThirdPartyLoginConnection!, didFailWithError error: Error!) {
        handleNaverLoginFailure(error: error)
        isLoading = false
    }
}
