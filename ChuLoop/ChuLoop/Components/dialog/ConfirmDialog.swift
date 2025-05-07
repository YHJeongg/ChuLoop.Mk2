//
//  ConfirmDialog.swift
//  ChuLoop
//
//  Created by Anna Kim on 3/26/25.
//

import SwiftUI

struct ConfirmDialog: View {
    let message: String
    let buttonTitle: String
    let onButtonTap: () -> Void

    var body: some View {
        VStack(spacing: ResponsiveSize.height(30)) {
            Text(message)
                .font(.bodyNormal)
                .foregroundColor(.black)
                .multilineTextAlignment(.center)
                .frame(maxWidth: .infinity)
            
            Button(action: onButtonTap) {
                Text(buttonTitle)
                    .font(.bodyMedium)
                    .frame(maxWidth: .infinity, minHeight: ResponsiveSize.height(42))
                    .background(Color.primary900)
                    .foregroundColor(.white)
                    .cornerRadius(ResponsiveSize.width(8))
            }
        }
        .padding(.horizontal, ResponsiveSize.width(34))
        .padding(.vertical, ResponsiveSize.height(30))
        .background(Color.white)
        .cornerRadius(ResponsiveSize.width(10))
        .shadow(radius: 5) // 그림자 추가 (선택)
    }
}
