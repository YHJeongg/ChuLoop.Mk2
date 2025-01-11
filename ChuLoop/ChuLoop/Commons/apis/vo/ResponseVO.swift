//
//  ResponseVO.swift
//  ChuLoop
//
//  Created by Anna Kim on 1/11/25.
//
import Foundation

struct ResponseVO: Decodable {
    let status: Int?
    let message: String?
    let body: Any?

    var success: Bool {
        return status == 200
    }

    private enum CodingKeys: String, CodingKey {
        case status
        case message
        case body
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        status = try container.decodeIfPresent(Int.self, forKey: .status)
        message = try container.decodeIfPresent(String.self, forKey: .message)
        
        if let bodyData = try? container.decode(String.self, forKey: .body).data(using: .utf8) {
            body = try? JSONSerialization.jsonObject(with: bodyData, options: [])
        } else {
            body = nil
        }
    }
}
