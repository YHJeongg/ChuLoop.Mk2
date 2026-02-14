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
                                .foregroundColor(.error)
                                .shadow(radius: 2)
                            
                            Text(item.title)
                                .font(.bodyXSmall)
                                .foregroundColor(.natural90)
                                .lineLimit(2)
                                .truncationMode(.tail)
                                .frame(maxWidth: 120)
                                .padding(.horizontal, 8)
                                .padding(.vertical, 4)
                                .background(Color.white.opacity(0.9))
                                .cornerRadius(4)
                                .shadow(radius: 1)
                        }
                        .onTapGesture {
                            print("마커 클릭 됨")
                        }
                    }
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .onAppear {
                    // 화면 진입 시 현재 지도 중심 좌표로 구글 데이터 호출
                    controller.fetchNearbyPlaces(
                        latitude: region.center.latitude,
                        longitude: region.center.longitude
                    )
                }
                
                // 전체보기 버튼
                VStack {
                    Spacer()
                    HStack {
                        Spacer()
                        Button(action: {
                            withAnimation {
                                showOptions.toggle()
                            }
                        }) {
                            Text("전체보기")
                                .font(.bodyLarge)
                                .foregroundColor(.natural80)
                                .padding(.horizontal, ResponsiveSize.width(10))
                                .padding(.vertical, ResponsiveSize.height(12))
                                .background(Color.primary50)
                                .cornerRadius(8)
                        }
                        .frame(width: ResponsiveSize.width(100), height: ResponsiveSize.height(50))
                        .padding(.bottom, ResponsiveSize.height(24))
                        .padding(.trailing, ResponsiveSize.width(24))
                    }
                }

                // 하단 옵션 버튼 (가보고 싶은 / 방문한 맛집)
                if showOptions {
                    VStack {
                        Spacer()
                        HStack {
                            Spacer()
                            VStack(alignment: .trailing, spacing: ResponsiveSize.height(10)) {
                                
                                // 가보고 싶은 맛집 버튼
                                Button(action: {
                                    print("가보고 싶은 맛집 필터링")
                                    withAnimation { showOptions = false }
                                }) {
                                    Text("가보고 싶은 맛집")
                                        .font(.bodyLarge)
                                        .foregroundColor(.natural10)
                                        .padding(.horizontal, ResponsiveSize.width(10))
                                        .padding(.vertical, ResponsiveSize.height(12))
                                        .background(Color.error)
                                        .cornerRadius(8)
                                }

                                // 방문한 맛집 버튼
                                Button(action: {
                                    print("방문한 맛집 필터링")
                                    withAnimation { showOptions = false }
                                }) {
                                    Text("방문한 맛집")
                                        .font(.bodyLarge)
                                        .foregroundColor(.natural10)
                                        .padding(.horizontal, ResponsiveSize.width(10))
                                        .padding(.vertical, ResponsiveSize.height(12))
                                        .background(Color.blue)
                                        .cornerRadius(8)
                                }
                            }
                            .padding(.bottom, ResponsiveSize.height(89))
                            .padding(.trailing, ResponsiveSize.width(24))
                        }
                    }
                    .transition(.opacity) // 메뉴 나타날 때 부드러운 효과
                }
                
                // 로딩 인디케이터
                if controller.isLoading {
                    ProgressView()
                        .padding()
                        .background(Color.white.opacity(0.8))
                        .cornerRadius(10)
                }
            }
        }, onAddButtonTapped: {
            print("새로운 맛집 검색 및 추가 페이지 이동")
        })
    }
    
    // 외부 구글 맵 연동 함수
    private func openGoogleMaps(placeId: String) {
        let urlString = "comgooglemaps://?q=google_place_id:\(placeId)"
        if let url = URL(string: urlString), UIApplication.shared.canOpenURL(url) {
            UIApplication.shared.open(url)
        } else {
            let webUrlString = "https://www.google.com/maps/search/?api=1&query=Google&query_place_id=\(placeId)"
            if let webUrl = URL(string: webUrlString) {
                UIApplication.shared.open(webUrl)
            }
        }
    }
}
