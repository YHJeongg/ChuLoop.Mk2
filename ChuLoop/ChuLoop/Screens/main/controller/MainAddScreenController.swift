//
//  MainAddScreenController.swift
//  ChuLoop
//
//  Created by Anna Kim on 1/31/25.
//

import SwiftUI

class MainAddScreenController: ObservableObject {
    var mainService = MainService()
    
    @Published var restaurantName: String = ""
    @Published var address: String = ""
    @Published var review: String = ""
    @Published var date: Date = Date.now
    @Published var images: [UIImage] = []
    @Published var selectedData: [Data] = []
    
    @Published var showDatePicker: Bool = false
    @Published var openPhoto: Bool = false
    
    @Published var selectedDate: String = {
        return formatdotYYYYMMDDEEE(Date.now)
    }()
    
    @Published var rating: Int = 0
    @Published var selectedCategory: String = "한식"
    
    @Published var imageEmpty: Bool = false
    @Published var titleEmpty: Bool = false
    @Published var addressEmpty: Bool = false
    @Published var reviewEmpty: Bool = false
    @Published var dateEmpty: Bool = false
    
    
    func checkEmpty() -> Bool {
        if(images.isEmpty) {
            imageEmpty = true
        }
        if(restaurantName.isEmpty) {
            titleEmpty = true
        }
        if(address.isEmpty) {
            addressEmpty = true
        }
        if(review.isEmpty) {
            reviewEmpty = true
        }
        return titleEmpty || addressEmpty || reviewEmpty
    }
    
    func submit(mainController: MainScreenController) {
        
        if(checkEmpty()) {
            return
        }
        //        mainController.goBack()
        
        postEdPostImage(mainController: mainController)
    }
    func postEdPost(mainController: MainScreenController) {
        Task {
            let requestData = EdPostRequestModel(
                title: restaurantName,
                category: selectedCategory,
                address: address,
                date: formatdotYYYYMMDD(date),
                images: selectedImageUrl,
                description: review,
                rating: rating
            )
            
            let result = await mainService.postEdPost(data: requestData)
            
            if(result.success) {
                await mainController.goBack()
                
            } else {
                print(result.message)
            }
        }
    }
    
    
    var selectedImageUrl: [String] = []

    func postEdPostImage(mainController: MainScreenController) {
        Task {
            // selectedData의 이미지 데이터를 하나씩 서버에 업로드
            for imageData in selectedData {
                // 서버에 이미지를 업로드하는 함수 호출
                if let imageUrl = await uploadImageToServer(imageData: imageData) {
                    // 서버에서 받은 URL을 selectedImageUrl에 추가
                    selectedImageUrl.append(imageUrl)
                } else {
                    print("Failed to upload image")
                }
            }
            
            // 모든 이미지 업로드 완료 후 처리 (예: 화면 전환)
            if !selectedImageUrl.isEmpty {
                // 여기에 원하는 후속 처리를 할 수 있음 (예: goBack 호출)
                postEdPost(mainController: mainController)
            }
        }
    }

    // 서버에 이미지를 업로드하는 함수
    func uploadImageToServer(imageData: Data) async -> String? {
        // 서버에 업로드할 URL 및 요청 설정
        let url = URL(string: "\(Constants.BASE_URL)\(ApisV1.edPostImage.rawValue)")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("multipart/form-data", forHTTPHeaderField: "Content-Type")
        
        let boundary = "Boundary-\(UUID().uuidString)"
        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        
        let body = createMultipartBody(imageData: imageData, boundary: boundary)
        request.httpBody = body
        
        // 서버 응답 처리
        do {
            let (data, response) = try await URLSession.shared.data(for: request)
            
            // 서버 응답을 디코딩
            let decoder = JSONDecoder()
            if let imageUploadResponse = try? decoder.decode(ImageUploadResponse.self, from: data),
               imageUploadResponse.status == 200 {
                // 서버에서 받은 첫 번째 imageUrl 반환
                return imageUploadResponse.data.first
            } else {
                
                print("Failed to upload image or invalid response")
                return nil
            }
 
        } catch {
            print("Error uploading image: \(error)")
            return nil
        }
    }

    // 이미지 데이터를 FormData 형식으로 변환하는 함수
    func createMultipartBody(imageData: Data, boundary: String) -> Data {
        var body = Data()
        
        // 이미지 데이터 추가
        body.append("--\(boundary)\r\n".data(using: .utf8)!) // Boundary 추가
        body.append("Content-Disposition: form-data; name=\"file\"; filename=\"image.jpg\"\r\n".data(using: .utf8)!) // Content-Disposition 헤더
        body.append("Content-Type: image/jpeg\r\n\r\n".data(using: .utf8)!) // Content-Type 헤더
        body.append(imageData) // 이미지 데이터
        body.append("\r\n".data(using: .utf8)!) // 줄바꿈
        
        body.append("--\(boundary)--\r\n".data(using: .utf8)!) // Boundary 종료
        
        return body
    }
}


struct ImageUploadResponse: Decodable {
    let status: Int
    let code: String
    let message: String
    let data: [String]  // imageUrl 배열
}
