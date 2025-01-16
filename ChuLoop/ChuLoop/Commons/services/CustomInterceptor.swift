//
//  interceptor.swift
//  ChuLoop
//
//  Created by Anna Kim on 1/11/25.
//
import Foundation

class CustomInterceptor: URLProtocol {
    private let accessToken = Constants.ACCESS_TOKEN // 토큰을 저장 (예: Access Token)
    
    override class func canInit(with request: URLRequest) -> Bool {
        // 요청을 가로채는 조건 (모든 요청을 처리)
        return true
    }
    
    
    
    override class func canonicalRequest(for request: URLRequest) -> URLRequest {
        // 요청의 표준화된 형태를 반환
        return request
    }
    
    override func startLoading() {
        guard let request = request as? NSMutableURLRequest else {
            client?.urlProtocol(self, didFailWithError: NSError(domain: "InvalidRequest", code: 0, userInfo: nil))
            return
        }
        
        // Access Token 추가
        request.setValue("Bearer \(accessToken)", forHTTPHeaderField: "Authorization")
        
        // URLSession을 사용하여 요청 수행
        let session = URLSession(configuration: .default)
        let task = session.dataTask(with: request as URLRequest) { [weak self] data, response, error in
            if let error = error {
                self?.client?.urlProtocol(self!, didFailWithError: error)
                return
            }
            
            if let response = response {
                self?.client?.urlProtocol(self!, didReceive: response, cacheStoragePolicy: .notAllowed)
            }
            
            if let data = data {
                self?.client?.urlProtocol(self!, didLoad: data)
            }
            
            self?.client?.urlProtocolDidFinishLoading(self!)
        }
        task.resume()
    }
    
    override func stopLoading() {
        // 요청 취소 시 처리 (필요 시 구현)
    }
    

}
