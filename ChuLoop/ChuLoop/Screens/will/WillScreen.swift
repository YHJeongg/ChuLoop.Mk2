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

    @State private var showTopToast = false   // 상단 토스트 상태

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
                            // 로딩
                            if controller.isLoading {
                                ProgressView()
                                    .progressViewStyle(CircularProgressViewStyle())
                                    .padding()

                            // 데이터 없음
                            } else if controller.contents.isEmpty {
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

                            // 리스트
                            } else {
                                List {
                                    ForEach($controller.contents) { $place in
                                        HStack {
                                            Spacer()

                                            WillCard(
                                                place: $place,
                                                onWriteReview: {
                                                    // 리뷰쓰기
                                                },
                                                onGetDirections: {
                                                    selectedPlace = place
                                                },
                                                onCopyAddress: {
                                                    showToast()   // 토스트 호출
                                                }
                                            )
                                            .buttonStyle(.plain)
                                            .contentShape(Rectangle())

                                            Spacer()
                                        }
                                        .padding(.top, ResponsiveSize.height(24))
                                        .listRowInsets(
                                            EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0)
                                        )
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

            // 상단 토스트
            if showTopToast {
                VStack {
                    HStack(spacing: 0) {
                        Image(systemName: "info.circle")
                            .font(.system(size: 24))
                            .foregroundColor(.primary500)
                            .padding(.horizontal, ResponsiveSize.width(15))

                        // 메시지
                        Text("주소가 복사되었습니다.")
                            .font(.bodyNormal)
                            .foregroundColor(.natural80)
                        
                        Spacer()
                    }
                    .frame(width: ResponsiveSize.width(362),
                           height: ResponsiveSize.height(60),
                           alignment: .leading)
                    .background(Color.gray)
                    .overlay(
                        RoundedRectangle(cornerRadius: 45)
                            .stroke(Color.primary500, lineWidth: 1)
                    )
                    .cornerRadius(45)
//                    .shadow(color: Color.black.opacity(0.1), radius: 6, y: 4)

                    Spacer()
                }
                .padding(.horizontal, ResponsiveSize.width(34))
                .padding(.top, ResponsiveSize.height(10))
                .transition(.move(edge: .top).combined(with: .opacity))
                .zIndex(1000)
            }

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
        .animation(.easeInOut, value: showTopToast)
        .animation(.easeInOut, value: selectedPlace != nil)
    }

    // MARK: - 토스트 표시
    private func showToast() {
        let generator = UINotificationFeedbackGenerator()
        generator.notificationOccurred(.success)

        showTopToast = true
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            showTopToast = false
        }
    }

    private func topSafeArea() -> CGFloat {
        UIApplication.shared.connectedScenes
            .compactMap { ($0 as? UIWindowScene)?.windows.first?.safeAreaInsets.top }
            .first ?? 44
    }
}
