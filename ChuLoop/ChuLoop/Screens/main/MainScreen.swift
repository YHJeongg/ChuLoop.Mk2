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
        MainNavigationView(title: "타임라인", content: {
            VStack {
                // Search bar
                SearchBar(searchText: $searchText)
                
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
                                onShare: {
                                    controller.sharePost(postId: item.id)
                                }
                            )
                            .listRowInsets(EdgeInsets()) // 리스트 기본 패딩 제거
                            .listRowSeparator(.hidden)   // 리스트 구분선 숨김
                            .listRowBackground(Color.clear)
                            .padding(.top, ResponsiveSize.height(0.0268))
                        }
                        // 마지막 항목 뒤에 여백 추가
                        if !controller.contents.isEmpty {
                            Spacer().frame(height: ResponsiveSize.height(0.0268)) // 마지막 항목 뒤에 30px 여백 추가
                                .listRowSeparator(.hidden) // 여백 뒤 구분선 숨기기
                            }
                    }
                    .padding(.horizontal, ResponsiveSize.width(0.0558))
                    .listStyle(PlainListStyle()) // 기본 스타일 적용
                    .scrollIndicators(.hidden) // ✅ 스크롤 바 제거
                    
                }
                
            }
            .navigationDestination(isPresented: $controller.isNavigatingToAddScreen, destination: {
                MainAddScreen(mainController: controller)
            })
            .onAppear {
                controller.fetchTimelineData()  // 데이터를 fetch
            }
        }, onAddButtonTapped: {
            controller.goToAddScreen()
        })
    }
}

struct MainScreen_Previews: PreviewProvider {
    static var previews: some View {
        MainScreen()
    }
}
