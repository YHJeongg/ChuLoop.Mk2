//
//  GPlaceModel.swift
//  ChuLoop
//

import Foundation

struct Place: Identifiable, Hashable {
    let id = UUID()
    let name: String
    let category: String
    let address: String
    let latitude: Double
    let longitude: Double
}
