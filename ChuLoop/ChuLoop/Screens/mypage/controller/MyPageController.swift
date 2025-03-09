//
//  MyPageController.swift
//  ChuLoop
//
//  Created by Anna Kim on 3/5/25.
//
import SwiftUI

class MyPageController: ObservableObject {
    @Published var isLoading: Bool = true
    @Published var userInfo: UserInfoModel = UserInfoModel()
    @Published var responseModel: [String: Any]?
    
    private let userSerivce = UserService()
    
    // 기존의 fetchTimelineData 수정
    func getUserInfo() {
        Task { @MainActor in
            
            let response = await userSerivce.getUserData()
            
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
                        let userInfo = try JSONDecoder().decode(UserInfoModel.self, from: jsonData)
                        self.userInfo = userInfo // @Published 변수 업데이트
                        print("userInfo : \(userInfo)")
                    }
                } catch {
                    print("디코딩 오류: \(error)")
                }
            }
            isLoading = false
        }
    }
    
}
