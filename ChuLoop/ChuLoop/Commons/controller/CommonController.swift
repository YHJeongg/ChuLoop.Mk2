//
//  CommonController.swift
//  ChuLoop
//
//  Created by Anna Kim on 2/13/25.
//

import Foundation

class CommonController: ObservableObject {
    static let shared = CommonController() // 싱글톤 인스턴스 사용
    private init() {}
    @Published var isLoggedOut: Bool = false
    private var isLoggingOut: Bool = false // ✅ 중복 로그아웃 방지
    
    
    func getAccessToken() -> Bool {
        if let _ = KeychainHelper.shared.read(service: "com.chuloop.auth", account: "accessToken") {
            
            print("Access Token found in Keychain")
            isLoggedOut = false
            return false
        } else {
            
            print("Access Token not found in Keychain")
            isLoggedOut = true
            return true
        }
    }
    
    
    func uploadImageToServer(endpoint: String, imageData: Data) async -> String? {
        let url = URL(string: "\(Constants.BASE_URL)\(endpoint)")!
//        let url = URL(string: "\(Constants.BASE_URL)\(ApisV1.edPostImage.rawValue)")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.timeoutInterval = 60  // 타임아웃 설정
        
        // Bearer Token 설정
        if let accessToken = KeychainHelper.shared.read(service: "com.chuloop.auth", account: "accessToken"),
           let token = String(data: accessToken, encoding: .utf8)?.trimmingCharacters(in: .whitespacesAndNewlines),
           !token.isEmpty {
            request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        } else {
            print("🔴 Error: Bearer Token is missing or invalid")
            return nil
        }
        
        // multipart/form-data 설정
        let boundary = "Boundary-\(UUID().uuidString)"
        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        
        let body = createMultipartBody(imageData: imageData, boundary: boundary)
        request.httpBody = body
        request.setValue("\(body.count)", forHTTPHeaderField: "Content-Length")
        
        // 서버 응답 처리
        do {
            let (data, response) = try await URLSession.shared.data(for: request)
            
            if let httpResponse = response as? HTTPURLResponse {
                print("🔹 Response Status Code: \(httpResponse.statusCode)")
            }
            
            let responseString = String(data: data, encoding: .utf8) ?? "Invalid UTF-8 Response"
            print("🔹 Response Body: \(responseString)")
            
            let decoder = JSONDecoder()
                let imageUploadResponse = try decoder.decode(ImageUploadResponse.self, from: data)

                if imageUploadResponse.status == 200 {
                    switch imageUploadResponse.data {
                    case .single(let imageUrl):
                        print("✅ 단일 이미지 URL: \(imageUrl)")
                        return imageUrl
                    case .multiple(let imageUrls):
                        print("✅ 여러 개의 이미지 URL: \(imageUrls)")
                        return imageUrls.first  // 첫 번째 이미지 URL만 사용
                    case .none:
                        print("⚠️ Warning: 'data' 필드가 없음")
                        return nil
                    }
                } else {
                    print("🔴 Failed: Server returned status \(imageUploadResponse.status)")
                    return nil
                }
        } catch {
            print("🔴 JSON Decoding Error: \(error)")
            return nil
        }
    }
    
    // 이미지 데이터를 FormData 형식으로 변환하는 함수
    func createMultipartBody(imageData: Data, boundary: String) -> Data {
        var body = Data()
        
        body.append("--\(boundary)\r\n".data(using: .utf8)!)
        body.append("Content-Disposition: form-data; name=\"image\"; filename=\"image.jpg\"\r\n".data(using: .utf8)!)
        body.append("Content-Type: image/jpeg\r\n\r\n".data(using: .utf8)!)
        body.append(imageData)
        body.append("\r\n".data(using: .utf8)!)
        body.append("--\(boundary)--\r\n".data(using: .utf8)!)
        
        return body
    }
    
    
    func logout() {
        guard !isLoggingOut else { return } // ✅ 이미 로그아웃 중이면 실행 안 함
        isLoggingOut = true
        
        // ✅ 모든 네트워크 요청 중단
        URLSession.shared.invalidateAndCancel()
        
        if KeychainHelper.shared.read(service: "com.chuloop.auth", account: "accessToken") != nil {
            KeychainHelper.shared.delete(service: "com.chuloop.auth", account: "accessToken")
        }
        if KeychainHelper.shared.read(service: "com.chuloop.auth", account: "refreshToken") != nil {
            KeychainHelper.shared.delete(service: "com.chuloop.auth", account: "refreshToken")
        }
        
        DispatchQueue.main.async {
            self.isLoggedOut = true
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            self.isLoggingOut = false // ✅ 로그아웃 완료 후 다시 false로 변경
        }
    }
}
