//
//  EdPostRequestModel.swift
//  ChuLoop
//
//  Created by Anna Kim on 2/5/25.
//

import Foundation

struct EdPostRequestModel: Codable {
    let title: String
    let category: String
    let address: String
    let date: String
    let images: [String]
    let description: String
    let rating: Int
}
