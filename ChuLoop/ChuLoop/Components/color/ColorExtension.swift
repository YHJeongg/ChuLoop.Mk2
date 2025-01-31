//
//  Colors.swift
//  ChuLoop
//
//  Created by Anna Kim on 1/31/25.
//

import SwiftUI

extension Color {
    
    init(hex: String) {
        let scanner = Scanner(string: hex)
        _ = scanner.scanString("#")
        
        var rgb: UInt64 = 0
        scanner.scanHexInt64(&rgb)
        
        let r = Double((rgb >> 16) & 0xFF) / 255.0
        let g = Double((rgb >>  8) & 0xFF) / 255.0
        let b = Double((rgb >>  0) & 0xFF) / 255.0
        self.init(red: r, green: g, blue: b)
      }
    
    static let primary50: Color = Color(hex: "FBFDFF")
    static let primary100: Color = Color(hex: "CCE8FF")
    static let primary200: Color = Color(hex: "ADD9FF")
    static let primary300: Color = Color(hex: "8EC9FF")
    static let primary400: Color = Color(hex: "6FB9FF")
    static let primary500: Color = Color(hex: "5AAEFF")
    static let primary600: Color = Color(hex: "2D9EFF")
    static let primary700: Color = Color(hex: "178FF5")
    static let primary800: Color = Color(hex: "0B84EC")
    static let primary900: Color = Color(hex: "0278DE")
    static let primary1000: Color = Color(hex: "0164B9")
    
    static let natural10: Color = Color(hex: "F8F8F8")
    static let natural20: Color = Color(hex: "EAEAEA")
    static let natural30: Color = Color(hex: "DFDEDE")
    static let natural40: Color = Color(hex: "C8C8C8")
    static let natural50: Color = Color(hex: "AAAAAA")
    static let natural60: Color = Color(hex: "848484")
    static let natural70: Color = Color(hex: "666666")
    static let natural80: Color = Color(hex: "3D3D3D")
    static let natural90: Color = Color(hex: "212121")
    
    static let error: Color = Color(hex: "EF5350")
    static let gray: Color = Color(hex: "FAFAFC")
    static let mobileGray: Color = Color(hex: "F9F9F9")
    static let darkBlack: Color = Color(hex: "101010")
    static let yellow: Color = Color(hex: "FFDC30")
    static let blue: Color = Color(hex: "487AFF")
    static let purple: Color = Color(hex: "9747FF")
    
}
