//
//  MapScreenController.swift
//  ChuLoop
//

import Foundation

class MapScreenController: ObservableObject {
    @Published var contents: [MapModel] = []
    @Published var isLoading: Bool = false
    
    private let mapService = MapService()

    @MainActor
    func getMapMarkers(lat: Double, lng: Double, radius: Double = 1000, type: Int? = nil) {
        guard !isLoading else { return }
        isLoading = true

        var queryParameters: [String: String] = [
            "centerLat": String(format: "%.6f", lat),
            "centerLng": String(format: "%.6f", lng),
            "radius": "\(Int(radius))"
        ]
        
        if let type = type {
            queryParameters["type"] = "\(type)"
        }

        Task {
            let response = await mapService.fetchMapMarkers(queryParameters: queryParameters)
            if let data = response.data {
                do {
                    let jsonData = try JSONSerialization.data(withJSONObject: data)
                    self.contents = try JSONDecoder().decode([MapModel].self, from: jsonData)
                } catch {
                    print("디코딩 에러: \(error)")
                }
            }
            self.isLoading = false
        }
    }
}
