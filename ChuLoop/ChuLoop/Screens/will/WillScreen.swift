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
    @State private var selectedPlace: WillModel? = nil // 중앙 팝업 제어용
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

            // 커스텀 중앙 팝업
            if let selected = selectedPlace {
                ZStack {
                    Color.black.opacity(0.3)
                        .ignoresSafeArea()
                        .onTapGesture {
                            withAnimation(.easeInOut(duration: 0.2)) {
                                selectedPlace = nil
                            }
                        }

                    MapDirectionSheet(
                        title: selected.title,
                        address: selected.address,
                        onCopy: {
                            withAnimation(.easeInOut(duration: 0.2)) {
                                selectedPlace = nil
                            }
                            showToast()
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

            // 토스트 메시지
            if showTopToast {
                toastView
            }
        }
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
                        onWriteReview: { /* 리뷰 작성 로직 */ },
                        onGetDirections: {
                            withAnimation(.easeInOut(duration: 0.2)) {
                                selectedPlace = place
                            }
                        },
                        onCopyAddress: {
                            UIPasteboard.general.string = place.address
                            showToast()
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
            .background(Color.white)
            .overlay(RoundedRectangle(cornerRadius: 45).stroke(Color.primary500, lineWidth: 1))
            .cornerRadius(45)
            .shadow(color: Color.black.opacity(0.1), radius: 6, y: 4)

            Spacer()
        }
        .padding(.top, ResponsiveSize.height(10))
        .transition(.move(edge: .top).combined(with: .opacity))
        .zIndex(1000)
    }

    // MARK: - Actions
    private func showToast() {
        let generator = UINotificationFeedbackGenerator()
        generator.notificationOccurred(.success)

        withAnimation { showTopToast = true }
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            withAnimation { showTopToast = false }
        }
    }

    private func deleteItems(at offsets: IndexSet) {
        offsets.forEach { index in
            let postId = controller.contents[index].id
            controller.deleteWillPost(id: postId)
        }
    }
}
