//
//  MapScreen.swift
//  ChuLoop
//

import SwiftUI
import MapKit

struct MapScreen: View {
    // 지도에서 사용할 위치 데이터
    @State private var region = MKCoordinateRegion(
        center: CLLocationCoordinate2D(latitude: 37.7749, longitude: -122.4194),
        span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05) // 줌 레벨
    )
    
    var body: some View {
        MainNavigationView(title: "맛집지도") {
            ZStack {
                // 지도 뷰가 화면 전체를 차지하도록 설정
                Map(coordinateRegion: $region)
                    .frame(maxWidth: .infinity, maxHeight: .infinity) // 화면 크기에 맞게 확장
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
