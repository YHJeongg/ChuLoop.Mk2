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
    
    var body: some View {
        let imagePath = Bundle.main.path(forResource: String(imageName), ofType: "png")
        let uiImage = (imagePath != nil) ? UIImage(contentsOfFile: imagePath!) : nil
        
        if let uiImage = uiImage {
            Image(uiImage: uiImage)
                .resizable()
                .frame(width: CGFloat(width ?? 16.0), height: CGFloat(height ?? 16.0))
        } else {
            Text("Image not found")
        }
    }
}
