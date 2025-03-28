//
//  WillService.swift
//  ChuLoop
//

import Foundation

class WillService {
    func fetchWillPosts(queryParameters: [String: String]? = nil) async -> ResponseVO {
        return await HTTP.shared.get(
            endpoint: ApisV1.willPost.rawValue,
            queryParameters: queryParameters
        )
    }
}
