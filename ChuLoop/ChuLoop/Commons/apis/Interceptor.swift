//
//  interceptor.swift
//  ChuLoop
//
//  Created by Anna Kim on 1/11/25.
//

import Foundation
import Alamofire

class CustomInterceptor: RequestInterceptor {
    private let storage = Storage.shared
    
    func adapt(_ urlRequest: URLRequest, for session: Session, completion: @escaping (Result<URLRequest, Error>) -> Void) {
        var request = urlRequest
        if let token = storage.getAccessToken() {
            request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        }
        completion(.success(request))
    }
    
    func retry(_ request: Request, for session: Session, dueTo error: Error, completion: @escaping (RetryResult) -> Void) {
        if request.response?.statusCode == 401 {
            refreshAccessToken { success in
                success ? completion(.retry) : completion(.doNotRetry)
            }
        } else {
            completion(.doNotRetry)
        }
    }
    
    private func refreshAccessToken(completion: @escaping (Bool) -> Void) {
        let url = "https://example.com/refresh"
        Http.shared.post(url, parameters: nil) { result in
            switch result {
            case .success(let response):
                if let body = response.body as? [String: Any],
                   let token = body["access_token"] as? String {
                    Storage.shared.saveAccessToken(token)
                    completion(true)
                } else {
                    completion(false)
                }
            case .failure:
                completion(false)
            }
        }
    }
}
