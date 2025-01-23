//
//  AuthSerivce.swift
//  ChuLoop
//
//  Created by Anna Kim on 1/13/25.
//

import Foundation

final class AuthSerivce {
    func googleLogin<T: Encodable>(data: T?) async -> ResponseVO {
        do {
            let result = await HTTP.shared.post(
                endpoint: ApisV1.googleLogin.rawValue,
                body: data
            )
            return result
        }
    }
    
    func naverLogin<T: Encodable>(data: T?) async -> ResponseVO {
        do {
            let result = await HTTP.shared.post(
                endpoint: ApisV1.naverLogin.rawValue,
                body: data
            )
            return result
        }
    }
}
