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
    @Published var date: Date = Date.now
    @Published var images: [UIImage] = []
    
    @Published var showDatePicker: Bool = false
    @Published var openPhoto: Bool = false
    
    @Published var selectedDate: String = {
        return formatDate(Date.now)
    }()
    
    @Published var rating: Int = 0
    @Published var selectedCategory: String = "한식"
    
    @Published var imageEmpty: Bool = false
    @Published var titleEmpty: Bool = false
    @Published var addressEmpty: Bool = false
    @Published var reviewEmpty: Bool = false
    @Published var dateEmpty: Bool = false
    
    func checkEmpty() -> Bool {
        if(images.isEmpty) {
            imageEmpty = true
        }
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
