//
//  SocialLoginButton.swift
//  ChuLoop
//

import SwiftUI

struct SocialLoginButton: View {
    var title: String          // 버튼에 표시할 텍스트
    var backgroundColor: Color // 버튼 배경색
    var borderColor: Color? = nil // 버튼 테두리 색 (옵션)
    var iconName: String       // 아이콘 이름 (systemName)
    var textColor: Color       // 텍스트 및 아이콘 색상
    var action: () -> Void     // 버튼 클릭 시 실행할 동작
    
    var body: some View {
        Button(action: action) {
            ZStack {
                if let borderColor = borderColor {
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(borderColor, lineWidth: 1)
                        .background(
                            RoundedRectangle(cornerRadius: 10)
                                .fill(backgroundColor)
                        )
                } else {
                    RoundedRectangle(cornerRadius: 10)
                        .fill(backgroundColor)
                }
                HStack {
                    Image(systemName: iconName)
                        .foregroundColor(textColor)
                        .padding(.leading, 0)

                    Text(title)
                        .font(.bodyNormal)
                        .foregroundColor(textColor)
                        .frame(maxWidth: .infinity)
                        .multilineTextAlignment(.center) // 텍스트 중앙 정렬
                }
                .padding()
            }
            .frame(height: 50) // 버튼 높이 설정
        }
    }
}
