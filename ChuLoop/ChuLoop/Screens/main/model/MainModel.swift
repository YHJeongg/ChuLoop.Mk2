//
//  MainModel.swift
//  ChuLoop

import Foundation

struct MainModel: Codable, Identifiable {
    var id: String
    var title: String
    var rating: Int
    var date: String
    var shared: Bool
    var category: String
    var address: String
    var images: [String]
    var description: String?
    
    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case title
        case rating
        case date
        case shared
        case category
        case address
        case images
        case description
    }
}

struct MainResponseModel: Codable {
    var page: Int
    var limit: Int
    var sortDirection: Int
    var totalPages: Int
    var totalCounts: Int
    var contents: [MainModel]
}
