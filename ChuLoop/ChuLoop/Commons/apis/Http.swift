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
        config.protocolClasses = [LogInterceptor.self, CustomInterceptor.self]
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
            print("resquest api decoded response : \(decodedResponse)")
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
    func post<T: Encodable>(
        endpoint: String,
        body: T?
    ) async -> ResponseVO {
        do {
            let bodyData = try JSONEncoder().encode(body)
            let result = await request(endpoint: endpoint, method: "POST", body: bodyData);
            return result
            
        } catch {
            return ResponseVO(status: 400, message: "Encoding error: \(error.localizedDescription)")
        }
        
    }
    
    // MARK: - PUT Request
    func put<U: Encodable>(endpoint: String, body: U) async -> ResponseVO {
        do {
            let bodyData = try JSONEncoder().encode(body)
            return await request(endpoint: endpoint, method: "PUT", body: bodyData)
        } catch {
            return ResponseVO(status: 400, message: "Encoding error: \(error.localizedDescription)")
        }
    }
    
    // MARK: - DELETE Request
    func delete<U: Encodable>(endpoint: String, body: U) async -> ResponseVO {
        do {
            let bodyData = try JSONEncoder().encode(body)
            return await request(endpoint: endpoint, method: "DELETE", body: bodyData)
        } catch {
            return ResponseVO(status: 400, message: "Encoding error: \(error.localizedDescription)")
        }
    }
}
