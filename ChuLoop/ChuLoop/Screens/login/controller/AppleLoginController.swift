//
//  AppleLoginController.swift
//  ChuLoop
//

import SwiftUI
import AuthenticationServices

class AppleLoginController: NSObject, ObservableObject {
    @Published var isLoading: Bool = false
    @Published var loginMessage: String = ""
    @Published var errorMessage: String?
    
    private var loginController = LoginController()
    
    func signIn() {
        let request = ASAuthorizationAppleIDProvider().createRequest()
        request.requestedScopes = [.fullName, .email]
        
        let authorizationController = ASAuthorizationController(authorizationRequests: [request])
        authorizationController.delegate = self
        authorizationController.performRequests()
    }
}

extension AppleLoginController: ASAuthorizationControllerDelegate {
    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        guard let appleIDCredential = authorization.credential as? ASAuthorizationAppleIDCredential else {
            self.errorMessage = "애플 로그인 실패: 잘못된 Credential."
            return
        }
        
        let token = String(data: appleIDCredential.identityToken ?? Data(), encoding: .utf8)
        guard let identityToken = token else {
            self.errorMessage = "애플 로그인 실패: 토큰 생성 오류."
            return
        }

        let data = UserDataModel(accessToken: identityToken)
        loginController.login(service: .apple, data: data)
    }
    
    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
        self.errorMessage = "애플 로그인 실패: \(error.localizedDescription)"
    }
}
