//
//  MainScreen.swift
//  ChuLoop
//

import SwiftUI

struct MainScreen: View {
    @StateObject private var controller = MainScreenController()
    @State private var searchText: String = "" // 검색어 상태
    @State private var showSheet: Bool = false
    
    var body: some View {
        MainNavigationView(title: "타임라인") {
            VStack {
                // Search bar
                SearchBar(searchText: $searchText)
                    .padding(.horizontal)
                    .padding(.top)
                
                if controller.isLoading {
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle())
                        .padding()
                } else if controller.contents.isEmpty {
                    VStack {
                        Spacer()
                        Text("타임라인이 비어있어요\n방문했던 맛집을 추가해 주세요")
                            .font(.bodyMedium)
                            .foregroundColor(.black)
                            .multilineTextAlignment(.center)
                            .padding()
                        Spacer()
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                } else {
                    ScrollView {
                        VStack(spacing: 20) {
                            ForEach($controller.contents) { $item in
                                TimelineCard(item: $item, showSheet: $showSheet)
                            }
                        }
                        .padding()
                    }
                }
            }
            .onAppear {
                controller.fetchTimelineData()  // 데이터를 fetch
            }
        }
    }
}

struct MainScreen_Previews: PreviewProvider {
    static var previews: some View {
        MainScreen()
    }
}
