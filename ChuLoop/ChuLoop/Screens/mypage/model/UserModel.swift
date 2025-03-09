//
//  UserModel.swift
//  ChuLoop
//
//  Created by Anna Kim on 3/9/25.
//

import SwiftUI

/**
 {
 "refreshToken": "string",
 "userId": "string",
 "name": "string",
 "nickname": "string",
 "photos": "string",
 "email": "string",
 "socialType": "string"
 }
 */
struct UserInfoModel: Codable {
    var userId: String
    var name: String
    var nickname: String
    var photos: String
    var email: String
    var socialType: String
    
    // 기존 이니셜라이저
    init(userId: String, name: String, nickname: String, photos: String, email: String, socialType: String) {
        self.userId = userId
        self.name = name
        self.nickname = nickname
        self.photos = photos
        self.email = email
        self.socialType = socialType
    }
    
    // ✅ 기본 생성자 추가 (모든 값을 빈 문자열로 초기화)
    init() {
        self.userId = ""
        self.name = ""
        self.nickname = ""
        self.photos = ""
        self.email = ""
        self.socialType = ""
    }
}
