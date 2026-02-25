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
    @Binding var showTabView: Bool

    var body: some View {
        MainNavigationView(title: "맛집지도", showTabView: $showTabView, content: {
            ZStack {
                Map(coordinateRegion: $region, showsUserLocation: true, annotationItems: controller.contents) { item in
                    MapAnnotation(coordinate: item.coordinate) {
                        VStack(spacing: 4) {
                            Image(systemName: "mappin.circle.fill")
                                .font(.title)
                                .foregroundColor(item.type == 0 ? .blue : .error)
                                .shadow(radius: 2)
                            
                            Text(item.title)
                                .font(.bodyXSmall)
                                .foregroundColor(.natural90)
                                .padding(.horizontal, 8).padding(.vertical, 4)
                                .background(Color.white.opacity(0.9))
                                .cornerRadius(4).shadow(radius: 1)
                        }
                    }
                }
                .onAppear { fetch(type: nil) } // 처음엔 전체보기

                // 버튼 레이어
                VStack {
                    Spacer()
                    HStack {
                        Spacer()
                        VStack(alignment: .trailing, spacing: 12) {
                            if showOptions {
                                // 가보고 싶은 맛집 (Type 1 -> Red)
                                subFilterButton(title: "가보고 싶은 맛집", color: .error) {
                                    fetch(type: 1)
                                }
                                
                                // 방문한 맛집 (Type 0 -> Blue)
                                subFilterButton(title: "방문한 맛집", color: .blue) {
                                    fetch(type: 0)
                                }
                            }

                            // 메인 버튼 (전체보기)
                            Button(action: {
                                if showOptions {
                                    fetch(type: nil) // 옵션 열려있을 때 누르면 전체 데이터 요청
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

                if controller.isLoading {
                    ProgressView().padding().background(Color.white.opacity(0.8)).cornerRadius(10)
                }
            }
        }, onAddButtonTapped: {
            print("추가 페이지 이동")
        })
    }

    // 서버 데이터 요청 함수
    private func fetch(type: Int?) {
        controller.getMapMarkers(
            lat: region.center.latitude,
            lng: region.center.longitude,
            type: type
        )
    }

    // 보조 필터 버튼 디자인
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
