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
    appearance.backgroundColor = UIColor(.white) // 배경색 변경
    appearance.stackedItemWidth = 20
//    appearance.stackedLayoutAppearance.normal. = CGSize(width: 24, height: 24) // 아이콘 크기 변경
//            appearance.stackedLayoutAppearance.normal.titleTextAttributes = [.font: UIFont.systemFont(ofSize: 14)] // 글자 크기 변경
//            
    UITabBar.appearance().standardAppearance = appearance
    UITabBar.appearance().scrollEdgeAppearance = appearance
}
