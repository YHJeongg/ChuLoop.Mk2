//
//  MainScreenController.swift
//  ChuLoop
//

import SwiftUI

@MainActor
class MainScreenController: ObservableObject {
    @Published var isNavigatingToAddScreen: Bool = false
    @Published var isLoading: Bool = true
    @Published var contents: [MainModel] = []
    @Published var responseModel: [String: Any]?

    private let mainService = MainService()

    // 기존의 fetchTimelineData 수정
    func fetchTimelineData(searchText: String = "") {
        Task { @MainActor in
            let queryParameters: [String: String] = ["searchWord": searchText]
            let response = await mainService.getMainScreenData(queryParameters: queryParameters)
            
            guard response.success else {
                print("데이터 요청 실패: \(response.message ?? "알 수 없는 오류")")
                isLoading = false
                return
            }
            
            if let data = response.data {
                do {
                    let responseVO = ResponseVO(status: response.status ?? 0, code: response.code, message: response.message, data: data)
                    self.responseModel = responseVO.data
                    
                    if let data = responseVO.data {
                        let jsonData = try JSONSerialization.data(withJSONObject: data)
                        let mainResponse = try JSONDecoder().decode(MainResponseModel.self, from: jsonData)
                        self.contents = mainResponse.contents
                    }
                } catch {
                    print("디코딩 오류: \(error)")
                }
            }
            isLoading = false
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
    
    func sharePost(postId: String) {
        Task {
            let response = await mainService.shareEdPost(postId: postId)
            
            if response.success {
                DispatchQueue.main.async {
                    if let index = self.contents.firstIndex(where: { $0.id == postId }) {
                        self.contents[index].shared.toggle()
                    }
                }
            } else {
                print("공유 실패: \(response.message ?? "알 수 없는 오류")")
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
}
