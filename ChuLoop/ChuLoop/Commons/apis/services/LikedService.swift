//
//  LikedService.swift
//  ChuLoop
//
//  Created by Anna Kim on 3/17/25.
//

import Foundation

final class LikedService {
    func getLikedPost() async -> ResponseVO {
        return await HTTP.shared.get(
            endpoint: ApisV1.likedPost.rawValue
        )
    }
}
