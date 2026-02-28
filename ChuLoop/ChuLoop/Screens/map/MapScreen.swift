//
//  MapScreen.swift
//  ChuLoop
//

import SwiftUI
import MapKit

struct MapScreen: View {
    @StateObject private var controller = MapScreenController()
    
    @State private var region = MKCoordinateRegion(
        center: CLLocationCoordinate2D(latitude: 37.5665, longitude: 126.9780),
        span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
    )
    
    @State private var showOptions = false
    @State private var selectedPlace: MapModel? = nil
    @State private var showSheet = false
    
    @Binding var showTabView: Bool

    var body: some View {
        MainNavigationView(title: "맛집지도", showTabView: $showTabView, content: {
            ZStack {
                // 지도 레이어
                Map(coordinateRegion: $region, showsUserLocation: true, annotationItems: controller.contents) { item in
                    MapAnnotation(coordinate: item.coordinate) {
                        VStack(spacing: 4) {
                            ImageView(
                                imageName: item.type == 0 ? "blue-marker" : "red-marker",
                                width: 32,
                                height: 32
                            )
                            .shadow(radius: 2)
                            
                            Text(item.title)
                                .font(.bodyXSmall)
                                .foregroundColor(.natural90)
                                .padding(.horizontal, 8).padding(.vertical, 4)
                                .background(Color.white.opacity(0.9))
                                .cornerRadius(4).shadow(radius: 1)
                        }
                        .onTapGesture {
                            withAnimation(.spring()) {
                                selectedPlace = item
                                showSheet = true
                            }
                        }
                    }
                }
                .onAppear { fetch(type: nil) }

                // 배경 터치 감지 레이어
                if showSheet {
                    Color.black.opacity(0.001)
                        .ignoresSafeArea()
                        .onTapGesture {
                            withAnimation(.smooth()) {
                                showSheet = false
                            }
                        }
                }

                // 우측 하단 필터 버튼 레이어
                VStack {
                    Spacer()
                    HStack {
                        Spacer()
                        VStack(alignment: .trailing, spacing: 12) {
                            if showOptions {
                                subFilterButton(title: "가보고 싶은 맛집", color: .error) { fetch(type: 1) }
                                subFilterButton(title: "방문한 맛집", color: .blue) { fetch(type: 0) }
                            }

                            Button(action: {
                                if showOptions {
                                    fetch(type: nil)
                                    withAnimation { showOptions = false }
                                } else {
                                    withAnimation { showOptions.toggle() }
                                }
                            }) {
                                Text("전체보기")
                                    .font(.bodyLarge)
                                    .foregroundColor(.natural80)
                                    .frame(width: ResponsiveSize.width(100), height: ResponsiveSize.height(50))
                                    .background(Color.primary50)
                                    .cornerRadius(8)
                                    .shadow(radius: 2)
                            }
                        }
                        .padding(.bottom, ResponsiveSize.height(24))
                        .padding(.trailing, ResponsiveSize.width(24))
                    }
                }
                .zIndex(1.0)

                // 바텀 시트 레이어
                if showSheet, let place = selectedPlace {
                    VStack {
                        Spacer()
                        MapBottomSheet(
                            item: place,
                            onAddressTap: { _ in },
                            onReviewTap: { item in
                                print("\(item.title) 리뷰 작성 페이지 이동")
                                withAnimation { showSheet = false }
                            }
                        )
                        .transition(.move(edge: .bottom))
                    }
                    .zIndex(2.0)
                    .ignoresSafeArea(edges: .bottom)
                }

                if controller.isLoading {
                    ProgressView().padding().background(Color.white.opacity(0.8)).cornerRadius(10)
                }
            }
        }, onAddButtonTapped: {
            print("맛집 추가 화면 이동")
        })
    }

    private func fetch(type: Int?) {
        controller.getMapMarkers(lat: region.center.latitude, lng: region.center.longitude, type: type)
    }

    @ViewBuilder
    private func subFilterButton(title: String, color: Color, action: @escaping () -> Void) -> some View {
        Button(action: {
            action()
            withAnimation { showOptions = false }
        }) {
            Text(title)
                .font(.bodyLarge)
                .foregroundColor(.white)
                .padding(.horizontal, 15)
                .padding(.vertical, 12)
                .background(color)
                .cornerRadius(8)
                .shadow(radius: 2)
        }
        .transition(.move(edge: .bottom).combined(with: .opacity))
    }
}
