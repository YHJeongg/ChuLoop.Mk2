//
//  MapService.swift
//  ChuLoop
//

import Foundation

class MapService {
    func fetchMapMarkers(queryParameters: [String: String]) async -> ResponseVO {
        return await HTTP.shared.get(
            endpoint: ApisV1.mapPost.rawValue,
            queryParameters: queryParameters
        )
    }
}
