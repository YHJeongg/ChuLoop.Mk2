//
//  ResponsiveSize.swift
//  ChuLoop
//

import SwiftUI

struct ResponsiveSize {
    static let designWidth: CGFloat = 430
    static let designHeight: CGFloat = 932

    static let screenWidth = UIScreen.main.bounds.width
    static let screenHeight = UIScreen.main.bounds.height

    // 너비 변환 (픽셀값 -> 현재 기기 비율 적용)
    static func width(_ value: CGFloat) -> CGFloat {
        return (value / designWidth) * screenWidth
    }

    // 높이 변환 (픽셀값 -> 현재 기기 비율 적용)
    static func height(_ value: CGFloat) -> CGFloat {
        return (value / designHeight) * screenHeight
    }
}
