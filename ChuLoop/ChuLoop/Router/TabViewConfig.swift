//
//  TabViewConfig.swift
//  ChuLoop
//
//  Created by Anna Kim on 2/11/25.
//


import Foundation
import UIKit

func configTabView() {
    let appearance = UITabBarAppearance()
    appearance.configureWithOpaqueBackground() // 불투명 배경 설정
    appearance.backgroundColor = UIColor.white // 배경색 변경
    UITabBar.appearance().standardAppearance = appearance
    UITabBar.appearance().scrollEdgeAppearance = appearance
}
