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
    
    @Published var selectedDate = Date()
    @Published var rating: Int = 0
    @Published var selectedCategory: String = "한식"
    
    @Published var titleEmpty: Bool = false
    @Published var addressEmpty: Bool = false
    @Published var reviewEmpty: Bool = false
    
    func checkEmpty() -> Bool {
        if(restaurantName.isEmpty) {
            titleEmpty = true
        }
        if(address.isEmpty) {
            addressEmpty = true
        }
        if(review.isEmpty) {
            reviewEmpty = true
        }
        return titleEmpty || addressEmpty || reviewEmpty
    }
    
    func submit() {

        if(checkEmpty()) {
            return
        }
        
        print("리뷰 : \(self.review)")
       
    }
}
