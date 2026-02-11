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
            MainNavigationView(
                title: "방문할 맛집",
                showTabView: $showTabView,
                content: {
                    VStack(spacing: 0) {
                        Spacer().frame(height: ResponsiveSize.height(30))

                        SearchBar(searchText: $searchText)
                            .padding(.horizontal)

                        ZStack {
                            if controller.isLoading && controller.contents.isEmpty {
                                ProgressView()
                                    .progressViewStyle(CircularProgressViewStyle())
                                    .padding()
                            }
                            else if controller.contents.isEmpty {
                                emptyListView
                            }
                            else {
                                postListView
                            }
                        }
                        .frame(maxWidth: .infinity, maxHeight: .infinity)

                        NavigationLink(
                            destination: SearchRestaurantScreen(
                                showTabView: $showTabView,
                                isShowingSearchScreen: $isShowingSearchScreen
                            ),
                            isActive: $isShowingSearchScreen
                        ) {
                            EmptyView()
                        }
                    }
                    .onAppear {
                        controller.getWillPosts(searchText: searchText)
                    }
                },
                onAddButtonTapped: {
                    showTabView = false
                    isShowingSearchScreen = true
                }
            )

            // 중앙 팝업 레이어
            if let selected = selectedPlace {
                ZStack {
                    Color.black.opacity(0.3)
                        .ignoresSafeArea()
                        .onTapGesture {
                            selectedPlace = nil
                        }

                    MapDirectionSheet(
                        title: selected.title,
                        address: selected.address,
                        onCopy: {
                            // 팝업 즉시 닫기
                            selectedPlace = nil
                            // 토스트 및 햅틱 알림 실행
                            triggerToast()
                        }
                    )
                    .frame(width: 300)
                    .background(Color.white)
                    .cornerRadius(10)
                    .shadow(color: .black.opacity(0.2), radius: 20)
                    .transition(.scale.combined(with: .opacity))
                    .zIndex(1)
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .zIndex(100)
            }
        }
        .showSaveToast(isShowing: $showTopToast, message: "주소가 복사되었습니다.")
        .animation(.easeInOut(duration: 0.2), value: selectedPlace != nil)
    }

    // MARK: - Subviews
    
    private var emptyListView: some View {
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

    private var postListView: some View {
        List {
            ForEach(controller.contents) { place in
                HStack {
                    Spacer()
                    WillCard(
                        place: .constant(place),
                        onWriteReview: {
                            // 리뷰 작성 페이지
                        },
                        onGetDirections: {
                            // 길찾기 버튼 클릭 시 팝업 띄우기
                            selectedPlace = place
                        },
                        onCopyAddress: {
                            // 카드에서 바로 주소 복사 시
                            UIPasteboard.general.string = place.address
                            triggerToast()
                        }
                    )
                    .buttonStyle(.plain)
                    Spacer()
                }
                .padding(.top, ResponsiveSize.height(24))
                .listRowInsets(EdgeInsets())
                .listRowSeparator(.hidden)
                .listRowBackground(Color.clear)
                .onAppear {
                    if place.id == controller.contents.last?.id {
                        controller.getWillPosts(searchText: searchText)
                    }
                }
            }
            .onDelete(perform: deleteItems)
        }
        .listStyle(PlainListStyle())
        .scrollIndicators(.hidden)
    }

    // MARK: - Helper Actions
    private func triggerToast() {
        // 성공 햅틱 피드백
        let generator = UINotificationFeedbackGenerator()
        generator.notificationOccurred(.success)
        showTopToast = true
    }

    private func deleteItems(at offsets: IndexSet) {
        offsets.forEach { index in
            let postId = controller.contents[index].id
            controller.deleteWillPost(id: postId)
        }
    }
}
