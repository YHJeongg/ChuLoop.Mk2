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
    
    // 화면 전체 중앙에 띄울 팝업 상태 추가
    @State private var selectedPlaceForMap: WillModel? = nil

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
            showTabView: .constant(false)
        ) {
            ZStack(alignment: .bottom) {
                Map(position: $position) {
                    Marker(
                        place.name,
                        coordinate: CLLocationCoordinate2D(
                            latitude: place.latitude,
                            longitude: place.longitude
                        )
                    )
                }

                SearchRestaurantMapBottomSheet(
                    place: place,
                    googleApiKey: Bundle.main.infoDictionary?["GOOGLE_PLACE"] as? String ?? "",
                    onAddressTap: { model in
                        // 바텀시트에서 전달된 모델을 받아 팝업 표시
                        selectedPlaceForMap = model
                    },
                    onSaveSuccess: {
                        // DB 저장 성공 시 실행될 코드
                        print("부모 뷰: 저장이 성공되었습니다.")
                    }
                )
                .padding(.bottom, 12)
                
                // 중앙 커스텀 시트 (화면 정중앙 기준)
                if let selected = selectedPlaceForMap {
                    ZStack {
                        Color.black.opacity(0.3)
                            .ignoresSafeArea()
                            .onTapGesture {
                                selectedPlaceForMap = nil
                            }
                        
                        WillDirectionsSheetScreen(place: selected)
                            .frame(width: 300)
                            .background(Color.white)
                            .cornerRadius(10)
                            .shadow(color: .black.opacity(0.2), radius: 20)
                            .transition(.scale.combined(with: .opacity))
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
            .animation(.easeInOut(duration: 0.2), value: selectedPlaceForMap != nil)
        }
    }
}
