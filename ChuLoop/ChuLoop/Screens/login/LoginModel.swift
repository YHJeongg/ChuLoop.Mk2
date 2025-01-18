//
//  LoginDataVO.swift
//  ChuLoop
//
//  Created by Anna Kim on 1/14/25.
//

import Foundation

// MARK: - LoginModel
struct LoginModel: Codable {
    let email: String
    let firstName: String
    let lastName: String
    let photos: String
    let socialType: String
    
    enum CodingKeys: String, CodingKey {
        case email
        case firstName
        case lastName
        case photos
        case socialType
    }
    
}


