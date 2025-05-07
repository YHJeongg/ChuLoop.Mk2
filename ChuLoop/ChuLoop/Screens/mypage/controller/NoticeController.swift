//
//  NoticeController.swift
//  ChuLoop
//
//  Created by Anna Kim on 2/26/25.
//

import SwiftUI

class NoticeController: ObservableObject {
    
    var notices: [NoticeModel] = []
    @Published var responseModel: [String: Any]?
    @Published var isDetailPage: Bool = false
    
    private let noticeService = NoticeService()
    
    
    func getNoticeList() {
        Task { @MainActor in
            let response = await noticeService.getNoticeList()
            
            guard response.success else {
                print("데이터 요청 실패: \(response.message ?? "알 수 없는 오류")")
                return
            }
            
            print("responses : \(response)")
            print("responses success : \(response.success)")
            print("responses success : \(response.message)")
            print("responses success : \(response.data)")
            if let data = response.data {
                let responseVO = ResponseVO(status: response.status ?? 0, code: response.code, message: response.message, data: data)
              
                if let arrayData = responseVO.data as? [[String: Any]] {
                    self.responseModel = ["data": arrayData] // 예시로 "data" 키 아래에 배열을 감싸서 저장
                    
                 
                    do {
                        let jsonData = try JSONSerialization.data(withJSONObject: arrayData, options: [])
                       
                        let notices = try JSONDecoder().decode([NoticeModel].self, from: jsonData)
                       
                        self.notices = notices
                    } catch {
                        print("Decoding error: \(error.localizedDescription)")
                    }
                }
                else {
                    self.responseModel = nil
                }
            } else {
                print("no notice data")
            }
        }
    }
    
    func goToNoticeDetail() {
        isDetailPage = true
    }
}
