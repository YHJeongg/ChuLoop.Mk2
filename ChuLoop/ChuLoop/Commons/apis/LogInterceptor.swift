//
//  LogInterceptor.swift
//  ChuLoop
//

import Foundation

final class LogInterceptor: URLProtocol {
    private static let handledKey = "LogInterceptorHandled"
    //    private var loginController: LoginController
    //    
    //    // URLProtocol의 지정 초기자 호출
    //    override init(request: URLRequest, cachedResponse: CachedURLResponse?, client: URLProtocolClient?) {
    //        self.loginController = LoginController() // 또는 외부에서 전달받은 로그인 컨트롤러를 사용할 수 있음
    //        super.init(request: request, cachedResponse: cachedResponse, client: client)
    //    }
    // Keychain에서 Access Token을 가져오는 메서드
    private func getAccessToken() -> String? {
        if let accessToken = KeychainHelper.shared.read(service: "com.chuloop.auth", account: "accessToken") {
            return String(data: accessToken, encoding: .utf8)
        }
        print("Access Token not found in Keychain")
        DispatchQueue.main.async {
            CommonController.shared.logout()
        }
        return nil
    }
    
    // Keychain에서 refresh Token을 가져오는 메서드
    private func getRefreshToken() -> String? {
        if let accessToken = KeychainHelper.shared.read(service: "com.chuloop.auth", account: "refreshToken") {
            return String(data: accessToken, encoding: .utf8)
        }
        print("Access Token not found in Keychain")
        DispatchQueue.main.async {
            CommonController.shared.logout()
        }
        return nil
    }
    
    // URLProtocol이 요청을 처리할지 결정하는 메서드
    override class func canInit(with request: URLRequest) -> Bool {
        // 한 번 처리된 요청은 다시 처리하지 않도록 설정
        if URLProtocol.property(forKey: handledKey, in: request) != nil {
            return false
        }
        return true
    }
    
    // 요청의 표준화된 형태를 반환
    override class func canonicalRequest(for request: URLRequest) -> URLRequest {
        return request
    }
    
    override func startLoading() {
        Task {
            // 기존 요청을 복사
            guard let newRequest = (request as NSURLRequest).mutableCopy() as? NSMutableURLRequest else {
                client?.urlProtocol(self, didFailWithError: NSError(domain: "LogInterceptor", code: 0, userInfo: nil))
                return
            }
            
            // Access Token 가져오기
            var accessToken = getAccessToken()
            
            // 토큰이 유효한지 검사
            if let token = accessToken, !checkIsValid(token: token) {
                print("🔄 Access Token expired, attempting to refresh...")
                
                // Refresh Token 가져오기
                if let refreshToken = getRefreshToken() {
                    if let newToken = await reissue(refreshToken: refreshToken) {
                        if let newTokenData = newToken.data(using: .utf8) {
                            KeychainHelper.shared.save(newTokenData, service: "com.chuloop.auth", account: "accessToken")
                        }
                        accessToken = newToken
                    } else {
                        DispatchQueue.main.async {
                            if !CommonController.shared.isLoggedOut { // ✅ 중복 로그아웃 방지
                                CommonController.shared.logout()
                            }
                        }
                        print("❌ Failed to refresh Access Token")
                    }
                } else {
                    DispatchQueue.main.async {
                        if !CommonController.shared.isLoggedOut { // ✅ 중복 로그아웃 방지
                            CommonController.shared.logout()
                        }
                    }
                    print("❌ Refresh Token is missing")
                }
            }
            
            if let token = accessToken {
                newRequest.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
            } else {
//                DispatchQueue.main.async {
//                           if !CommonController.shared.isLoggedOut { // ✅ 중복 로그아웃 방지
//                               CommonController.shared.logout()
//                           }
//                       }
                print("❌ Access Token is missing, proceeding without authentication")
            }
            
            // httpBody 복사 (필요 시)
            if let bodyStream = request.httpBodyStream {
                let data = Data(reading: bodyStream)
                newRequest.httpBody = data
            }
            
            logRequest(newRequest as URLRequest)
            
            // handledKey 설정
            URLProtocol.setProperty(true, forKey: LogInterceptor.handledKey, in: newRequest)
            
            // 실제 요청 수행
            let task = URLSession.shared.dataTask(with: newRequest as URLRequest) { [weak self] data, response, error in
                if let error = error {
                    self?.client?.urlProtocol(self!, didFailWithError: error)
                    return
                }
                
                if let response = response {
                    self?.logResponse(response, data: data)
                    self?.client?.urlProtocol(self!, didReceive: response, cacheStoragePolicy: .notAllowed)
                }
                
                if let data = data {
                    self?.client?.urlProtocol(self!, didLoad: data)
                }
                
                self?.client?.urlProtocolDidFinishLoading(self!)
            }
            task.resume()
        }
    }
    
