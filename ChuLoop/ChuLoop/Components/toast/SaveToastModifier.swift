//
//  SaveToastModifier.swift
//  ChuLoop
//

import SwiftUI

struct SaveToastModifier: ViewModifier {
    @Binding var isShowing: Bool
    var message: String // 메시지를 가변적으로 받음

    func body(content: Content) -> some View {
        ZStack {
            content // 메인 화면
            
            if isShowing {
                VStack {
                    HStack(spacing: 0) {
                        Image(systemName: "info.circle")
                            .font(.system(size: 24))
                            .foregroundColor(.primary500)
                            .padding(.horizontal, ResponsiveSize.width(15))

                        Text(message)
                            .font(.bodyNormal)
                            .foregroundColor(.natural80)
                        
                        Spacer()
                    }
                    .frame(width: ResponsiveSize.width(362), height: ResponsiveSize.height(60))
                    .background(Color.white)
                    .overlay(
                        RoundedRectangle(cornerRadius: 45)
                            .stroke(Color.primary500, lineWidth: 1)
                    )
                    .cornerRadius(45)
                    .shadow(color: Color.black.opacity(0.1), radius: 6, y: 4)
                    
                    Spacer()
                }
                .padding(.top, ResponsiveSize.height(10))
                .transition(.move(edge: .top).combined(with: .opacity))
                .zIndex(1000)
                .onAppear {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                        withAnimation {
                            isShowing = false
                        }
                    }
                }
            }
        }
    }
}

extension View {
    func showSaveToast(isShowing: Binding<Bool>, message: String) -> some View {
        self.modifier(SaveToastModifier(isShowing: isShowing, message: message))
    }
}
