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
                        .font(.bodyXXSmall)
                }
            
            VisitScreen()
                .tabItem {
                    Image(systemName: "list.bullet")
                    Text("방문할 맛집")
                        .font(.bodyXXSmall)
                }
            
            MapScreen()
                .tabItem {
                    Image(systemName: "map.fill")
                    Text("지도로 보기")
                        .font(.bodyXXSmall)
                }
            
            ShareScreen()
                .tabItem {
                    Image(systemName: "square.and.arrow.up.fill")
                    Text("맛집 공유")
                        .font(.bodyXXSmall)
                }
            
            MyPageScreen()
                .tabItem {
                    Image(systemName: "person.fill")
                    Text("마이페이지")
                        .font(.bodyXXSmall)
                }
        }
        .background(.blue)
       
    }
    
    
}

struct MainTabView_Previews: PreviewProvider {
    static var previews: some View {
        MainTabView()
    }
}
