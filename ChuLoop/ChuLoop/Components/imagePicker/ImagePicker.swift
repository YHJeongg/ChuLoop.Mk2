//
//  ImagePicker.swift
//  ChuLoop
//
//  Created by Anna Kim on 2/2/25.
//
import UIKit
import SwiftUI

struct ImagePicker: UIViewControllerRepresentable {
    
    var sourceType: UIImagePickerController.SourceType = .photoLibrary
    
    @Binding var selectedImage: [UIImage]
    @Binding var selectedData: [Data]
    @Environment(\.presentationMode) private var presentationMode
    
    func makeUIViewController(context: UIViewControllerRepresentableContext<ImagePicker>) -> UIImagePickerController {
        
        let imagePicker = UIImagePickerController()
        imagePicker.allowsEditing = false
        imagePicker.sourceType = sourceType
        imagePicker.delegate = context.coordinator
        
        return imagePicker
    }
    
    func updateUIViewController(_ uiViewController: UIImagePickerController, context: UIViewControllerRepresentableContext<ImagePicker>) {
        
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    final class Coordinator: NSObject, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
        
        var parent: ImagePicker
        
        init(_ parent: ImagePicker) {
            self.parent = parent
        }
        
        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            
            if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
                parent.selectedImage.append(image)
            }
            if let image = info[.editedImage] as? UIImage {
                parent.selectedData.append(image.jpegData(compressionQuality: 0.8)!)  // JPEG로 변환하여 저장
            } else if let image = info[.originalImage] as? UIImage {
                parent.selectedData.append(image.jpegData(compressionQuality: 0.8)!)
            }
            
            
            parent.presentationMode.wrappedValue.dismiss()
        }
    }
}
