//
//  MainScreenController.swift
//  ChuLoop
//

import SwiftUI

@MainActor
class MainScreenController: ObservableObject {
    @Published var isNavigatingToAddScreen: Bool = false
    @Published var isLoading: Bool = false  // 초기값 false로 변경
    @Published var contents: [MainModel] = []
    @Published var responseModel: [String: Any]?
    @Published var selectedPost: MainModel?

    private let mainService = MainService()
    private var page: Int = 1
    private let limit: Int = 5
    private var hasMorePages: Bool = true  // 데이터가 더 있는지 여부

    func getMainPost(searchText: String = "", isRefreshing: Bool = false) {
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
            let response = await mainService.getMainScreenData(queryParameters: queryParameters)

            guard response.success else {
                print("데이터 요청 실패: \(response.message ?? "알 수 없는 오류")")
                isLoading = false
                return
            }

            if let data = response.data {
                do {

                    let jsonData = try JSONSerialization.data(withJSONObject: data)
                    let mainResponse = try JSONDecoder().decode(MainResponseModel.self, from: jsonData)

                    let responseVO = ResponseVO(status: response.status ?? 0, code: response.code, message: response.message, data: data)
                    if let dictionaryData = responseVO.data as? [String: Any] {
                        self.responseModel = dictionaryData
                    } else {
                        self.responseModel = nil
                    }

                    
                    DispatchQueue.main.async {
                        if isRefreshing {
                            self.contents = mainResponse.contents
                        } else {
                            self.contents.append(contentsOf: mainResponse.contents)
                        }
                        self.hasMorePages = mainResponse.contents.count == self.limit
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

    // 삭제와 공유는 그대로
    func deletePost(postId: String) {
        Task {
            let response = await mainService.deleteEdPost(postId: postId)
            
            if response.success {
                DispatchQueue.main.async {
                    self.contents.removeAll { $0.id == postId }
                }
            } else {
                print("삭제 실패: \(response.message ?? "알 수 없는 오류")")
            }
        }
    }

    // 공유하기와 공유 취소 처리
    func sharePost(postId: String, isShared: Bool) {
        Task {
            if isShared {
                // 공유 취소
                let response = await mainService.shareEdPost(postId: postId)
                
                if response.success {
                    DispatchQueue.main.async {
                        if let index = self.contents.firstIndex(where: { $0.id == postId }) {
                            self.contents[index].shared = false
                        }
                    }
                } else {
                    print("공유 취소 실패: \(response.message ?? "알 수 없는 오류")")
                }
            } else {
                // 공유하기
                let response = await mainService.unshareEdPost(postId: postId)
                
                if response.success {
                    DispatchQueue.main.async {
                        if let index = self.contents.firstIndex(where: { $0.id == postId }) {
                            self.contents[index].shared = true
                        }
                    }
                } else {
                    print("공유 실패: \(response.message ?? "알 수 없는 오류")")
                }
            }
        }
    }

    // Add Screen으로 이동
    func goToAddScreen() {
        isNavigatingToAddScreen = true
    }
    
    // 이전 화면으로 돌아가기
    func goBack() {
        isNavigatingToAddScreen = false
    }
    
    func getMainSheetPost(postId: String) {
        Task { @MainActor in
            let response = await mainService.getMainSheetScreenData(postId: postId)
            
            guard response.success, let data = response.data else {
                print("데이터 요청 실패: \(response.message ?? "알 수 없는 오류")")
                return
            }
            
            do {
                let jsonData = try JSONSerialization.data(withJSONObject: data)
                let post = try JSONDecoder().decode(MainModel.self, from: jsonData)
                self.selectedPost = post
            } catch {
                print("디코딩 오류: \(error)")
            }
        }
    }
}
