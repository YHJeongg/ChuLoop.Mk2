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
                    Image(systemName: "house.fill")
                    Text("홈")
                        .font(.Cookie10)
                }

            
            VisitScreen()
                .tabItem {
                    Image(systemName: "list.bullet")
                    Text("방문할 맛집")
                        .font(.Cookie10)
                }
            
            MapScreen()
                .tabItem {
                    Image(systemName: "map.fill")
                    Text("지도로 보기")
                }
            
            ShareScreen()
                .tabItem {
                    Image(systemName: "square.and.arrow.up.fill")
                    Text("맛집 공유")
                }
            
            MyPageScreen()
                .tabItem {
                    Image(systemName: "person.fill")
                    Text("마이페이지")
                }
        }
    }
}

struct MainTabView_Previews: PreviewProvider {
    static var previews: some View {
        MainTabView()
    }
}
