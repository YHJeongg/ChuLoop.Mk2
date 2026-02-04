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
    
    // 좋아요 등록
    func likedPost(postId: String) async -> ResponseVO {
        return await HTTP.shared.post(
            endpoint: ApisV1.likedPost.rawValue + "/\(postId)",
            body: nil
        )
    }
    
    // 좋아요 취소
    func unlikedPost(postId: String) async -> ResponseVO {
        return await HTTP.shared.delete(
            endpoint: ApisV1.likedPost.rawValue + "/\(postId)",
            body: nil
        )
    }
}
