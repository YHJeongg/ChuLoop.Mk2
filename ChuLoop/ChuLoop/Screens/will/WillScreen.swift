//
//  VisitScreen.swift
//  ChuLoop
//

import SwiftUI

struct WillScreen: View {
    @StateObject private var controller = WillScreenController()
    @State private var searchText: String = ""
    @State private var isShowingSearchScreen = false
    @Binding var showTabView: Bool

    var body: some View {
        MainNavigationView(title: "방문할 맛집", showTabView: $showTabView, content: {
            VStack(spacing: 0) {
                SearchBar(searchText: $searchText)
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
                                    if place.id == controller.contents.last?.id {
                                        controller.getWillPosts(searchText: searchText)
                                    }
                                }
                        }
                        .listRowSeparator(.hidden)
                        .listRowBackground(Color.clear)
                        
                        if controller.isLoading {
                            HStack {
                                Spacer()
                                ProgressView()
                                Spacer()
                            }
                        }
                    }
                    .refreshable {
                        controller.getWillPosts(searchText: searchText, isRefreshing: true)
                    }
                    .listStyle(PlainListStyle())
                    .scrollIndicators(.hidden)
                }

                // 화면 전환용 NavigationLink
                NavigationLink(destination: SearchRestaurantScreen(showTabView: $showTabView), isActive: $isShowingSearchScreen) {
                    EmptyView()
                }
            }
            .onAppear {
                controller.getWillPosts(searchText: searchText)
            }
        }, onAddButtonTapped: {
            showTabView = false
            isShowingSearchScreen = true
        })
    }
}
