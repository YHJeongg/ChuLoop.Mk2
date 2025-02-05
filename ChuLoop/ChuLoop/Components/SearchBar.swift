//
//  SearchBar.swift
//  ChuLoop
//

import SwiftUI

struct SearchBar: View {
    @Binding var searchText: String
    
    var body: some View {
        HStack {
            // 돋보기 아이콘
            Image(systemName: "magnifyingglass")
                .foregroundColor(.natural40)
                .padding(.leading, 10)
            
            // 검색 텍스트 입력
            TextField("검색", text: $searchText)
                .font(.bodySmall)
                .padding(.vertical, 10)
                .padding(.horizontal, 15)
                .background(
                    RoundedRectangle(cornerRadius: 10)
                        .fill(Color.white)
                )
        }
        .overlay(
            RoundedRectangle(cornerRadius: 5)
                .stroke(Color.natural40, lineWidth: 0.5)
        )
        .frame(height: 40)
    }
}
