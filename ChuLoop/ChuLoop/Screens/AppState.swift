//
//  AppState.swift
//  ChuLoop
//
//  Created by Anna Kim on 1/27/25.
//
import SwiftUI

// 자동로그인
class AppState: ObservableObject {
    @Published var isLoggedIn: Bool = false
    
    init() {
        self.isLoggedIn = checkLoginStatus()
        print("init check : \(self.isLoggedIn)")
    }
    
    func checkLoginStatus() -> Bool {
        if KeychainHelper.shared.read(service: "com.chuloop.auth", account: "accessToken") != nil {
            self.isLoggedIn = true;
            
            return true
        }
        self.isLoggedIn = false;
        return false
    }
    
    func logout() {
            // 로그아웃 시, 토큰 삭제 등 필요한 작업을 진행합니다.
            // 예시로 Keychain에서 토큰 삭제
            KeychainHelper.shared.delete(service: "com.yourapp.auth", account: "accessToken")
            
            // 로그인 상태를 false로 설정
            self.isLoggedIn = false
        }
}
