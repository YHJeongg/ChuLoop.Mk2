//
//  UserService.swift
//  ChuLoop
//
//  Created by Anna Kim on 3/9/25.
//
import Foundation

final class UserService {
    func getUserData() async -> ResponseVO {
        return await HTTP.shared.get(
            endpoint: ApisV1.userInfo.rawValue
        )
    }
    
    func putUserNickname(userId: String, nickname: String) async -> ResponseVO {
        return await HTTP.shared.put(
            endpoint: ApisV1.user.rawValue + "/\(userId)/\(nickname)"
        )
    }
    
    func postUserImage<T: Encodable>(imageData: T) async -> ResponseVO {
        return await HTTP.shared.post(
            endpoint: ApisV1.userImage.rawValue,
            body: imageData
        )
    }

    
}
