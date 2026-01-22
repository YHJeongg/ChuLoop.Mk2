//
//  WillService.swift
//  ChuLoop
//

import Foundation

class WillService {
    // 맛집 리스트 조회
    func fetchWillPosts(queryParameters: [String: String]? = nil) async -> ResponseVO {
        return await HTTP.shared.get(
            endpoint: ApisV1.willPost.rawValue,
            queryParameters: queryParameters
        )
    }

    // 맛집 게시글 저장
    func saveWillPost(data: WillSaveRequest) async -> ResponseVO {
        return await HTTP.shared.post(
            endpoint: ApisV1.willPost.rawValue,
            body: data
        )
    }
    
    // 맛집 이미지 업로드
    func uploadWillImage(imageData: Data) async -> [String]? {
        let result = await CommonController.shared.uploadImageToServer(
            endpoint: ApisV1.willImage.rawValue,
            imageData: imageData
        )
        
        if let urlString = result as? String {
            return [urlString]
        }

        return nil
    }
}
