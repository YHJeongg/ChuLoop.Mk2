//
//  LikedPostController.swift
//  ChuLoop
//
//  Created by Anna Kim on 3/17/25.
//

import SwiftUI

class LikedPostController: ObservableObject {
    private let likedService = LikedService()
    @Published var likedPostList: [MainModel] = []
    @Published var responseModel: [String: Any]?
    
    func getLikedPost(searchText: String = "") {
        Task { @MainActor in
            let response = await likedService.getLikedPost()
            
            guard response.success else {
                print("데이터 요청 실패: \(response.message ?? "알 수 없는 오류")")
//                isLoading = false
                return
            }
            
            if let data = response.data {
                do {
                    let responseVO = ResponseVO(status: response.status ?? 0, code: response.code, message: response.message, data: data)
                    if let dictionaryData = responseVO.data as? [String: Any] {
                        self.responseModel = dictionaryData
                    } else {
                        self.responseModel = nil
                    }
                    
                    if let data = responseVO.data {
                        let jsonData = try JSONSerialization.data(withJSONObject: data)
                        let mainResponse = try JSONDecoder().decode(MainResponseModel.self, from: jsonData)
                        self.likedPostList = mainResponse.contents
                    }
                } catch {
                    print("디코딩 오류: \(error)")
                }
            }
//            isLoading = false
        }
    }

}
