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
    let type: Int? // 0: 방문한 맛집, 1: 가보고 싶은 맛집

    var coordinate: CLLocationCoordinate2D {
        CLLocationCoordinate2D(latitude: lat, longitude: lng)
    }
}
