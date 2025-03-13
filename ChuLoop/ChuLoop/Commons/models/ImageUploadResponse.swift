//
//  ImageModel.swift
//  ChuLoop
//
//  Created by Anna Kim on 2/13/25.
//


struct ImageUploadResponse: Codable {
    let status: Int
    let code: String
    let message: String
    let data: ImageData?  // ✅ `data` 타입을 별도 구조체로 변경
}

// ✅ `data` 필드를 유연하게 처리하는 구조체
enum ImageData: Codable {
    case single(String)   // 단일 URL 문자열
    case multiple([String])  // 여러 개의 URL (배열)

    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        if let singleString = try? container.decode(String.self) {
            self = .single(singleString)
        } else if let multipleStrings = try? container.decode([String].self) {
            self = .multiple(multipleStrings)
        } else {
            throw DecodingError.typeMismatch(
                ImageData.self,
                DecodingError.Context(codingPath: decoder.codingPath, debugDescription: "Invalid data type for ImageData")
            )
        }
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        switch self {
        case .single(let url):
            try container.encode(url)
        case .multiple(let urls):
            try container.encode(urls)
        }
    }
}
