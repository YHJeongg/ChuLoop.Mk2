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
    
    func saveWillPost(data: WillSaveRequest) async -> ResponseVO {
        return await HTTP.shared.post(
            endpoint: ApisV1.willPost.rawValue,
            body: data
        )
    }
}
