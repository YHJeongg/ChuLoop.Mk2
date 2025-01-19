//
//  GoogleOAuth.swift
//  ChuLoop
//

import SwiftUI
import GoogleSignIn

class GoogleOAuth: ObservableObject {
    @Published var isLoading: Bool = false
    @Published var loginMessage: String = ""
    @Published var navigateToMain: Bool = false
    @Published var oauthUserData = UserDataModel()
    @Published var errorMessage: String?
    @Published private var loginController = LoginController()
    
    private let authService = AuthSerivce()
    
    // 로그인 api
    func loginWithGoogle<T: Encodable>(data: T?) {
        Task { @MainActor in
            isLoading = true
            loginMessage = "로그인 중..."
            
            // api 수행
            let response = await authService.googleLogin(data: data)
            
            if response.success {
                loginMessage = "로그인 성공!"
                navigateToMain = true

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

    
    func checkUserInfo() {
        if GIDSignIn.sharedInstance.currentUser != nil {
            let user = GIDSignIn.sharedInstance.currentUser
            guard let user = user else {
                return
            }
            
            let data: UserDataModel = UserDataModel(accessToken: user.accessToken.tokenString)

            loginWithGoogle(data: data)
            
        } else {
            self.errorMessage = "error: Not Logged In"
        }
    }
    
    func signIn() {
        guard let presentingViewController = (UIApplication.shared.connectedScenes.first as? UIWindowScene)?.windows.first?.rootViewController else {
            return
        }
        
        GIDSignIn.sharedInstance.signIn(
            withPresenting: presentingViewController)
        { _, error in
            if let error = error {
                self.errorMessage = "error: \(error.localizedDescription)"
            }
            
            self.checkUserInfo()
        }
    }
    
    func signOut() {
        GIDSignIn.sharedInstance.signOut()
    }
}
