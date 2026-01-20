//
//  WillModel.swift
//  ChuLoop
//

import Foundation

struct WillModel: Codable, Identifiable {
    let id: String
    let title: String
    let category: String
    let address: String
    let date: String
    let images: [String]

    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case title
        case address
        case category
        case date
        case images
    }
}

struct WillResponseModel: Codable {
    let page: Int
    let limit: Int
    let totalPages: Int
    let totalCounts: Int
    let contents: [WillModel]
}

struct WillSaveRequest: Encodable {
    let title: String
    let category: String
    let address: String
    let date: String
    let images: [String]
}
