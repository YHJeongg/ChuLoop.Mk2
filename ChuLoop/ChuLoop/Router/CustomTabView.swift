//
//  CustomTabView.swift
//  ChuLoop
//
//  Created by Anna Kim on 3/3/25.
//

import SwiftUI

enum Tab {
    case home
    case visit
    case map
    case share
    case mypage
}

struct CustomTabView: View {
    
    @Binding var selectedTab: Tab

    var body: some View {
        HStack(alignment: .center, spacing: 0) {
            TabButton(
                title: "홈",
                imageName: selectedTab == .home ? "selected-home" : "home",
                isSelected: selectedTab == .home,
                paddingValues: EdgeInsets(top: ResponsiveSize.width(15), leading: 0, bottom: 0, trailing: ResponsiveSize.width(12)) // ✅ 개별 패딩 설정
            ) {
                selectedTab = .home
            }
            
            TabButton(
                title: "방문할 맛집",
                imageName: selectedTab == .visit ? "selected-cupcake" : "cupcake",
                isSelected: selectedTab == .visit
            ) {
                selectedTab = .visit
            }
            
            TabButton(
                title: "지도로 보기",
                imageName: selectedTab == .map ? "selected-map" : "map",
                isSelected: selectedTab == .map
            ) {
                selectedTab = .map
            }
            
            TabButton(
                title: "맛집 공유",
                imageName: selectedTab == .share ? "selected-planet" : "planet",
                isSelected: selectedTab == .share
            ) {
                selectedTab = .share
            }
            
            TabButton(
                title: "마이페이지",
                imageName: selectedTab == .mypage ? "selected-profile" : "profile",
                isSelected: selectedTab == .mypage,
                paddingValues: EdgeInsets(top: ResponsiveSize.width(15), leading: ResponsiveSize.width(12), bottom: 0, trailing: 0) // ✅ 개별 패딩 설정
            ) {
                selectedTab = .mypage
            }
        }
    }
}
