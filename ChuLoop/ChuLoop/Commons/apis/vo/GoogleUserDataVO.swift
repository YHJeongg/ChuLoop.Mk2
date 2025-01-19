//
//  GoogleUserDataVO.swift
//  ChuLoop
//

import SwiftUI

struct GoogleUserDataVO: Codable {
    var accessToken: String
    
    init(accessToken: String = "") {
        self.accessToken = accessToken
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
