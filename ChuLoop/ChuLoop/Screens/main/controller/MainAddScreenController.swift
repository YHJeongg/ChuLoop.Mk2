//
//  MainAddScreenController.swift
//  ChuLoop
//
//  Created by Anna Kim on 1/31/25.
//

import SwiftUI

class MainAddScreenController: ObservableObject {
    @Published var restaurantName: String = ""
    @Published var address: String = ""
    @Published var review: String = ""
    @Published var reviewSelection: TextSelection? = nil
    @Published var selectedDate = Date()
    @Published var rating: Int = 0
    @Published var selectedCategory: String = "한식"
    
    func submit() {
        print("리뷰 : \(self.review)")
        print("리뷰 2: \(self.reviewSelection)")
    }
}
