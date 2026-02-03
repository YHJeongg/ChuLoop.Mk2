//
//  ShareService.swift
//  ChuLoop
//

import Foundation

class ShareService {
    func getShareScreenData(queryParameters: [String: String]? = nil) async -> ResponseVO {
        return await HTTP.shared.get(
            endpoint: ApisV1.sharePost.rawValue,
            queryParameters: queryParameters
        )
    }
    
    func likedPost(postId: String) async -> ResponseVO {
        return await HTTP.shared.post(
            endpoint: ApisV1.likedPost.rawValue + "/\(postId)",
            body: nil
        )
    }
}
