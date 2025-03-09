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
    
}
