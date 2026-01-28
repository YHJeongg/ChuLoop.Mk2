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
    @Binding var showTabView: Bool
    
    var searchSubject = CurrentValueSubject<String, Never>("")

    var body: some View {
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
                                    // 하트 클릭 시 로직
                                    print("하트 클릭됨: \(item.id)")
                                },
                                onShare: {
                                    print("공유 버튼 클릭됨")
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
    }

    private func setupDebounce() {
        cancellable = searchSubject
            .debounce(for: .milliseconds(500), scheduler: RunLoop.main)
            .sink { value in
                controller.getSharePost(searchText: value, isRefreshing: true)
            }
    }
}
