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
                // ✅ controller.contents 연동
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
                                .lineLimit(1)           // ✅ 최대 10글자 대응 (1줄 제한)
                                .truncationMode(.tail)  // ✅ 길면 ... 처리
                                .frame(maxWidth: 100)   // ✅ 10글자 너비에 맞춤
                                .padding(.horizontal, 8)
                                .padding(.vertical, 4)
                                .background(Color.white.opacity(0.9))
                                .cornerRadius(4)
                                .shadow(radius: 1)
                        }
                        .onTapGesture {
                            print("마커 클릭 됨: \(item.title)")
                        }
                    }
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .onAppear {
                    // ✅ GET 요청: 현재 지도 중심 좌표 전송
                    controller.getMapMarkers(
                        lat: region.center.latitude,
                        lng: region.center.longitude
                    )
                }
                
                // --- 전체보기 버튼 ---
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

                // --- 하단 옵션 버튼 (기존 필터링 용도 유지) ---
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
                    .transition(.opacity)
                }

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
}
