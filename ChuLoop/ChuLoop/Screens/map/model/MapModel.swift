//
//  MapModel.swift
//  ChuLoop
//

import Foundation
import CoreLocation

struct MapModel: Codable, Identifiable {
    var id: String { placeId }
    let placeId: String
    let title: String
    let address: String
    let lat: Double
    let lan: Double

    var coordinate: CLLocationCoordinate2D {
        CLLocationCoordinate2D(latitude: lat, longitude: lan)
    }
}
