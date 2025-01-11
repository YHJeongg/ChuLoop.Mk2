//
//  http.swift
//  ChuLoop
//
//  Created by Anna Kim on 1/11/25.
//

import Foundation
import Alamofire

class Http {
    static let shared = Http()
    
    private var session: Session
    private var cookieStorage = HTTPCookieStorage.shared
    
    private init() {
        let configuration = URLSessionConfiguration.default
        configuration.httpShouldSetCookies = true
        configuration.httpCookieStorage = cookieStorage
        
        session = Session(configuration: configuration)
    }
    
    func post(_ url: String, parameters: [String: Any]?, headers: HTTPHeaders? = nil, completion: @escaping (Result<ResponseVO, Error>) -> Void) {
        session.request(url, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: headers)
            .responseDecodable(of: ResponseVO.self) { response in
                switch response.result {
                case .success(let data):
                    completion(.success(data))
                case .failure(let error):
                    completion(.failure(error))
                }
            }
    }
    
    func get(_ url: String, parameters: [String: Any]?, headers: HTTPHeaders? = nil, completion: @escaping (Result<ResponseVO, Error>) -> Void) {
        session.request(url, method: .get, parameters: parameters, encoding: URLEncoding.default, headers: headers)
            .responseDecodable(of: ResponseVO.self) { response in
                switch response.result {
                case .success(let data):
                    completion(.success(data))
                case .failure(let error):
                    completion(.failure(error))
                }
            }
    }
    
    func removeCookies() {
        if let cookies = cookieStorage.cookies {
            for cookie in cookies {
                cookieStorage.deleteCookie(cookie)
            }
        }
    }
}
