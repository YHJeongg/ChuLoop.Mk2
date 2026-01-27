//
//  ShareScreen.swift
//  ChuLoop
//

import SwiftUI
import Combine

struct ShareScreen: View {
    @StateObject var controller = ShareScreenController() // Share용 컨트롤러가 있다고 가정
    @State private var searchText: String = ""
    @State private var showSheet: Bool = false
    @State private var selectedPostId: String?
    @State private var cancellable: AnyCancellable?
    
    @Binding var showTabView: Bool  // TabView 상태를 관리하는 바인딩
    
    var searchSubject = CurrentValueSubject<String, Never>("")

    var body: some View {
        MainNavigationView(
            title: "맛집 커뮤니티",
            showTabView: $showTabView,
            content: {
                VStack(spacing: 0) {
                    Spacer().frame(height: ResponsiveSize.height(30))
                    
                    // 검색바
                    SearchBar(searchText: $searchText, onSearch: { newSearchText in
                        searchTextDidChange(to: newSearchText)
                    })
                    
                    if controller.isLoading && controller.contents.isEmpty {
                        ProgressView()
                            .progressViewStyle(CircularProgressViewStyle())
                            .padding()
                            .frame(maxWidth: .infinity, maxHeight: .infinity)
                    } else if controller.contents.isEmpty {
                        VStack {
                            Spacer()
                            Text("공유된 맛집이 없어요\n타임라인에 올린 맛집을 함께 공유해보세요")
                                .font(.bodyMedium)
                                .foregroundColor(.natural60)
                                .multilineTextAlignment(.center)
                            Spacer()
                        }
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                        .padding()
                    } else {
                        List {
                            ForEach($controller.contents) { $item in
                                TimelineCard(
                                    item: $item,
                                    showSheet: $showSheet,
                                    isDeletable: false, // 커뮤니티 화면이므로 본인 것 외엔 삭제 불가 처리(필요시 로직 추가)
                                    onDelete: {
                                        // 삭제 로직 필요 시 추가
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
                                    // 무한 스크롤: 마지막 아이템 도달 시 추가 데이터 로드
                                    if item.id == controller.contents.last?.id, !controller.isLoading {
                                        controller.getSharePost(searchText: searchText)
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
                            controller.getSharePost(searchText: searchText, isRefreshing: true)
                        }
                        .padding(.horizontal, ResponsiveSize.width(24))
                        .listStyle(PlainListStyle())
                        .scrollIndicators(.hidden)
                    }
                }
                .onAppear {
                    controller.getSharePost(searchText: searchText)
                    setupDebounce()
                }
                .sheet(isPresented: $showSheet) {
                    if let postId = selectedPostId {
                        // 공유 전용 상세 시트가 있다면 교체, 없다면 MainSheetScreen 재사용
                        MainSheetScreen(controller: MainScreenController(), postId: postId)
                    }
                }
            },
            onAddButtonTapped: {
                // 커뮤니티 화면의 글쓰기 버튼 동작 (필요 시 작성)
            }
        )
    }

    // 검색어 변경 감지
    func searchTextDidChange(to newValue: String) {
        searchSubject.send(newValue)
    }

    // 검색 디바운스 설정 (0.5초 대기 후 검색 실행)
    private func setupDebounce() {
        cancellable = searchSubject
            .debounce(for: .milliseconds(500), scheduler: RunLoop.main)
            .sink { value in
                controller.getSharePost(searchText: value)
            }
    }
}
