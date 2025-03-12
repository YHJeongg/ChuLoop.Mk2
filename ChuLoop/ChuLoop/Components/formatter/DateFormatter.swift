//
//  DateFormatter.swift
//  ChuLoop
//
//  Created by Anna Kim on 2/2/25.
//

import Foundation

// 날짜 포맷팅 함수

// yyyy.MM.dd (EEE)
func formatdotYYYYMMDDEEE(_ date: Date) -> String {
    let formatter = DateFormatter()
    
    // 로케일 설정 (한국어로 설정)
    formatter.locale = Locale(identifier: "ko_KR")
    
    // 원하는 포맷 설정 (2024.09.25 (수))
    formatter.dateFormat = "yyyy.MM.dd (EEE)"
    
    // 포맷팅된 문자열 반환
    return formatter.string(from: date)
}

// yyyy.MM.dd
func formatdotYYYYMMDD(_ date: Date) -> String {
    let formatter = DateFormatter()
    
    // 로케일 설정 (한국어로 설정)
    formatter.locale = Locale(identifier: "ko_KR")
    
    // 원하는 포맷 설정 (2024.09.25)
    formatter.dateFormat = "yyyy.MM.dd"
    
    // 포맷팅된 문자열 반환
    return formatter.string(from: date)
}

// 시간에 따라 ~일전, ~주전 등으로 표시
func timeAgo(from dateString: String) -> String {
    let formatter = DateFormatter()
    formatter.locale = Locale(identifier: "ko_KR")
    formatter.timeZone = TimeZone(identifier: "Asia/Seoul")
    formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"

    // 입력된 날짜 문자열을 Date로 변환
    guard let date = formatter.date(from: dateString) else {
        return "날짜 오류"
    }
    
    // 현재 시간을 한국 시간대로 조정
    let now = Date()
    let koreaTimeZone = TimeZone(identifier: "Asia/Seoul")!
    let calendar = Calendar.current
    let koreaNow = calendar.date(byAdding: .second, value: koreaTimeZone.secondsFromGMT(), to: now)!
    
    // 날짜 차이 계산
    let components = calendar.dateComponents([.year, .month, .weekOfYear, .day, .hour, .minute], from: date, to: koreaNow)
    
    if let year = components.year, year > 0 {
        return "\(year)년 전"
    } else if let month = components.month, month > 0 {
        return "\(month)개월 전"
    } else if let week = components.weekOfYear, week > 0 {
        return "\(week)주 전"
    } else if let day = components.day, day > 0 {
        return "\(day)일 전"
    } else if let hour = components.hour, hour > 0 {
        return "\(hour)시간 전"
    } else if let minute = components.minute, minute > 0 {
        return "\(minute)분 전"
    } else {
        return "방금 전"
    }
}
