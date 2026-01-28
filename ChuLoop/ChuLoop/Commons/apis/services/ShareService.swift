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
}
