//
//  HeartScreen.swift
//  ChuLoop

import SwiftUI

struct HeartScreen: View {
    @State private var searchText: String = "" // 검색어 상태
    @State private var showSheet: Bool = false
    @State private var items: [MainModel] = []
    
    var body: some View {
        VStack {
            SearchBar(searchText: $searchText)
                .padding(.horizontal)
                .padding(.top)
            
            if items.isEmpty {
                VStack {
                    Spacer()
                    
                    Text("하트 게시물이 없어요\n하트를 눌러서 맛집을 추가해보세요")
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
        .navigationTitle("하트")
    }
}

#Preview {
    HeartScreen()
}
