//
//  ImageView.swift
//  ChuLoop
//

import SwiftUI

struct ImageView: View {
    let imageName: String
    let width: CGFloat?
    let height: CGFloat?
    
    var body: some View {
        // 확장자가 포함되어 들어올 경우를 대비해 처리
        let name = imageName.replacingOccurrences(of: ".png", with: "")
        
        // 파일 경로 탐색
        let uiImage: UIImage? = {
            if let path = Bundle.main.path(forResource: name, ofType: "png") {
                return UIImage(contentsOfFile: path)
            }
            // png가 아닐 경우 jpg 등도 시도
            if let path = Bundle.main.path(forResource: name, ofType: "jpg") {
                return UIImage(contentsOfFile: path)
            }
            return nil
        }()
        
        if let uiImage = uiImage {
            Image(uiImage: uiImage)
                .resizable()
                .scaledToFit()
                .frame(width: width ?? 16.0, height: height ?? 16.0)
        } else {
            // 파일을 못 찾았을 때 에러 로그 출력 및 대체 뷰
            let _ = print("⚠️ 파일을 찾을 수 없음: \(imageName)")
            Image(systemName: "photo")
                .resizable()
                .frame(width: width ?? 16.0, height: height ?? 16.0)
                .foregroundColor(.gray.opacity(0.3))
        }
    }
}
