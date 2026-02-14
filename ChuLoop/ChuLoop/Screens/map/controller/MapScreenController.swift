//
//  MapScreenController.swift
//  ChuLoop
//

import Foundation
import Combine
import CoreLocation

class MapScreenController: ObservableObject {
    @Published var contents: [MapModel] = []
    @Published var isLoading: Bool = false
    
    private var cancellables = Set<AnyCancellable>()

    // Google Places API를 통해 주변 맛집 검색
    @MainActor
    func fetchNearbyPlaces(latitude: Double, longitude: Double) {
        guard !isLoading else { return }
        
        guard let apiKey = Bundle.main.infoDictionary?["GOOGLE_PLACE"] as? String else {
            print("API Key가 없습니다.")
            return
        }

        isLoading = true
        let urlStr = "https://maps.googleapis.com/maps/api/place/nearbysearch/json" +
                     "?location=\(latitude),\(longitude)" +
                     "&radius=1000" +
                     "&type=restaurant" +
                     "&key=\(apiKey)"

        guard let url = URL(string: urlStr) else {
            self.isLoading = false
            return
        }

        Task {
            do {
                let (data, _) = try await URLSession.shared.data(from: url)
                let json = try JSONSerialization.jsonObject(with: data) as? [String: Any]
                let results = json?["results"] as? [[String: Any]] ?? []

                let fetchedPlaces: [MapModel] = results.compactMap { result in
                    guard
                        let placeId = result["place_id"] as? String,
                        let name = result["name"] as? String,
                        let address = result["vicinity"] as? String,
                        let geometry = result["geometry"] as? [String: Any],
                        let location = geometry["location"] as? [String: Any],
                        let lat = location["lat"] as? Double,
                        let lng = location["lng"] as? Double
                    else {
                        return nil
                    }

                    return MapModel(
                        placeId: placeId,
                        title: name,
                        address: address,
                        lat: lat,
                        lan: lng
                    )
                }

                self.contents = fetchedPlaces
                self.isLoading = false
                
            } catch {
                print("Google Places API 호출 실패: \(error)")
                self.isLoading = false
            }
        }
    }
}
