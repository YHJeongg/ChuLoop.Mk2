//
//  MainService.swift
//  ChuLoop
//

import Foundation

final class MainService {
    func getMainScreenData(queryParameters: [String: String]? = nil) async -> ResponseVO {
        return await HTTP.shared.get(
            endpoint: ApisV1.edPost.rawValue,
            queryParameters: queryParameters
        )
    }
    
    func deleteEdPost(postId: String) async -> ResponseVO {
        return await HTTP.shared.delete(
            endpoint: ApisV1.edPost.rawValue + "/\(postId)", 
            body: ""
        )
    }
    
    func postEdPost<T: Encodable>(data: T) async -> ResponseVO {
        return await HTTP.shared.post(endpoint: ApisV1.edPost.rawValue, body: data)
    }
    
    func postEdPostImage<T: Encodable>(imageData: T) async -> ResponseVO {
        return await HTTP.shared.post(endpoint: ApisV1.edPostImage.rawValue, body: imageData)
    }
    
    func shareEdPost(postId: String) async -> ResponseVO {
        let body: [String: String] = [:]
        return await HTTP.shared.put(
            endpoint: ApisV1.edPostShare.rawValue + "/\(postId)",
            body: body
        )
    }
    
    func unshareEdPost(postId: String) async -> ResponseVO {
        let body: [String: String] = [:]
        return await HTTP.shared.put(
            endpoint: ApisV1.edPostUnshare.rawValue + "/\(postId)",
            body: body
        )
    }
}
