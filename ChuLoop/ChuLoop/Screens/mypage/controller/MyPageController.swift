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
    
    @Published var isLoggedOut: Bool = false
    @Published var nameIsEmpty: Bool = false
    
    private let userSerivce = UserService()
    
    @Published var openPhoto: Bool = false
    @Published var selectedImage: UIImage = UIImage()
    @Published var selectedData: Data = Data()
    @Published var multipartData: Data?
    @Published var koreanSocialType: String = ""
    
    
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
                        self.userInfo = userInfo
                        // 연동된 소셜 계정 convert
                        koreanSocialType = socialTypeToKorean(socialType: userInfo.socialType)
                        print("userInfo : \(userInfo)")
                        
                    }
                } catch {
                    print("디코딩 오류: \(error)")
                }
            }
            isLoading = false
        }
    }
    
    func changeNickname() {
        Task {
            let result = await userSerivce.putUserNickname(userId: userInfo.userId, nickname: userInfo.nickname)
            if(result.success) {
                print(result.data ?? "")
                print(result.message ?? "")
                //show toasto popup
            } else {
                print(result.status ?? "")
                print(result.data ?? "")
                print(result.message ?? "")
                //show toast popup
            }
        }
    }
    
    
    
    func resizeImage(_ image: UIImage, targetSize: CGSize) -> UIImage {
        let renderer = UIGraphicsImageRenderer(size: targetSize)
        return renderer.image { _ in
            image.draw(in: CGRect(origin: .zero, size: targetSize))
        }
    }
    
    func compressImage(_ image: UIImage, quality: CGFloat = 0.5) -> Data? {
        let compressedData = image.jpegData(compressionQuality: quality)
        print("📌 압축 후 데이터 크기: \(compressedData?.count ?? 0) bytes")
        
        if compressedData == nil {
            print("❌ 이미지 압축 실패")
        }
        
        return compressedData
    }
    
    func processImageForUpload(_ image: UIImage) -> Data? {
        // ✅ 리사이징 (가로 800px, 비율 유지)
        let targetWidth: CGFloat = 500
        let scaleFactor = targetWidth / image.size.width
        let targetSize = CGSize(width: targetWidth, height: image.size.height * scaleFactor)
        
        let resizedImage = resizeImage(image, targetSize: targetSize)
        
        // ✅ 압축 (50%)
        return compressImage(resizedImage, quality: 0.2)
    }
    
    func getProfileImageForUpdate() async {
        if let imageurl = await CommonController.shared.uploadImageToServer(endpoint: "\(ApisV1.userImage.rawValue)/\(userInfo.userId)", imageData: selectedData) {
            DispatchQueue.main.async { [unowned self] in
                self.userInfo.photos = imageurl  // ✅ UI 업데이트는 메인 스레드에서 실행!
            }
            print(imageurl)
        } else {
            print("Failed to upload image")
        }
    }
    
    func changeProfileImage(multipartData: Data) async {
        print("✅ 전송할 데이터 크기: \(multipartData.count / 1024) KB")
        let result = await userSerivce.postUserImage(userId: userInfo.userId, imageData: multipartData)
        
        if result.success {
            print(result.data ?? "")
            print(result.message ?? "")
            // ✅ 성공 시 토스트 팝업 추가
        } else {
            print("❌ 오류 발생 - 상태 코드: \(result.status ?? 0)")
            print(result.data ?? "")
            print(result.message ?? "")
            // ✅ 실패 시 토스트 팝업 추가
        }
    }
    
    
    func socialTypeToKorean(socialType: String) -> String {
        switch socialType {
        case "kakao":
            return "카카오톡"
        case "naver":
            return "네이버"
        case "google":
            return "구글"
        case "apple":
            return "애플"
        default:
            return "알 수 없음"
        }
    }
    
    //    func logout() {
    //        if KeychainHelper.shared.read(service: "com.chuloop.auth", account: "accessToken") != nil {
    //            KeychainHelper.shared.delete(service: "com.chuloop.auth", account: "accessToken")
    //            self.isLoggedOut = true
    //        }
    //
    //    }
}
