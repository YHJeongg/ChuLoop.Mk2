//
//  LogInterceptor.swift
//  ChuLoop
//
//  Created by Anna Kim on 1/11/25.
//

import Foundation
import Alamofire

class LogInterceptor: EventMonitor {
    func requestDidFinish(_ request: Request) {
        print("Request: \(request)")
    }
    
    func responseDidReceive(_ response: DataResponse<Data?, AFError>, for request: Request) {
        print("Response: \(response)")
    }
}
