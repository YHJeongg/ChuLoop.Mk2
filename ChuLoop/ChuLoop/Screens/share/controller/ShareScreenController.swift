//
//  ShareScreenController.swift
//  ChuLoop
//

import SwiftUI

@MainActor
class ShareScreenController: ObservableObject {
    @Published var isLoading: Bool = false
    @Published var contents: [ShareModel] = []

    private let shareService = ShareService()
    private var page: Int = 1
    private let limit: Int = 20
    private var hasMorePages: Bool = true

    func getSharePost(searchText: String = "", isRefreshing: Bool = false) {
        // 중복 호출 방지 및 페이지네이션 가능 여부 체크
        guard !isLoading else { return }
        if !isRefreshing && !hasMorePages { return }

        if isRefreshing {
            page = 1
            hasMorePages = true
        }

        isLoading = true

        Task {
            let queryParameters: [String: String] = [
                "searchWord": searchText,
                "page": "\(page)",
                "limit": "\(limit)"
            ]
            
            // 서비스 호출
            let response = await shareService.getShareScreenData(queryParameters: queryParameters)

            guard response.success, let data = response.data else {
                self.isLoading = false
                return
            }

            do {
                let jsonData = try JSONSerialization.data(withJSONObject: data)
                let shareResponse = try JSONDecoder().decode(ShareResponseModel.self, from: jsonData)

                if isRefreshing {
                    // 새로고침 시 전체 교체
                    self.contents = shareResponse.contents
                } else {
                    // 무한 스크롤 시 중복 ID 필터링 후 추가
                    let newItems = shareResponse.contents.filter { newItem in
                        !self.contents.contains(where: { $0.id == newItem.id })
                    }
                    self.contents.append(contentsOf: newItems)
                }

                // 서버에서 온 데이터 개수가 limit보다 적으면 더 이상 페이지가 없는 것으로 판단
                self.hasMorePages = shareResponse.contents.count == self.limit
                
                if self.hasMorePages {
                    self.page += 1
                }
                
            } catch {
                print("Share 디코딩 에러 (nickname 포함 여부 확인): \(error)")
            }
            
            self.isLoading = false
        }
    }
    
    // 좋아요 버튼
    func likedPost(postId: String) {
        guard let index = self.contents.firstIndex(where: { $0.id == postId }) else { return }
        
        let isCurrentlyLiked = self.contents[index].mylikes
        
        Task {
            // 이미 좋아요 상태면 취소, 아니면 등록
            let response = isCurrentlyLiked
                ? await shareService.unlikedPost(postId: postId)
                : await shareService.likedPost(postId: postId)
            
            if response.success {
                // UI 상태 업데이트
                self.contents[index].mylikes.toggle()
                self.contents[index].likes += isCurrentlyLiked ? -1 : 1
            }
        }
    }
}
