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
    
            Button {
                selectedTab = .home
            } label: {
                VStack(spacing: 8) {
                    ImageView(imageName: selectedTab == .home ? "selected-home" : "home", width: 34.0, height: 34.0)
                    Text("홈")
                        .foregroundColor(selectedTab == .home ? .primary500 : .natural70)
                        .font(.bodyXXSmall)
                        .frame(width: 60, alignment: Alignment.center)
                }
            }
            .padding(.top, 15)
            .padding(.trailing, 12)
            
            Button {
                selectedTab = .visit
            } label: {
                VStack(spacing: 8) {
                    ImageView(imageName: selectedTab == .visit ? "selected-cupcake" : "cupcake", width: 34.0, height: 34.0)
                    
                    Text("방문할 맛집")
                        .foregroundColor(selectedTab == .visit ? .primary500 : .natural70)
                        .font(.bodyXXSmall)
                        .frame(width: 60, alignment: Alignment.center)
                }
            }
            .padding(.top, 15)
            .padding(.horizontal, 12.5)
            
            Button {
                selectedTab = .map
            } label: {
                VStack(spacing: 8) {
                    ImageView(imageName: selectedTab == .map ? "selected-map" : "map", width: 34.0, height: 34.0)
                    
                    Text("지도로 보기")
                        .foregroundColor(selectedTab == .map ? .primary500 : .natural70)
                        .font(.bodyXXSmall)
                        .frame(width: 60, alignment: Alignment.center)
                }
            }
            .padding(.top, 15)
            .padding(.horizontal, 12.5)
            
            Button {
                selectedTab = .share
            } label: {
                VStack(spacing: 8) {
                    ImageView(imageName: selectedTab == .share ? "selected-planet" : "planet", width: 34.0, height: 34.0)
                    
                    Text("맛집 공유")
                        .foregroundColor(selectedTab == .share ? .primary500 : .natural70)
                        .font(.bodyXXSmall)
                        .frame(width: 60, alignment: Alignment.center)
                }
            }
            .padding(.top, 15)
            .padding(.horizontal, 12.5)
        
            Button {
                selectedTab = .mypage
            } label: {
                VStack(spacing: 8) {
                    ImageView(imageName: selectedTab == .mypage ? "selected-profile" :  "profile", width: 34.0, height: 34.0)
                    
                    Text("마이페이지")
                        .foregroundColor(selectedTab == .mypage ? .primary500 : .natural70)
                        .font(.bodyXXSmall)
                        .frame(width: 60, alignment: Alignment.center)
                }
            }
            .padding(.top, 15)
            .padding(.leading, 12)
        }
    }
}
