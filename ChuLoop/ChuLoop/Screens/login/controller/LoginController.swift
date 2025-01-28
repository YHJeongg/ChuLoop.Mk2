//
//  LoginController.swift
//  ChuLoop
//

import SwiftUI
import Security

enum LoginService {
    case google
    case naver
    case kakao
    case apple
}

class LoginController: ObservableObject {
    @Published var isLoading: Bool = false
    @Published var loginMessage: String = ""
    @Published var navigateToMain: Bool = false
    @Published var oauthUserData = UserDataModel()
    
    private let authService = AuthSerivce()
    
    // 로그인 API
    func login<T: Encodable>(service: LoginService, data: T?) {
        Task { @MainActor in
            isLoading = true
            loginMessage = "로그인 중..."
            
            // api 수행
            let response: ResponseVO
            
            // 로그인 서비스에 따라 API 호출 분기
            switch service {
            case .google:
                response = await authService.googleLogin(data: data)
            case .naver:
                response = await authService.naverLogin(data: data)
            case .kakao:
                response = await authService.kakaoLogin(data: data)
            case .apple:
                response = await authService.appleLogin(data: data)
            }
            
            if response.success {
                loginMessage = "로그인 성공!"
                self.navigateToMain = true
                
                if let responseData = response.data,
                   let accessTokenData = responseData["accessToken"] as? String {
                    
                    // Keychain에 액세스 토큰 저장
                    if let accessToken = accessTokenData.data(using: .utf8) {
                        KeychainHelper.shared.save(accessToken, service: "com.chuloop.auth", account: "accessToken")
                    }
                    
                    if let refreshTokenData = responseData["refreshToken"] as? String {
                        // Keychain에 리프레시 토큰 저장
                        if let refreshToken = refreshTokenData.data(using: .utf8) {
                            KeychainHelper.shared.save(refreshToken, service: "com.chuloop.auth", account: "refreshToken")
                        }
                    }
                    
                } else {
                    print("Failed to extract access token")
                }
                
                print("navigationnnnn : \(self.navigateToMain)")
            } else {
                loginMessage = "로그인 실패: \(response.message ?? "알 수 없는 오류")"
            }
            isLoading = false
        }
    }
}
