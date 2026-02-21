//
//  MapModel.swift
//  ChuLoop
//

import Foundation
import CoreLocation

struct MapModel: Codable, Identifiable {
    let id: String
    let title: String
    let address: String
    let lat: Double
    let lng: Double

    var coordinate: CLLocationCoordinate2D {
        CLLocationCoordinate2D(latitude: lat, longitude: lng)
    }
}
