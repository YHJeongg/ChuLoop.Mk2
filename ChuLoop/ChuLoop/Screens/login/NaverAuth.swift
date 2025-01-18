//
//  NaverAuth.swift
//  ChuLoop
//

import NaverThirdPartyLogin


final public class NaverAuth: NSObject {
    public static let shared = NaverAuth()
    
    static func configure() {
        let naverUrlSchema = Bundle.main.infoDictionary?["NAVER_URL_SCHEMA"] as! String
        let naverClientId = Bundle.main.infoDictionary?["NAVER_CLIENT_ID"] as! String
        let naverClientSecret = Bundle.main.infoDictionary?["NAVER_CLIENT_SECRET"] as! String
        
        NaverThirdPartyLoginConnection.getSharedInstance().isInAppOauthEnable = true
        NaverThirdPartyLoginConnection.getSharedInstance().isNaverAppOauthEnable = true
        
        NaverThirdPartyLoginConnection.getSharedInstance().serviceUrlScheme = naverUrlSchema //  URL 스키마 값
        NaverThirdPartyLoginConnection.getSharedInstance().consumerKey = naverClientId // Naver Developers 내 어플리케이션에있는 Client ID
        NaverThirdPartyLoginConnection.getSharedInstance().consumerSecret = naverClientSecret // Naver Developers 내 어플리케이션에 있는 Client Secret
        NaverThirdPartyLoginConnection.getSharedInstance().appName = "ChuLoop" // 앱 이름
        NaverThirdPartyLoginConnection.getSharedInstance().delegate = NaverAuth.shared
    }
    
    private override init() { }
}

// MARK: - Public method
public extension NaverAuth {
    func login() {
        guard !isValidAccessTokenExpireTimeNow else {
            retreiveInfo()
            return
        }
        
        if isInstalledNaver {
            NaverThirdPartyLoginConnection.getSharedInstance().requestThirdPartyLogin()
        } else {
            NaverThirdPartyLoginConnection.getSharedInstance().openAppStoreForNaverApp()
        }
    }
    
    func logout() {
        NaverThirdPartyLoginConnection.getSharedInstance().resetToken()
    }
    
    func unlink() {
        NaverThirdPartyLoginConnection.getSharedInstance().requestDeleteToken()
    }
    
    func receiveAccessToken(_ url: URL) {
        guard url.absoluteString.contains("com.develop.chuloop://") else { return }
        NaverThirdPartyLoginConnection.getSharedInstance().receiveAccessToken(url)
    }
    
}

// MARK: - Private variable
private extension NaverAuth {
    var isInstalledNaver: Bool {
        NaverThirdPartyLoginConnection.getSharedInstance().isPossibleToOpenNaverApp()
    }
    
    var isValidAccessTokenExpireTimeNow: Bool {
        NaverThirdPartyLoginConnection.getSharedInstance().isValidAccessTokenExpireTimeNow()
    }
}
 
// MARK: - Private method
private extension NaverAuth {
    func retreiveInfo() {
        guard isValidAccessTokenExpireTimeNow,
            let tokenType = NaverThirdPartyLoginConnection.getSharedInstance().tokenType,
            let accessToken = NaverThirdPartyLoginConnection.getSharedInstance().accessToken else {
            NaverThirdPartyLoginConnection.getSharedInstance().requestAccessTokenWithRefreshToken()
            return
        }
        
        Task {
            do {
                var urlRequest = URLRequest(url: URL(string: "https://openapi.naver.com/v1/nid/me")!)
                urlRequest.httpMethod = "GET"
                urlRequest.allHTTPHeaderFields = ["Authorization": "\(tokenType) \(accessToken)"]
                let (data, _) = try await URLSession.shared.data(for: urlRequest)
                let response = try JSONDecoder().decode(NaverUserDataVO.self, from: data)
                
                print(response)

            } catch {
                await NaverThirdPartyLoginConnection.getSharedInstance().requestAccessTokenWithRefreshToken()
            }
        }
    }
}

// MARK: - Delegate
extension NaverAuth: NaverThirdPartyLoginConnectionDelegate {
    // Required
    public func oauth20ConnectionDidFinishRequestACTokenWithAuthCode() {
        // 토큰 발급 성공시
        retreiveInfo()
    }
    
    public func oauth20ConnectionDidFinishRequestACTokenWithRefreshToken() {
        // 토큰 갱신시
        retreiveInfo()
    }
    
    public func oauth20ConnectionDidFinishDeleteToken() {
        // Logout
    }
    
    public func oauth20Connection(_ oauthConnection: NaverThirdPartyLoginConnection!, didFailWithError error: Error!) {
        // Error 발생
    }
    
    
    // Optional
    public func oauth20Connection(_ oauthConnection: NaverThirdPartyLoginConnection!, didFinishAuthorizationWithResult recieveType: THIRDPARTYLOGIN_RECEIVE_TYPE) {
        
    }
}
