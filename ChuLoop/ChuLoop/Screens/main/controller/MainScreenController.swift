//
//  MainScreenController.swift
//  ChuLoop
//
//  Created by Anna Kim on 1/28/25.
//

import SwiftUI

@MainActor
class MainScreenController: ObservableObject {
    @Published var isNavigatingToAddScreen: Bool = false
    @Published var isLoading: Bool = true
    @Published var contents: [MainModel] = []
    @Published var responseModel: [String: Any]?
    
    private let mainService = MainService()

    func fetchTimelineData() {
        Task { @MainActor in
            let queryParameters: [String: String] = ["search": ""]
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

    // Add Screen으로 이동
    func goToAddScreen() {
        isNavigatingToAddScreen = true
    }
    
    // 이전 화면으로 돌아가기
    func goBack() {
        isNavigatingToAddScreen = false
    }
}
