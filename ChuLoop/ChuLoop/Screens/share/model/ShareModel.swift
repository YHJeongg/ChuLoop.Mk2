//
//  ShareModel.swift
//  ChuLoop
//

import Foundation

struct ShareResponseModel: Codable {
    let page: Int
    let limit: Int
    let sortDirection: Int
    let totalPages: Int
    let totalCounts: Int
    let contents: [ShareModel]
}

struct ShareModel: Codable, Identifiable {
    let id: String
    let seq: Int
    let title: String
    let category: String
    let address: String
    let date: String
    let images: [String]
    let rating: Double
    var shared: Bool
    var likes: Int
    var mylikes: Bool
    var userName: String?

    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case seq, title, category, address, date, images, rating, shared, likes, mylikes, userName
    }
}
