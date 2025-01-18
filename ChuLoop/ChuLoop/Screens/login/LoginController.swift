//
//  LoginController.swift
//  ChuLoop
//
//  Created by Anna Kim on 1/13/25.
//
import SwiftUI

class LoginController: ObservableObject {
    @Published var isLoading: Bool = false
    @Published var loginMessage: String = ""
    @Published var navigateToMain: Bool = false
    
    private let authService = AuthSerivce()
    
    // 로그인 api
    func loginWithGoogle() {
        Task { @MainActor in
            isLoading = true
            loginMessage = "로그인 중..."
            
            // 데이터 모델(간단한건 안만들어도 됨)
            // 임시데이터
            let loginData: LoginModel = LoginModel(email: "abcd@gmail.com", firstName: "anna", lastName: "kim", photos: "url.com", socialType: "google")
            
            
            // api 수행
            let response = await authService.googleLogin(data: loginData)
            
            if response.success {
                loginMessage = "로그인 성공!"
                navigateToMain = true
                if let responseData = response.data,
                   let accessTokenData = responseData["accessToken"] as? String {
                    /**
                     keychain 만들어서 accessToken 로컬 저장해야됨
                     참고: https://jangsh9611.tistory.com/49
                     */

                } else {
                    print("Failed to extract access token")
                }
                
            } else {
                loginMessage = "로그인 실패: \(response.message ?? "알 수 없는 오류")"
            }
            isLoading = false
        }
    }
    
    
}
