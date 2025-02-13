//
//  ImageModel.swift
//  ChuLoop
//
//  Created by Anna Kim on 2/13/25.
//



struct ImageUploadResponse: Decodable {
    let status: Int
    let code: String
    let message: String
    let data: [String]  // imageUrl 배열
}
