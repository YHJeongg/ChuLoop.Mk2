//
//  TabView.swift
//  ChuLoop
//

import SwiftUI

struct MainTabView: View {
    
    @State var selectedTab: Tab = .home
    
    var body: some View {
        VStack(spacing: 0) {
            switch selectedTab {
            case .home:
                MainScreen()
                    .environmentObject(MainScreenController())
            case .visit:
                VisitScreen()
            case .map:
                MapScreen()
            case .share:
                ShareScreen()
            case .mypage:
                MyPageScreen()
            }
        
            // 구분선 추가
            Rectangle()
                .fill(Color.natural20) // 구분선 색상 조정)
                .frame(height: ResponsiveSize.height(1))
                
            CustomTabView(selectedTab: $selectedTab)
        }

    }
}

struct MainTabView_Previews: PreviewProvider {
    static var previews: some View {
        MainTabView()
    }
}
