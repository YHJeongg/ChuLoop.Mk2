//
//  GoogleOAuth.swift
//  ChuLoop
//

import SwiftUI
import GoogleSignIn

class GoogleOAuth: ObservableObject {
    @Published var oauthUserData = GoogleUserDataVO()
    @Published var errorMessage: String?
    @Published var givenName: String?
    
    func checkUserInfo() {
        if GIDSignIn.sharedInstance.currentUser != nil {
            let user = GIDSignIn.sharedInstance.currentUser
            guard let user = user else {
                return
            }
            oauthUserData.oauthId = user.userID ?? ""
            oauthUserData.oauthEmail = user.profile?.email ?? ""
            oauthUserData.oauthFirstName = user.profile?.givenName ?? ""
            oauthUserData.oauthLastName = user.profile?.familyName ?? ""
            oauthUserData.oauthImage = user.profile?.imageURL(withDimension: 256) ?? nil
            
            if let jsonString = encodeToJSON(googleUserData: oauthUserData) {
                print(jsonString)
            }
            
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
