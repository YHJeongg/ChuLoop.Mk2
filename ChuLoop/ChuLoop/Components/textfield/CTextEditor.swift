//
//  CTextEditor.swift
//  ChuLoop
//
//  Created by Anna Kim on 2/1/25.
//


import SwiftUI
struct CTextEditor: View {
    let placeholder: String
    @Binding var text: String
    @Binding var textIsEmpty: Bool
    @FocusState private var textIsFocused: Bool
    let errorText: String?
    
    var body: some View {
        VStack(alignment: .leading, spacing: 5) {
            ZStack(alignment: .topLeading) {
                // 🔹 TextEditor
                TextEditor(text: $text)
                    .focused($textIsFocused)
                    .onChange(of: text) {
                        textIsEmpty = text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
                    }
                    .frame(height: 174)
                    .font(.bodyNormal)
                    .padding(15)
                    .background(Color.white)
                    .overlay(
                        RoundedRectangle(cornerRadius: 8)
                            .stroke(textIsEmpty ? .error : Color.natural60, lineWidth: 1)
                    )
                
                // 🔹 오른쪽 하단 텍스트
                VStack(alignment: .leading) {
                    // 🔹 Placeholder
                    if text.isEmpty {
                        Text(placeholder)
                            .font(.bodyNormal)
                            .foregroundColor(.natural40)
                            .padding(.horizontal, 15)
                            .padding(.top, 15)
                            .allowsHitTesting(false) // 입력 방해 안 되도록
                    }
                    Spacer()
                    HStack {
                        Spacer()
                        Text("\(text.count)/125")
                            .foregroundColor(.natural40)
                            .font(.bodySmallBold)
                            .padding(.trailing, 15)
                            .padding(.bottom, 15)
                    }
                }
            }
            
            // 🔹 에러 메시지 표시
            if textIsEmpty, let errorText = errorText {
                Text(errorText)
                    .font(.bodySmall)
                    .foregroundColor(.error)
                    .padding(.horizontal, 16)
            }
        }
    }
}
