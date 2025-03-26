//
//  MainScreen.swift
//  ChuLoop
//

import SwiftUI
import Combine

struct MainScreen: View {
    @StateObject var controller = MainScreenController()
    @State private var searchText: String = ""
    @State private var showSheet: Bool = false
    @State private var cancellable: AnyCancellable?
    @State private var selectedPostId: String?
    
    @Binding var showTabView: Bool  // TabView 상태를 관리하는 바인딩
    
    
    var searchSubject = CurrentValueSubject<String, Never>("")
    
    
    var body: some View {
        MainNavigationView(title: "타임라인",
                           showTabView: $showTabView,
                           content: {
            VStack(spacing: 0) {
                Spacer().frame(height: ResponsiveSize.height(30))
                SearchBar(searchText: $searchText, onSearch: { newSearchText in
                    searchTextDidChange(to: newSearchText)
                })
                
                if controller.isLoading {
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle())
                        .padding()
                } else if controller.contents.isEmpty {
                    VStack {
                        Spacer()
                        Text("타임라인이 비어있어요\n")
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
                        ForEach($controller.contents) { $item in
                            TimelineCard(
                                item: $item,
                                showSheet: $showSheet,
                                isDeletable: true,
                                onDelete: {
                                    controller.deletePost(postId: item.id)
                                },
                                onShare: { isShared in
                                    controller.sharePost(postId: item.id, isShared: isShared)
                                }
                            )
                            .contentShape(Rectangle())
                            .onTapGesture {
                                selectedPostId = item.id
                                showSheet = true
                            }
                            .listRowInsets(EdgeInsets())
                            .listRowSeparator(.hidden)
                            .listRowBackground(Color.clear)
                            .padding(.top, ResponsiveSize.height(30))
                            .onAppear {
                                // 마지막 아이템이면서 로딩 중이 아닐 때만 추가 요청
                                if item.id == controller.contents.last?.id, !controller.isLoading {
                                    controller.getMainPost(searchText: searchText)
                                }
                            }
                        }

                        if controller.isLoading {
                            HStack {
                                Spacer()
                                ProgressView()
                                Spacer()
                            }
                            .padding()
                        }
                    }
                    .refreshable {
                        controller.getMainPost(searchText: searchText, isRefreshing: true)
                    }
                    .padding(.horizontal, ResponsiveSize.width(24))
                    .listStyle(PlainListStyle())
                    .scrollIndicators(.hidden)
                }
            }
            .navigationDestination(isPresented: $controller.isNavigatingToAddScreen, destination: {
                MainAddScreen(mainController: controller)
                    .onAppear {
                        showTabView = false  // 화면이 나타날 때 탭바 보이기
                    }
                    .onDisappear {
                        // 페이지를 벗어날 때 탭뷰 보이기
                        showTabView = true
                    }
            })
            .onAppear {
                controller.getMainPost(searchText: searchText)
                setupDebounce()
            }
            .sheet(isPresented: $showSheet) {
                if let postId = selectedPostId {
                    MainSheetScreen(controller: controller, postId: postId)
                }
            }
        }, onAddButtonTapped: {
            controller.goToAddScreen()
        })
    }
    
    func searchTextDidChange(to newValue: String) {
        searchSubject.send(newValue)
    }
    
    private func setupDebounce() {
        cancellable = searchSubject
            .debounce(for: .milliseconds(500), scheduler: RunLoop.main)
            .sink { value in
                controller.getMainPost(searchText: value)
            }
    }
}
