//
//  ImagePicker.swift
//  ChuLoop
//
//  Created by Anna Kim on 3/11/25.
//
import UIKit
import SwiftUI

struct ImagePicker: UIViewControllerRepresentable {
    
    var sourceType: UIImagePickerController.SourceType = .photoLibrary
    
    @Binding var selectedImage: UIImage
    @Binding var selectedData: Data
    var uploadImage: () async -> Void
    
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
                parent.selectedImage = image
            }
            if let image = info[.editedImage] as? UIImage {
                parent.selectedData = image.jpegData(compressionQuality: 0.8)!  // JPEG로 변환하여 저장
            } else if let image = info[.originalImage] as? UIImage {
                parent.selectedData = image.jpegData(compressionQuality: 0.8)!
            }
            // ✅ 이미지 선택 후 API 실행 (여기에 네트워크 요청 추가)
            Task {
                await parent.uploadImage()
            }
            
            parent.presentationMode.wrappedValue.dismiss()
        }
    }
}
