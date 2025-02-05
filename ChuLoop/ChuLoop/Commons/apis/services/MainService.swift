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
    
    func postEdPost<T: Encodable>(data: T) async -> ResponseVO {
        return await HTTP.shared.post(endpoint: ApisV1.edPost.rawValue, body: data)
    }
    
    func postEdPostImage<T: Encodable>(imageData: T) async -> ResponseVO {
        return await HTTP.shared.post(endpoint: ApisV1.edPostImage.rawValue, body: imageData)
    }
}
