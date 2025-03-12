//
//  HTTP.swift
//  ChuLoop
//
//  Created by Anna Kim on 1/20/25.
//

import Foundation

class HTTP {
    static let shared = HTTP() // 싱글톤 인스턴스
    
    private let baseURL = Constants.BASE_URL // 기본 API URL
    private let accessToken = Constants.ACCESS_TOKEN
    private var session = URLSession.shared
    
    
    private init() {
        let config = URLSessionConfiguration.default
        config.timeoutIntervalForRequest = 30
        config.timeoutIntervalForResource = 300
        config.httpAdditionalHeaders = [
            "Content-Type": "application/json",
            "Accept": "application/json"
        ]
        config.protocolClasses = [LogInterceptor.self]
        self.session = URLSession(configuration: config)
    }
    
    
    // MARK: - Unified Request
    private func request(
        endpoint: String,
        method: String,
        body: Data? = nil,
        queryParameters: [String: String]? = nil
    ) async -> ResponseVO {
        guard var urlComponents = URLComponents(string: "\(baseURL)\(endpoint)") else {
            return ResponseVO(
                status: 400,
                message: "Invalid URL"
            )
        }
        
        if let queryParameters = queryParameters {
            urlComponents.queryItems = queryParameters.map { URLQueryItem(name: $0.key, value: $0.value) }
        }
        
        guard let url = urlComponents.url else {
            return ResponseVO(status: 400, message: "Invalid URL")
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = method
        
        if let body = body {
            request.httpBody = body
        }
        
        do {
            let (data, response) = try await self.session.data(for: request)
            guard let httpResponse = response as? HTTPURLResponse else {
                return ResponseVO(status: 500, message: "Invalid response")
            }
            
            let decodedResponse = try JSONDecoder().decode(ResponseVO.self, from: data)
            
            return ResponseVO(
                status: decodedResponse.status ?? httpResponse.statusCode,
                code: decodedResponse.code,
                message: decodedResponse.message,
                data: decodedResponse.data
            )
            
        } catch {
            return ResponseVO(status: 500, message: "Error: \(error.localizedDescription)")
        }
    }
    
    
    // MARK: - GET
    func get(
        endpoint: String,
        queryParameters: [String: String]? = nil
    ) async -> ResponseVO {
        return await request(endpoint: endpoint, method: "GET", queryParameters: queryParameters)
    }
    
    // MARK: - POST
    func post(
        endpoint: String, body: Encodable? = nil
    ) async -> ResponseVO {
        do {
            if let body = body {
                let bodyData = try JSONEncoder().encode(body)
                return await request(endpoint: endpoint, method: "POST", body: bodyData);
            }
            return await request(endpoint: endpoint, method: "POST");
            
        } catch {
            return ResponseVO(status: 400, message: "Encoding error: \(error.localizedDescription)")
        }
        
    }
    
    // MARK: - PUT Request
    func put(endpoint: String, body: Encodable? = nil) async -> ResponseVO {
        do {
            if let body = body {
                let bodyData = try JSONEncoder().encode(body)
                return await request(endpoint: endpoint, method: "PUT", body: bodyData)
            }
            return await request(endpoint: endpoint, method: "PUT")
        } catch {
            return ResponseVO(status: 400, message: "Encoding error: \(error.localizedDescription)")
        }
    }
    
    // MARK: - DELETE Request
    func delete(endpoint: String, body: Encodable? = nil) async -> ResponseVO {
        do {
            if let body = body {
                let bodyData = try JSONEncoder().encode(body)
                return await request(endpoint: endpoint, method: "DELETE", body: bodyData)
            }
            return await request(endpoint: endpoint, method: "DELETE")
        } catch {
            return ResponseVO(status: 400, message: "Encoding error: \(error.localizedDescription)")
        }
    }
}
