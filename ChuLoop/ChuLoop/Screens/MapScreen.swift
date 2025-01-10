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

    var body: some View {
        MainNavigationView(title: "맛집지도") {
            ZStack {
                Map(coordinateRegion: $region, showsUserLocation: true, annotationItems: restaurants) { restaurant in
                    MapAnnotation(coordinate: restaurant.coordinate) {
                        VStack {
                            Image(systemName: "mappin.circle.fill")
                                .foregroundColor(.red)
                                .font(.title)
                            Text(restaurant.name)
                                .font(.Cookie12)
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
                                .font(.Cookie16)
                                .padding()
                                .background(Color.white)
                                .foregroundColor(.black)
                                .cornerRadius(8)
                        }
                        .padding(.bottom)
                        .padding(.trailing)
                    }
                }

                if showOptions {
                    VStack {
                        Spacer()
                        HStack {
                            Spacer()
                            VStack(alignment: .trailing, spacing: 10) {
                                Button(action: {
                                    print("가보고 싶은 맛집")
                                }) {
                                    Text("가보고 싶은 맛집")
                                        .font(.Cookie16)
                                        .padding()
                                        .background(Color.red)
                                        .foregroundColor(.white)
                                        .cornerRadius(8)
                                }
                                Button(action: {
                                    print("방문한 맛집")
                                }) {
                                    Text("방문한 맛집")
                                        .font(.Cookie16)
                                        .padding()
                                        .background(Color.blue)
                                        .foregroundColor(.white)
                                        .cornerRadius(8)
                                }
                            }
                            .padding(.trailing)
                            .padding(.bottom, 70)
                        }
                    }
                }
            }
        } onAddButtonTapped: {
            print("NavigationView Button Test")
        }
    }
}

struct MapScreen_Previews: PreviewProvider {
    static var previews: some View {
        MapScreen()
    }
}
