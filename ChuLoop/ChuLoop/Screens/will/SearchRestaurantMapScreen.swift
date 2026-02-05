//
//  SearchRestaurantMapScreen.swift
//  ChuLoop
//

import SwiftUI
import MapKit

struct SearchRestaurantMapScreen: View {
    let place: Place
    @Binding var showTabView: Bool
    @Binding var isShowingSearchScreen: Bool

    @State private var position: MapCameraPosition
    @State private var selectedPlaceForMap: WillModel? = nil

    init(place: Place, showTabView: Binding<Bool>, isShowingSearchScreen: Binding<Bool>) {
        self.place = place
        self._showTabView = showTabView
        self._isShowingSearchScreen = isShowingSearchScreen
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
        SubPageNavigationView(title: "맛집 검색", showTabView: .constant(false)) {
            ZStack(alignment: .bottom) {
                // 지도 영역
                Map(position: $position) {
                    Marker(place.name,
                           coordinate: CLLocationCoordinate2D(
                               latitude: place.latitude,
                               longitude: place.longitude
                           ))
                }

                // 하단 장소 정보 카드
                SearchRestaurantMapBottomSheet(
                    place: place,
                    googleApiKey: Bundle.main.infoDictionary?["GOOGLE_PLACE"] as? String ?? "",
                    onAddressTap: { model in
                        withAnimation(.easeInOut(duration: 0.2)) {
                            self.selectedPlaceForMap = model
                        }
                    },
                    onSaveSuccess: {
                        self.isShowingSearchScreen = false
                    }
                )
                .padding(.bottom, 12)

                // 커스텀 중앙 팝업
                if let selected = selectedPlaceForMap {
                    ZStack {
                        // 배경 어둡게
                        Color.black.opacity(0.3)
                            .ignoresSafeArea()
                            .onTapGesture {
                                withAnimation(.easeInOut(duration: 0.2)) {
                                    selectedPlaceForMap = nil
                                }
                            }

                        MapDirectionSheet(
                            title: selected.title,
                            address: selected.address,
                            onCopy: {
                                withAnimation(.easeInOut(duration: 0.2)) {
                                    selectedPlaceForMap = nil
                                }
                            }
                        )
                        .frame(width: 300)
                        .background(Color.white)
                        .cornerRadius(10)
                        .shadow(color: .black.opacity(0.2), radius: 20)
                        .transition(.scale.combined(with: .opacity))
                        .zIndex(1)
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .zIndex(1000)
                }
            }
            .onAppear {
                showTabView = false
            }
            .ignoresSafeArea(edges: .bottom)
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}
