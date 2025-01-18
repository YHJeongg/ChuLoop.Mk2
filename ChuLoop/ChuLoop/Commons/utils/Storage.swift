//
//  Storage.swift
//  ChuLoop
//

import Foundation

class Storage {
    static let shared = Storage()
    
    private let userDefaults = UserDefaults.standard
    
    func saveAccessToken(token: Any, key: String) {
        userDefaults.set(token, forKey: key)
    }
    
    func getAccessToken(key: String) -> String? {
        return userDefaults.string(forKey: key)
    }
    
    func removeAccessToken(key: String) {
        userDefaults.removeObject(forKey: key)
    }
}
