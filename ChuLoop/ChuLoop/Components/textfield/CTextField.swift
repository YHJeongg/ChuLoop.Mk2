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
    let errorText: String?
    

    
    var body: some View {
        VStack(alignment: .leading, spacing: 5) {
            TextField(placeholder, text: $text)
                .focused($textIsFocused)
                .onChange(of: text) { oldValue, newValue in
                    if(oldValue != newValue) {
                        textIsEmpty = newValue.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
                    }
                }
                .font(.bodyNormal)
                .padding(.horizontal, 16)
                .padding(.vertical, 20)
                .background(Color.white)
                .overlay(RoundedRectangle(cornerRadius: 8).stroke(textIsEmpty ? .error : Color.natural60, lineWidth: 1))
            if(textIsEmpty && errorText != nil) {
                Text(errorText!)
                    .font(.bodySmall)
                    .foregroundColor(.error)
                    .padding(.horizontal, 16)
            }
            
        }
    }
}
