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
                    Spacer().frame(height: 6)

                    Text("주소가 복사되었습니다")
                        .font(.bodySmall)
                        .foregroundColor(.white)
                        .padding(.horizontal, 20)
                        .padding(.vertical, 10)
                        .background(Color.black.opacity(0.9))
                        .cornerRadius(20)
                        .shadow(radius: 8)

                    Spacer()
                }
                .padding(.top, topSafeArea())
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
