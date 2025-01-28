//
//  SettingsController.swift
//  ChuLoop
//
//  Created by Anna Kim on 1/27/25.
//

import SwiftUI

class SettingsController: ObservableObject {
    @Published var isLoggedOut: Bool = false
    
    func logout() {
        if KeychainHelper.shared.read(service: "com.chuloop.auth", account: "accessToken") != nil {
            KeychainHelper.shared.delete(service: "com.chuloop.auth", account: "accessToken")
            self.isLoggedOut = true
        }
      
    }
}
