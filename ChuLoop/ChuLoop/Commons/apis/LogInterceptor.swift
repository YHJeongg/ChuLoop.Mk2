//
//  LogInterceptor.swift
//  ChuLoop
//

import Alamofire

final class LogInterceptor: EventMonitor {
    func requestDidFinish(_ request: Request) {
        print("Request: \(request)")
    }
    
    func responseDidReceive(_ response: DataResponse<Data?, AFError>, for request: Request) {
        print("Response: \(response)")
    }
}
