//
//  ShareScreen.swift
//  ChuLoop
//

import SwiftUI

struct ShareScreen: View {
    @State private var searchText: String = "" // 검색어 상태
    @State private var showSheet: Bool = false
    @State private var items: [TimelineItem] = [
        TimelineItem(
            image: "MainTest",
            title: "가게이름은10글자까지...",
            location: "인천광역시 마포구 가좌동 만와 20길 1층",
            date: "2025.01.03 (수)",
            rating: 4.5,
            isShared: false
        ),
        TimelineItem(
            image: "MainTest",
            title: "맛집이름도 길게 설정 가능",
            location: "서울특별시 강남구 역삼동 123번지",
            date: "2025.01.02 (화)",
            rating: 4.8,
            isShared: true
        )
    ]
    @State private var isSecondPage: Bool = false
    
    
    var body: some View {
        MainNavigationView(title: "맛집 커뮤니티", content: {
            VStack {
                SearchBar(searchText: $searchText)
                    .padding(.horizontal)
                    .padding(.top)
                
                if items.isEmpty {
                    VStack {
                        Spacer()
                        
                        Text("공유된 맛집이 없어요\n타임라인에 올린 맛집을 함께 공유해보세요")
                            .font(.bodyMedium)
                            .foregroundColor(.gray)
                            .multilineTextAlignment(.center)
                            .padding()
                        
                        Spacer()
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                } else {
                    ScrollView {
                        VStack(spacing: 20) {
                            ForEach($items) { $item in
                                TimelineCard(item: $item, showSheet: $showSheet)
                            }
                        }
                        .padding()
                    }
                }
            }
            .sheet(isPresented: $showSheet) {
                MainSheetScreen()
            }
        }
        )
    }
}

#Preview {
    ShareScreen()
}