    // 요청 중단 시 호출
    override func stopLoading() {
        // 필요한 경우 요청 중단 처리
    }
    
    // 토큰만료 시 재발급
    struct TokenResponse: Decodable {
        let accessToken: String
    }
    struct RefreshTokenRequest: Encodable {
        let refreshToken: String
    }
    
    func reissue(refreshToken: String) async -> String? {
        let urlString = "\(Constants.BASE_URL)\(ApisV1.reissue.rawValue)"
        guard let url = URL(string: urlString) else { return nil }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        // ✅ 올바른 JSON 형식으로 변환
        let requestBody = RefreshTokenRequest(refreshToken: refreshToken)
        
        do {
            let jsonData = try JSONEncoder().encode(requestBody)
            request.httpBody = jsonData
            
            // ✅ 디버깅용: 실제 보낼 JSON 확인
            if let jsonString = String(data: jsonData, encoding: .utf8) {
                print("📤 Sending JSON: \(jsonString)")
            }
        } catch {
            print("❌ Error encoding request body: \(error)")
            //            loginController.logOut()
            return nil
        }
        
        do {
            let (data, _) = try await URLSession.shared.data(for: request)
            
            // ✅ 서버 응답 확인
            if let json = try? JSONSerialization.jsonObject(with: data, options: []) {
                print("📥 Server Response: \(json)")
            } else {
                //                loginController.logOut()
                print("❌ Server returned non-JSON response")
            }
            
            let decodedData = try JSONDecoder().decode(TokenResponse.self, from: data)
            return decodedData.accessToken
        } catch {
            //            loginController.logOut()
            print("❌ Error fetching data: \(error)")
            return nil
        }
    }
    
    func checkIsValid(token: String) -> Bool {
        guard let payload = decodeJWT(token: token),
              let exp = payload["exp"] as? TimeInterval else {
            
            return false
        }
        
        let expirationDate = Date(timeIntervalSince1970: exp)
        let currentDate = Date()
        
        if currentDate >= expirationDate {
            print("Token expired! Logging out...")
            return false
        } else {
            print("Token is valid.")
            return true
        }
    }
    
    func decodeJWT(token: String) -> [String: Any]? {
        let parts = token.split(separator: ".")
        guard parts.count > 1 else { return nil }
        
        let payloadPart = String(parts[1])
        
        guard let payloadData = Data(base64Encoded: base64UrlToBase64(payloadPart)),
              let json = try? JSONSerialization.jsonObject(with: payloadData) as? [String: Any] else {
            return nil
        }
        
        return json
    }
    
    func base64UrlToBase64(_ base64Url: String) -> String {
        var base64 = base64Url.replacingOccurrences(of: "-", with: "+")
            .replacingOccurrences(of: "_", with: "/")
        
        let paddingLength = (4 - base64.count % 4) % 4
        base64.append(String(repeating: "=", count: paddingLength))
        
        return base64
    }
    
    
    // 요청 로깅
    private func logRequest(_ request: URLRequest) {
        print("Request:")
        print("URL: \(request.url?.absoluteString ?? "N/A")")
        print("Method: \(request.httpMethod ?? "N/A")")
        if let headers = request.allHTTPHeaderFields {
            print("Headers: \(headers)")
        }
        if let body = request.httpBody {
            print("Body: \(String(data: body, encoding: .utf8) ?? "Binary Data")")
        } else {
            print("Body: nil")
        }
        print("==========================================================================")
    }
    
    // 응답 로깅
    private func logResponse(_ response: URLResponse, data: Data?) {
        print("Response:")
        if let httpResponse = response as? HTTPURLResponse {
            print("Status Code: \(httpResponse.statusCode)")
            
            
            //            print("Headers: \(httpResponse.allHeaderFields)")
        }
        if let data = data, let bodyString = String(data: data, encoding: .utf8) {
            print("Body: \(bodyString)")
            
        }
        print("==========================================================================")
        
    }
}

extension Data {
    init(reading input: InputStream) {
        self.init()
        input.open()
        defer { input.close() }
        
        let bufferSize = 1024
        let buffer = UnsafeMutablePointer<UInt8>.allocate(capacity: bufferSize)
        defer { buffer.deallocate() }
        
        while input.hasBytesAvailable {
            let read = input.read(buffer, maxLength: bufferSize)
            if read > 0 {
                self.append(buffer, count: read)
            } else if read < 0 {
                fatalError("Error reading stream: \(input.streamError.debugDescription)")
            }
        }
    }
}
