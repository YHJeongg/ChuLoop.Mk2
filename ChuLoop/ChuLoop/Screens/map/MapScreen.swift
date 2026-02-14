//
//  MapScreen.swift
//  ChuLoop
//

import SwiftUI
import MapKit

struct Restaurant: Identifiable {
    let id = UUID()
    let name: String
    let coordinate: CLLocationCoordinate2D
}

struct MapScreen: View {
    @State private var region = MKCoordinateRegion(
        center: CLLocationCoordinate2D(latitude: 37.5665, longitude: 126.9780),
        span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
    )
    
    @State private var restaurants = [
        Restaurant(name: "최대가게이름 이열글자", coordinate: CLLocationCoordinate2D(latitude: 37.5700, longitude: 126.9820)),
        Restaurant(name: "만다린", coordinate: CLLocationCoordinate2D(latitude: 37.5650, longitude: 126.9750)),
        Restaurant(name: "모수", coordinate: CLLocationCoordinate2D(latitude: 37.5610, longitude: 126.9800)),
        Restaurant(name: "공화춘", coordinate: CLLocationCoordinate2D(latitude: 37.5600, longitude: 126.9850)),
        Restaurant(name: "용용선생", coordinate: CLLocationCoordinate2D(latitude: 37.5680, longitude: 126.9890)),
    ]
    
    @State private var showOptions = false
    
    @Binding var showTabView: Bool  // TabView 상태를 관리하는 바인딩


    var body: some View {
        MainNavigationView(title: "맛집지도", showTabView: $showTabView, content: {
            ZStack {
                Map(coordinateRegion: $region, showsUserLocation: true, annotationItems: restaurants) { restaurant in
                    MapAnnotation(coordinate: restaurant.coordinate) {
                        VStack {
                            Image(systemName: "mappin.circle.fill")
                                .foregroundColor(.red)
                                .font(.title)
                            Text(restaurant.name)
                                .font(.bodyNormal)
                                .foregroundColor(.black)
                        }
                    }
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                
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

                if showOptions {
                    VStack {
                        Spacer()
                        HStack {
                            Spacer()
                            VStack(alignment: .trailing, spacing: ResponsiveSize.height(10)) {
                                
                                // 가보고 싶은 맛집 버튼
                                Button(action: {
                                    print("가보고 싶은 맛집")
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
                                    print("방문한 맛집")
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
                }
            }
        }, onAddButtonTapped: {
            print("NavigationView Button Test")
        })
    }
}
