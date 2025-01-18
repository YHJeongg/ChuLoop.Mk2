//
//  LogInterceptor.swift
//  ChuLoop
//

import Foundation

final class LogInterceptor: URLProtocol {
    private static let handledKey = "LogInterceptorHandled"
    private let accessToken = Constants.ACCESS_TOKEN // 토큰을 저장 (예: Access Token)
    
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
    
    // 요청 시작 시 호출
    override func startLoading() {
        // 기존 요청을 복사
        guard let newRequest = (request as NSURLRequest).mutableCopy() as? NSMutableURLRequest else {
            client?.urlProtocol(self, didFailWithError: NSError(domain: "LogInterceptor", code: 0, userInfo: nil))
            return
        }
        
        // httpBody를 명시적으로 복사
        if let bodyStream = request.httpBodyStream {
            let data = Data(reading: bodyStream)
            newRequest.httpBody = data
        }
        
        // Access Token 추가
        newRequest.setValue("Bearer \(accessToken)", forHTTPHeaderField: "Authorization")
        
    
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
    
    // 요청 중단 시 호출
    override func stopLoading() {
        // 필요한 경우 요청 중단 처리
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
