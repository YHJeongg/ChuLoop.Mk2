//
//  SearchRestaurantMapScreen.swift
//  ChuLoop
//

import SwiftUI
import MapKit

struct SearchRestaurantMapScreen: View {
    let place: Place
    @Binding var showTabView: Bool

    @State private var position: MapCameraPosition

    init(place: Place, showTabView: Binding<Bool>) {
        self.place = place
        self._showTabView = showTabView
        self._position = State(
            initialValue: .region(
                MKCoordinateRegion(
                    center: CLLocationCoordinate2D(
                        latitude: place.latitude,
                        longitude: place.longitude
                    ),
                    span: MKCoordinateSpan(
                        latitudeDelta: 0.005,
                        longitudeDelta: 0.005
                    )
                )
            )
        )
    }

    var body: some View {
        SubPageNavigationView(
            title: "맛집 검색",
            showTabView: $showTabView
        ) {
            Map(position: $position) {
                Marker(
                    place.name,
                    coordinate: CLLocationCoordinate2D(
                        latitude: place.latitude,
                        longitude: place.longitude
                    )
                )
                .tint(.red)
            }
            .ignoresSafeArea(edges: .bottom)
            .navigationBarTitleDisplayMode(.inline)
            .onAppear {
                showTabView = false
            }
        }
    }
}
