//
//  GoogleLoginController.swift
//  ChuLoop
//

import SwiftUI
import GoogleSignIn

class GoogleLoginController: ObservableObject {
    @Published var isLoading: Bool = false
    @Published var loginMessage: String = ""
    @Published var errorMessage: String?
    @Published private var loginController = LoginController()
    
    private let authService = AuthSerivce()
    
    init(loginController: LoginController) {
        self.loginController = loginController
    }
    
    func checkUserInfo() {
        if GIDSignIn.sharedInstance.currentUser != nil {
            let user = GIDSignIn.sharedInstance.currentUser
            guard let user = user else {
                return
            }
            
            let data: UserDataModel = UserDataModel(accessToken: user.accessToken.tokenString)

            loginController.login(service: .google, data: data)
            
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
