//
//  NoticeModel.swift
//  ChuLoop
//
//  Created by Anna Kim on 3/18/25.
//

import SwiftUI
struct NoticeModel: Codable, Identifiable {
    let id: String
    let title: String
    let content: String
    let createdAt: String
    let updatedAt: String
    
    init(id: String, title: String, content: String, createdAt: String, updatedAt: String) {
        self.id = id
        self.title = title
        self.content = content
        self.createdAt = createdAt
        self.updatedAt = updatedAt
    }
    
//    init() {
//        id: "",
//        title: "",
//        date: "",
//        content: ""
//    }
    
    
}
