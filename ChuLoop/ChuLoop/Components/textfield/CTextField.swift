//
//  CTextField.swift
//  ChuLoop
//
//  Created by Anna Kim on 2/1/25.
//

import SwiftUI

struct CTextField: View {
    let placeholder: String
    @Binding var text: String
    @Binding var textIsEmpty: Bool
    @FocusState private var textIsFocused: Bool
    let onTap: (() -> Void)?
    let readonly: Bool
    let errorText: String?
    
    
    init(placeholder: String,
         text: Binding<String>,
         textIsEmpty: Binding<Bool>,
         onTap: (() -> Void)? = nil,
         readonly: Bool = false,
         errorText: String? = nil) {
        self.placeholder = placeholder
        self._text = text
        self._textIsEmpty = textIsEmpty
        self.onTap = onTap
        self.readonly = readonly
        self.errorText = errorText
    }
    
    
    var body: some View {
        VStack(alignment: .leading, spacing: 5) {
            TextField(placeholder, text: $text)
                .focused($textIsFocused)
                .onChange(of: text) {
                    textIsEmpty = text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
                }
                .disabled(readonly)
                
        }
       
        .font(.bodyNormal)
        .padding(.horizontal, 16)
        .padding(.vertical, 20)
        .background(Color.white)
        .overlay(RoundedRectangle(cornerRadius: 8).stroke(textIsEmpty ? .error : Color.natural60, lineWidth: 1))
        .onTapGesture {
                            print("TextField tapped!")  // onTapGesture가 호출된 시점에 로그 출력
                            if let onTap = onTap {
                                onTap()  // onTap 클로저 호출
                            }
                        }
        if(textIsEmpty && errorText != nil) {
            Text(errorText!)
                .font(.bodySmall)
                .foregroundColor(.error)
                .padding(.horizontal, 16)
        }
        
    }
    
    
}
