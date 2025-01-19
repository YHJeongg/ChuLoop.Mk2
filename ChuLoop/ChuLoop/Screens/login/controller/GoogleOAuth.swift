//
//  GoogleOAuth.swift
//  ChuLoop
//

import SwiftUI
import GoogleSignIn

class GoogleOAuth: ObservableObject {
    @Published var errorMessage: String?
    @Published var givenName: String?
    @Published private var loginController = LoginController()
    
    func checkUserInfo() {
        if GIDSignIn.sharedInstance.currentUser != nil {
            let user = GIDSignIn.sharedInstance.currentUser
            guard let user = user else {
                return
            }
            
            let data: UserDataModel = UserDataModel(accessToken: user.accessToken.tokenString)

            loginController.loginWithGoogle(data: data)
            
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
