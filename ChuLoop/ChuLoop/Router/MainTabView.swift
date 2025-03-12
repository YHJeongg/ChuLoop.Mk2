//
//  TabView.swift
//  ChuLoop
//

import SwiftUI

struct MainTabView: View {
    
    @State var selectedTab: Tab = .home
    @State private var showTabView = true  // TabView가 표시되는지 여부를 제어하는 상태
    
    
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
                MyPageScreen(showTabView: $showTabView)  // MyPageNavigationView로 상태 전달
            }
            // 구분선 추가
            Rectangle()
                .fill(Color.natural20) // 구분선 색상 조정)
                .frame(height: ResponsiveSize.height(1))
            // TabView가 보일 때만 나타나도록 처리
            if showTabView {
                CustomTabView(selectedTab: $selectedTab)
            }
        }
    
    }
}

struct MainTabView_Previews: PreviewProvider {
    static var previews: some View {
        MainTabView()
    }
}
