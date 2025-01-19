//
//  UserDataModel.swift
//  ChuLoop
//

import SwiftUI

struct UserDataModel: Codable {
    var accessToken: String
    
    init(accessToken: String = "") {
        self.accessToken = accessToken
    }
}

//func encodeToJSON(UserDataModel: UserDataModel) -> String? {
//    let encoder = JSONEncoder()
//    encoder.outputFormatting = .prettyPrinted
//    do {
//        let jsonData = try encoder.encode(UserDataModel)
//        return String(data: jsonData, encoding: .utf8)
//    } catch {
//        print("Error encoding data: \(error)")
//        return nil
//    }
//}
