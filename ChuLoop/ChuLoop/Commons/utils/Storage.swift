//
//  Storage.swift
//  ChuLoop
//

import Foundation

class Storage {
    static let shared = Storage()
    
    private let userDefaults = UserDefaults.standard
    
    func saveAccessToken(_ token: String) {
        userDefaults.set(token, forKey: "AccessToken")
    }
    
    func getAccessToken() -> String? {
        return userDefaults.string(forKey: "AccessToken")
    }
    
    func removeAccessToken() {
        userDefaults.removeObject(forKey: "AccessToken")
    }
}
