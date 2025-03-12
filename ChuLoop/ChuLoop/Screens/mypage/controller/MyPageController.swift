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
        return image.jpegData(compressionQuality: quality) // ✅ 압축 품질 조정 (기본 50%)
    }
    
    func processImageForUpload(_ image: UIImage) -> Data? {
        // ✅ 리사이징 (가로 800px, 비율 유지)
        let targetWidth: CGFloat = 800
        let scaleFactor = targetWidth / image.size.width
        let targetSize = CGSize(width: targetWidth, height: image.size.height * scaleFactor)
        
        let resizedImage = resizeImage(image, targetSize: targetSize)

        // ✅ 압축 (50%)
        return compressImage(resizedImage, quality: 0.3)
    }
    
    func getProfileImageForUpdate() {
        Task {
            guard let optimizedData = processImageForUpload(selectedImage) else {
                print("❌ 이미지 최적화 실패")
                return
            }

            let boundary = "Boundary-\(UUID().uuidString)"
            multipartData = CommonController.shared.createMultipartBody(imageData: optimizedData, boundary: boundary)

            // ✅ multipartData가 nil이면 처리 중단
            guard let multipartData = multipartData else {
                print("❌ 이미지 변환 실패")
                return
            }

            await changeProfileImage(multipartData: multipartData)
        }
    }
    
    func changeProfileImage(multipartData: Data) async {
        let result = await userSerivce.postUserImage(imageData: multipartData)

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
