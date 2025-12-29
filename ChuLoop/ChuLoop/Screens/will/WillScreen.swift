//
//  WillScreen.swift
//  ChuLoop
//

import SwiftUI

struct WillScreen: View {
    @StateObject private var controller = WillScreenController()
    @State private var searchText: String = ""
    @State private var isShowingSearchScreen = false
    @State private var selectedPlace: WillModel? = nil

    @Binding var showTabView: Bool

    var body: some View {
        ZStack {
            MainNavigationView(
                title: "방문할 맛집",
                showTabView: $showTabView,
                content: {
                    VStack(spacing: 0) {
                        Spacer().frame(height: ResponsiveSize.height(30))
                        SearchBar(searchText: $searchText)
                            .padding(.horizontal)

                        ZStack {

                            // 로딩
                            if controller.isLoading {
                                ProgressView()
                                    .progressViewStyle(CircularProgressViewStyle())
                                    .padding()
                            } else if controller.contents.isEmpty {
                                VStack {
                                    Spacer()
                                    Text("방문할 맛집 리스트가 비어있어요\n방문하고싶은 ")
                                        .foregroundColor(.natural60) +
                                    Text("맛집을 추가")
                                        .foregroundColor(.blue)
                                        .underline() +
                                    Text("해 주세요")
                                        .foregroundColor(.natural60)
                                    
                                    Spacer()
                                }
                                .font(.bodyMedium)
                                .frame(maxWidth: .infinity, maxHeight: .infinity)
                                .multilineTextAlignment(.center)
                                .padding()
                            } else {
                                List {
                                    ForEach($controller.contents) { $place in
                                        HStack {
                                            Spacer()
                                            
                                            WillCard(place: $place) {
                                                selectedPlace = place
                                            }
                                            
                                            Spacer()
                                        }
                                        .padding(.top, ResponsiveSize.height(24))
                                        .listRowInsets(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0))
                                        .listRowSeparator(.hidden)
                                        .listRowBackground(Color.clear)
                                        .onAppear {
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
                                .listStyle(PlainListStyle())
                                .scrollIndicators(.hidden)
                            }
                        }
                        .frame(maxWidth: .infinity, maxHeight: .infinity)

                        NavigationLink(
                            destination: SearchRestaurantScreen(showTabView: $showTabView),
                            isActive: $isShowingSearchScreen
                        ) {
                            EmptyView()
                        }
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .onAppear {
                        controller.getWillPosts(searchText: searchText)
                    }
                },
                onAddButtonTapped: {
                    showTabView = false
                    isShowingSearchScreen = true
                }
            )

            // 중앙 커스텀 시트
            if let selected = selectedPlace {
                Color.black.opacity(0.3)
                    .ignoresSafeArea()
                    .onTapGesture {
                        selectedPlace = nil
                    }

                WillDirectionsSheetScreen(place: selected)
                    .frame(width: 300)
                    .background(Color.white)
                    .cornerRadius(10)
                    .shadow(radius: 20)
                    .transition(.scale)
                    .zIndex(1)
            }
        }
        .animation(.easeInOut, value: selectedPlace != nil)
    }
}
