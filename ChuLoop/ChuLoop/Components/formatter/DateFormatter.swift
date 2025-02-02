//
//  DateFormatter.swift
//  ChuLoop
//
//  Created by Anna Kim on 2/2/25.
//

import Foundation

// 날짜 포맷팅 함수
func formatDate(_ date: Date) -> String {
    let formatter = DateFormatter()
    
    // 로케일 설정 (한국어로 설정)
    formatter.locale = Locale(identifier: "ko_KR")
    
    // 원하는 포맷 설정 (2024.09.25 (수))
    formatter.dateFormat = "yyyy.MM.dd (EEE)"
    
    // 포맷팅된 문자열 반환
    return formatter.string(from: date)
}
