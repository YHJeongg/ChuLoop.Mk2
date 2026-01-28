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
        // 중복 호출 방지 및 페이지네이션 체크
        guard !isLoading, hasMorePages || isRefreshing else { return }

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
                    self.contents = shareResponse.contents
                } else {
                    let newItems = shareResponse.contents.filter { newItem in
                        !self.contents.contains(where: { $0.id == newItem.id })
                    }
                    self.contents.append(contentsOf: newItems)
                }

                // 다음 페이지 여부 확인
                self.hasMorePages = shareResponse.contents.count == self.limit
                if self.hasMorePages { self.page += 1 }
                
            } catch {
                print("디코딩 에러: \(error)")
            }
            
            self.isLoading = false
        }
    }
}
