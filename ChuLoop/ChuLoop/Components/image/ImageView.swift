//
//  ImageView.swift
//  ChuLoop
//
//  Created by Anna Kim on 1/30/25.
//
import SwiftUI

struct ImageView: View {
    let imageName: String
    let width: CGFloat?
    let height: CGFloat?

    init(imageName: String, width: CGFloat? = 16, height: CGFloat? = 16) {
        self.imageName = imageName
        self.width = width
        self.height = height
    }

    var body: some View {
        let imagePath = Bundle.main.path(forResource: imageName, ofType: "png")
        let uiImage = (imagePath != nil) ? UIImage(contentsOfFile: imagePath!) : nil

        if let uiImage = uiImage {
            Image(uiImage: uiImage)
                .resizable()
                .scaledToFit() // 비율 유지하면서 크기 조정
                .frame(width: width, height: height)
        } else {
            Text("Image not found")
        }
    }
}
