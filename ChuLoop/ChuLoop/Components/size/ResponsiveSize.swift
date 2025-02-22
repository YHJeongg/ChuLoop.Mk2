//
//  ResponsiveSize.swift
//  ChuLoop
//

import SwiftUI

struct ResponsiveSize {
    static let screenWidth = UIScreen.main.bounds.width
    static let screenHeight = UIScreen.main.bounds.height

    static func width(_ ratio: CGFloat) -> CGFloat {
        return screenWidth * ratio
    }

    static func height(_ ratio: CGFloat) -> CGFloat {
        return screenHeight * ratio
    }
}
