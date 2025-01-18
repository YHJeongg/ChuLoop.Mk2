//
//  GoogleUserDataVO.swift
//  ChuLoop
//

import SwiftUI

struct GoogleUserDataVO: Codable {
    var oauthId: String
    var oauthEmail: String
    var oauthFirstName: String
    var oauthLastName: String
    var oauthImage: URL?
    var oauthSocialType: String = "google"
    
    init(oauthId: String = "", oauthEmail: String = "", oauthFirstName: String = "", oauthLastName: String = "", oauthImage: URL? = nil) {
        self.oauthId = oauthId
        self.oauthEmail = oauthEmail
        self.oauthFirstName = oauthFirstName
        self.oauthLastName = oauthLastName
        self.oauthImage = oauthImage
    }
}

func encodeToJSON(googleUserData: GoogleUserDataVO) -> String? {
    let encoder = JSONEncoder()
    encoder.outputFormatting = .prettyPrinted
    do {
        let jsonData = try encoder.encode(googleUserData)
        return String(data: jsonData, encoding: .utf8)
    } catch {
        print("Error encoding data: \(error)")
        return nil
    }
}
