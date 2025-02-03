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
}
