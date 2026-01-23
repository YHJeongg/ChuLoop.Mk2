//
//  WillScreen.swift
//  ChuLoop
//

import SwiftUI
import UIKit

struct WillScreen: View {
    @StateObject private var controller = WillScreenController()
    @State private var searchText: String = ""
    @State private var isShowingSearchScreen = false
    @State private var selectedPlace: WillModel? = nil
    @State private var showTopToast = false

    @Binding var showTabView: Bool

    var body: some View {
        ZStack {
            // 메인 네비게이션
            MainNavigationView(
                title: "방문할 맛집",
                showTabView: $showTabView,
                content: {
                    VStack(spacing: 0) {
                        Spacer().frame(height: ResponsiveSize.height(30))

                        SearchBar(searchText: $searchText)
                            .padding(.horizontal)

                        ZStack {
                            // 로딩 상태
                            if controller.isLoading && controller.contents.isEmpty {
                                ProgressView()
                                    .progressViewStyle(CircularProgressViewStyle())
                                    .padding()
                            }
                            // 데이터 없음
                            else if controller.contents.isEmpty {
                                VStack {
                                    Spacer()
                                    Text("방문할 맛집 리스트가 비어있어요\n방문하고싶은 ")
                                        .foregroundColor(.natural60)
                                    + Text("맛집을 추가")
                                        .foregroundColor(.blue)
                                        .underline()
                                    + Text("해 주세요")
                                        .foregroundColor(.natural60)
                                    Spacer()
                                }
                                .font(.bodyMedium)
                                .multilineTextAlignment(.center)
                                .padding()
                            }
                            // 맛집 리스트
                            else {
                                List {
                                    ForEach(controller.contents) { place in
                                        HStack {
                                            Spacer()
                                            // 카드 컴포넌트 (id 전달을 위해 @Binding 대신 상수로 전달)
                                            WillCard(
                                                place: .constant(place),
                                                onWriteReview: {
                                                    // 리뷰쓰기 로직
                                                },
                                                onGetDirections: {
                                                    selectedPlace = place
                                                },
                                                onCopyAddress: {
                                                    showToast()
                                                }
                                            )
                                            .buttonStyle(.plain)
                                            .contentShape(Rectangle())

                                            Spacer()
                                        }
                                        .padding(.top, ResponsiveSize.height(24))
                                        .listRowInsets(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0))
                                        .listRowSeparator(.hidden)
                                        .listRowBackground(Color.clear)
                                        .onAppear {
                                            // 무한 스크롤: 마지막 아이템 도달 시 추가 로드
                                            if place.id == controller.contents.last?.id {
                                                controller.getWillPosts(searchText: searchText)
                                            }
                                        }
                                    }
                                    .onDelete(perform: deleteItems) // 👈 슬라이드 삭제 활성화
                                }
                                .listStyle(PlainListStyle())
                                .scrollIndicators(.hidden)
                            }
                        }
                        .frame(maxWidth: .infinity, maxHeight: .infinity)

                        // 검색 화면 이동을 위한 hidden 링크
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

            // 상단 토스트 UI
            if showTopToast {
                toastView
            }

            // 중앙 커스텀 시트
            if let selected = selectedPlace {
                customSheetView(selected: selected)
            }
        }
        .animation(.easeInOut, value: showTopToast)
        .animation(.easeInOut, value: selectedPlace != nil)
    }

    // 토스트 메시지
    private var toastView: some View {
        VStack {
            HStack(spacing: 0) {
                Image(systemName: "info.circle")
                    .font(.system(size: 24))
                    .foregroundColor(.primary500)
                    .padding(.horizontal, ResponsiveSize.width(15))

                Text("주소가 복사되었습니다.")
                    .font(.bodyNormal)
                    .foregroundColor(.natural80)
                
                Spacer()
            }
            .frame(width: ResponsiveSize.width(362), height: ResponsiveSize.height(60))
            .background(Color.white) // 배경색을 흰색으로 변경 (텍스트 가독성)
            .overlay(RoundedRectangle(cornerRadius: 45).stroke(Color.primary500, lineWidth: 1))
            .cornerRadius(45)
            .shadow(color: Color.black.opacity(0.1), radius: 6, y: 4)

            Spacer()
        }
        .padding(.top, ResponsiveSize.height(10))
        .transition(.move(edge: .top).combined(with: .opacity))
        .zIndex(1000)
    }

    private func customSheetView(selected: WillModel) -> some View {
        ZStack {
            Color.black.opacity(0.3)
                .ignoresSafeArea()
                .onTapGesture { selectedPlace = nil }

            WillDirectionsSheetScreen(place: selected)
                .frame(width: 300)
                .background(Color.white)
                .cornerRadius(10)
                .shadow(radius: 20)
                .transition(.scale)
                .zIndex(1)
        }
    }
    
    private func showToast() {
        let generator = UINotificationFeedbackGenerator()
        generator.notificationOccurred(.success)

        showTopToast = true
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            showTopToast = false
        }
    }

    // 맛집 리스트 삭제
    private func deleteItems(at offsets: IndexSet) {
        offsets.forEach { index in
            let postId = controller.contents[index].id
            controller.deleteWillPost(id: postId) // 컨트롤러에 삭제 요청
        }
    }
}
