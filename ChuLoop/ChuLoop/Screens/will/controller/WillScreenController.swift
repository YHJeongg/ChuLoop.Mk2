//
//  WillController.swift
//  ChuLoop
//

import Foundation
import Combine

class WillScreenController: ObservableObject {
    @Published var contents: [WillModel] = []
    @Published var isLoading: Bool = false
    @Published var hasMorePages: Bool = true
    
    private var page: Int = 1
    private let limit: Int = 5
    private let willService = WillService()

    func getWillPosts(searchText: String = "", isRefreshing: Bool = false) {
        // 중복 호출 방지 + 데이터가 더 없으면 요청 중단
        guard !isLoading, hasMorePages || isRefreshing else { return }

        if isRefreshing {
            page = 1
            hasMorePages = true
            contents.removeAll()
        }

        isLoading = true

        Task { @MainActor in
            let queryParameters: [String: String] = [
                "searchWord": searchText,
                "page": "\(page)",
                "limit": "\(limit)"
            ]

            // WillService에서 데이터를 가져옴
            let response = await willService.fetchWillPosts(queryParameters: queryParameters)

            // 실패시 처리
            guard response.success else {
                print("데이터 요청 실패: \(response.message ?? "알 수 없는 오류")")
                isLoading = false
                return
            }

            if let data = response.data {
                do {
                    // JSONSerialization을 사용하여 [String: Any]에서 Data로 변환
                    let jsonData = try JSONSerialization.data(withJSONObject: data)

                    // Data를 WillResponseModel로 디코딩
                    let willResponse = try JSONDecoder().decode(WillResponseModel.self, from: jsonData)

                    DispatchQueue.main.async {
                        if isRefreshing {
                            self.contents = willResponse.contents
                        } else {
                            self.contents.append(contentsOf: willResponse.contents)
                        }
                        
                        // 더 이상 데이터가 없으면 페이징 중지
                        self.hasMorePages = willResponse.contents.count == self.limit
                        if self.hasMorePages { self.page += 1 }
                        self.isLoading = false
                    }
                } catch {
                    print("디코딩 오류: \(error)")
                    isLoading = false
                }
            } else {
                isLoading = false
            }
        }
    }
}
