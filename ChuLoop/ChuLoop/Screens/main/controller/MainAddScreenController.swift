//
//  MainAddScreenController.swift
//  ChuLoop
//
//  Created by Anna Kim on 1/31/25.
//

import SwiftUI

class MainAddScreenController: ObservableObject {
    var mainService = MainService()
    
    @Published var restaurantName: String = ""
    @Published var address: String = ""
    @Published var review: String = ""
    @Published var date: Date = Date.now
    @Published var images: [UIImage] = []
    @Published var selectedData: [Data] = []
    
    @Published var showDatePicker: Bool = false
    @Published var openPhoto: Bool = false
    
    @Published var selectedDate: String = {
        return formatdotYYYYMMDDEEE(Date.now)
    }()
    
    @Published var rating: Int = 0
    @Published var selectedCategory: String = "한식"
    
    @Published var imageEmpty: Bool = false
    @Published var titleEmpty: Bool = false
    @Published var addressEmpty: Bool = false
    @Published var reviewEmpty: Bool = false
    @Published var dateEmpty: Bool = false
    
    var selectedImageUrl: [String] = []
    
    func validateEmpty() -> Bool {
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
    
    func submit(mainController: MainScreenController) {
        // 모두 입력했는지 확인
        if(validateEmpty()) {
            return
        }
        // 저장 API
        postEdPostImage(mainController: mainController)
    }
    
    func postEdPostImage(mainController: MainScreenController) {
        Task {
            for imageData in selectedData {
                if let imageUrl = await CommonController.shared.uploadImageToServer(endpoint: ApisV1.edPostImage.rawValue, imageData: imageData) {
                    selectedImageUrl.append(imageUrl)
                } else {
                    print("Failed to upload image")
                }
            }

            if !selectedImageUrl.isEmpty {
                postEdPost(mainController: mainController)
            }
        }
    }
    
    
    func postEdPost(mainController: MainScreenController) {
        Task {
            let requestData = EdPostRequestModel(
                title: restaurantName,
                category: selectedCategory,
                address: address,
                date: formatdotYYYYMMDD(date),
                images: selectedImageUrl,
                description: review,
                rating: rating
            )
            
            let result = await mainService.postEdPost(data: requestData)
            if(result.success) {
                await mainController.goBack()
            } else {
                print(result.message ?? "")
            }
        }
    }
    
}
