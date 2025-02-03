//
//  SearchBar.swift
//  ChuLoop
//

import SwiftUI

struct SearchBar: View {
    @Binding var searchText: String
    
    var body: some View {
        HStack {
            TextField("검색", text: $searchText)
                .font(.bodySmall)
                .padding(.vertical, 10)
                .padding(.horizontal, 15)
                .background(
                    RoundedRectangle(cornerRadius: 10)
                        .fill(Color.gray.opacity(0.1))
                )
                .overlay(
                    HStack {
                        Spacer()
                        Image(systemName: "magnifyingglass")
                            .foregroundColor(.gray)
                            .padding(.trailing, 10)
                    }
                )
        }
        .frame(height: 40)
    }
}
