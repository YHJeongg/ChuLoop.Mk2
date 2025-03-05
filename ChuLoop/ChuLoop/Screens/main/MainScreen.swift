//
//  MainScreen.swift
//  ChuLoop
//

import SwiftUI
import Combine

struct MainScreen: View {
    @StateObject private var controller = MainScreenController() // @StateObject 유지
    @State private var searchText: String = "" // 검색어 상태
    @State private var showSheet: Bool = false
    @State private var cancellable: AnyCancellable? // 디바운스를 위한 상태
    
    // CurrentValueSubject로 검색어를 관리
    private var searchSubject = CurrentValueSubject<String, Never>("")
    
    var body: some View {
        MainNavigationView(title: "타임라인", content: {
            VStack(spacing: 0) {
                Spacer().frame(height: ResponsiveSize.height(30))
                SearchBar(searchText: $searchText, onSearch: { newSearchText in
                    searchTextDidChange(to: newSearchText) // 검색어 변경 시 호출
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
                                    // 공유 상태에 따라 sharePost 또는 unshareEdPost 호출
                                    controller.sharePost(postId: item.id, isShared: isShared)
                                }
                            )
                            .listRowInsets(EdgeInsets()) // 리스트 기본 패딩 제거
                            .listRowSeparator(.hidden)   // 리스트 구분선 숨김
                            .listRowBackground(Color.clear)
                            .padding(.top, ResponsiveSize.height(30))
                        }

                        // 마지막 항목 뒤에 여백 추가
                        if !controller.contents.isEmpty {
                            Spacer().frame(height: ResponsiveSize.height(30)) // 마지막 항목 뒤에 30px 여백 추가
                                .listRowSeparator(.hidden) // 여백 뒤 구분선 숨기기
                        }
                    }
                    .padding(.horizontal, ResponsiveSize.width(24))
                    .listStyle(PlainListStyle()) // 기본 스타일 적용
                    .scrollIndicators(.hidden) // 스크롤 바 제거
                }
            }
            .navigationDestination(isPresented: $controller.isNavigatingToAddScreen, destination: {
                MainAddScreen(mainController: controller)
            })
            .onAppear {
                controller.fetchTimelineData(searchText: searchText)  // 처음 화면 로드 시 데이터 fetch
                setupDebounce() // 디바운스 설정을 onAppear에서 호출
            }
        }, onAddButtonTapped: {
            controller.goToAddScreen()
        })
    }
    
    // 검색어 변경 시 디바운스 적용
    func searchTextDidChange(to newValue: String) {
        searchSubject.send(newValue)  // CurrentValueSubject로 값 변경
    }

    // 디바운스 처리
    private func setupDebounce() {
        cancellable = searchSubject
            .debounce(for: .milliseconds(500), scheduler: RunLoop.main)  // 디바운스 시간 500ms
            .sink { value in
                print("디바운스된 검색어: \(value)")  // 디버깅: 디바운스된 값 확인
                controller.fetchTimelineData(searchText: value)  // 최종 검색어로 데이터 요청
            }
    }
    
    init() {
        // 디바운스 설정을 초기화에서 하지 않고 onAppear에서 호출하도록 변경
    }
}

struct MainScreen_Previews: PreviewProvider {
    static var previews: some View {
        MainScreen()
    }
}
