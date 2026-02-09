//
//  ShareScreen.swift
//  ChuLoop
//

import SwiftUI
import Combine

struct ShareScreen: View {
    @StateObject var controller = ShareScreenController()
    @State private var searchText: String = ""
    @State private var showSheet: Bool = false
    @State private var cancellable: AnyCancellable?
    
    @State private var selectedItem: ShareModel? = nil
    @State private var showTopToast: Bool = false
    
    @Binding var showTabView: Bool
    
    var searchSubject = CurrentValueSubject<String, Never>("")

    var body: some View {
        ZStack {
            MainNavigationView(title: "맛집 커뮤니티", showTabView: $showTabView, content: {
                VStack(spacing: 0) {
                    Spacer().frame(height: ResponsiveSize.height(30))
                    
                    SearchBar(searchText: $searchText, onSearch: { newSearchText in
                        searchSubject.send(newSearchText)
                    })
                    
                    if controller.isLoading && controller.contents.isEmpty {
                        ProgressView().padding()
                        Spacer()
                    } else {
                        List {
                            ForEach($controller.contents) { $item in
                                ShareCard(
                                    item: $item,
                                    showSheet: $showSheet,
                                    onLike: {
                                        controller.likedPost(postId: item.id)
                                    },
                                    onShare: {
                                        selectedItem = item
                                    }
                                )
                                .listRowInsets(EdgeInsets())
                                .listRowSeparator(.hidden)
                                .listRowBackground(Color.clear)
                                .padding(.top, ResponsiveSize.height(30))
                                .onAppear {
                                    if item.id == controller.contents.last?.id {
                                        controller.getSharePost(searchText: searchText)
                                    }
                                }
                            }
                        }
                        .refreshable {
                            controller.getSharePost(searchText: searchText, isRefreshing: true)
                        }
                        .padding(.horizontal, ResponsiveSize.width(24))
                        .listStyle(PlainListStyle())
                        .scrollIndicators(.hidden)
                    }
                }
                .onAppear {
                    controller.getSharePost()
                    setupDebounce()
                }
            })

            // 지도로 보기 중앙 팝업 레이어
            if let item = selectedItem {
                ZStack {
                    Color.black.opacity(0.4)
                        .ignoresSafeArea()
                        .onTapGesture { selectedItem = nil }

                    MapDirectionSheet(
                        title: item.title,
                        address: item.address,
                        onCopy: {
                            selectedItem = nil
                            showTopToast = true
                        }
                    )
                    .frame(width: 300)
                    .background(Color.white)
                    .cornerRadius(12)
                    .shadow(radius: 10)
                }
                .zIndex(100)
            }
        }
        .showSaveToast(isShowing: $showTopToast, message: "주소가 복사되었습니다.")
        .animation(nil, value: selectedItem == nil)
    }

    private func setupDebounce() {
        cancellable = searchSubject
            .debounce(for: .milliseconds(500), scheduler: RunLoop.main)
            .sink { value in
                controller.getSharePost(searchText: value, isRefreshing: true)
            }
    }
}
