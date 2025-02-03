//
//  ShareScreen.swift
//  ChuLoop
//

import SwiftUI

struct ShareScreen: View {
    @State private var searchText: String = "" // 검색어 상태
    @State private var showSheet: Bool = false
    @State private var items: [MainModel] = []
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
