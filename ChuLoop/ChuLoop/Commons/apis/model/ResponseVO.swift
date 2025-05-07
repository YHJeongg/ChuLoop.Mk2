
//
//  ResponseVO.swift
//  ChuLoop
//

import SwiftUI


struct ResponseVO: Decodable {
    var status: Int?
    var code: String?
    var message: String?
    var data: Any?  // 🔹 data 타입을 Any? 로 변경
    
    var success: Bool {
        return status == Optional(200)
    }
    
    private enum CodingKeys: String, CodingKey {
        case status
        case code
        case message
        case data
    }
    
    init(status: Int, code: String? = nil, message: String? = nil, data: Any? = nil) {
        self.status = status
        self.code = code
        self.message = message
        self.data = data
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        status = try container.decodeIfPresent(Int.self, forKey: .status)
        code = try container.decodeIfPresent(String.self, forKey: .code)
        message = try container.decodeIfPresent(String.self, forKey: .message)
        
        // data 필드가 JSON 객체일 경우 처리
        if let arrayObject = try? container.decode([JSON].self, forKey: .data) {
            data = arrayObject.map { $0.value }
        } else if let jsonObject = try? container.decode(JSON.self, forKey: .data) {
            data = jsonObject.value
        } else {
            data = nil
        }
    }
}

// JSON 값을 동적으로 처리하기 위한 헬퍼 구조체
private struct JSON: Decodable {
    let value: Any
    
    private struct JSONCodingKeys: CodingKey {
        let stringValue: String
        let intValue: Int?
        
        init?(stringValue: String) {
            self.stringValue = stringValue
            self.intValue = nil
        }
        
        init?(intValue: Int) {
            self.stringValue = "\(intValue)"
            self.intValue = intValue
        }
    }
    
    init(from decoder: Decoder) throws {
        if let container = try? decoder.container(keyedBy: JSONCodingKeys.self) {
            var result = [String: Any]()
            for key in container.allKeys {
                if let value = try? container.decode(String.self, forKey: key) {
                    result[key.stringValue] = value
                } else if let value = try? container.decode(Bool.self, forKey: key) {
                    result[key.stringValue] = value
                } else if let value = try? container.decode(Int.self, forKey: key) {
                    result[key.stringValue] = value
                } else if let value = try? container.decode(Double.self, forKey: key) {
                    result[key.stringValue] = value
                } else if let value = try? container.decode([JSON].self, forKey: key) {
                    result[key.stringValue] = value.map { $0.value }
                } else if let value = try? container.decode(JSON.self, forKey: key) {
                    result[key.stringValue] = value.value
                }
            }
            value = result
        } else if var container = try? decoder.unkeyedContainer() {
            var result = [Any]()
            while !container.isAtEnd {
                if let value = try? container.decode(String.self) {
                    result.append(value)  // ✅ String 처리
                } else if let value = try? container.decode(Bool.self) {
                    result.append(value)  // ✅ Bool 처리
                } else if let value = try? container.decode(Int.self) {
                    result.append(value)  // ✅ Int 처리
                } else if let value = try? container.decode(Double.self) {
                    result.append(value)  // ✅ Double 처리
                } else if let value = try? container.decode([JSON].self) {
                    result.append(contentsOf: value.map { $0.value })  // ✅ 배열을 한꺼번에 추가
                } else if let value = try? container.decode(JSON.self) {
                    result.append(value.value)  // ✅ JSON 객체 처리
                }
            }
            value = result  // 최종적으로 Any 배열 저장
        } else if let container = try? decoder.singleValueContainer() {
            if let value = try? container.decode(String.self) {
                self.value = value
            } else if let value = try? container.decode(Bool.self) {
                self.value = value
            } else if let value = try? container.decode(Int.self) {
                self.value = value
            } else if let value = try? container.decode(Double.self) {
                self.value = value
            } else if let value = try? container.decode([JSON].self) {
                self.value = value.map { $0.value }  // ✅ 배열 전체를 저장
            } else {
                self.value = "none"
            }
        } else {
            throw DecodingError.dataCorrupted(
                DecodingError.Context(
                    codingPath: decoder.codingPath,
                    debugDescription: "Invalid JSON value"
                )
            )
        }
    }
}
