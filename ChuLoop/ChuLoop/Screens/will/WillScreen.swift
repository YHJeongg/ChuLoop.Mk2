//
//  VisitScreen.swift
//  ChuLoop
//

import SwiftUI

struct WillScreen: View {
    @StateObject private var controller = WillScreenController()
    @State private var searchText: String = ""
    @Binding var showTabView: Bool

    var body: some View {
        MainNavigationView(title: "방문할 맛집", showTabView: $showTabView, content: {
            VStack(spacing: 0) {
                SearchBar(searchText: $searchText)
                    .padding(.horizontal)
                    .padding(.top)
                
                if controller.isLoading && controller.contents.isEmpty {
                    ProgressView()
                        .padding()
                } else if controller.contents.isEmpty {
                    Text("방문할 맛집 리스트가 비어있어요\n방문하고 싶은 맛집을 추가해 주세요")
                        .multilineTextAlignment(.center)
                        .foregroundColor(.gray)
                        .padding()
                } else {
                    List {
                        ForEach($controller.contents) { $place in
                            WillCard(place: $place)
                                .onAppear {
                                    // 마지막 아이템에서 추가 데이터 로드
                                    if place.id == controller.contents.last?.id {
                                        controller.getWillPosts(searchText: searchText)
                                    }
                                }
                        }
                        
                        if controller.isLoading {
                            HStack {
                                Spacer()
                                ProgressView()
                                Spacer()
                            }
                        }
                    }
                    .refreshable {
                        // 새로 고침
                        controller.getWillPosts(searchText: searchText, isRefreshing: true)
                    }
                }
            }
            .onAppear {
                // 화면 등장 시 데이터를 로드
                controller.getWillPosts(searchText: searchText)
            }
        }, onAddButtonTapped: {
            // Add 버튼이 눌리면 호출되는 부분
//            controller.goToAddScreen()
        })
    }
}
