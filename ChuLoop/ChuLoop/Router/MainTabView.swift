//
//  TabView.swift
//  ChuLoop
//

import SwiftUI

struct MainTabView: View {
    var body: some View {
        TabView {
            MainScreen()
                .tabItem {
                    Label("홈", systemImage: "house.fill")
                }
            
            VisitScreen()
                .tabItem {
                    Label("방문할 맛집", systemImage: "list.bullet")
                }
            
            MapScreen()
                .tabItem {
                    Label("지도로 보기", systemImage: "map.fill")
                }
            
            ShareScreen()
                .tabItem {
                    Label("맛집 공유", systemImage: "square.and.arrow.up.fill")
                }
            
            MyPageScreen()
                .tabItem {
                    Label("마이페이지", systemImage: "person.fill")
                }
        }
    }
}

struct MainTabView_Previews: PreviewProvider {
    static var previews: some View {
        MainTabView()
    }
}
