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
                .padding(.leading, ResponsiveSize.width(0.023))

            // 검색 텍스트 입력
            TextField("검색", text: $searchText)
                .font(.bodySmall)
                .frame(
                    width: ResponsiveSize.width(0.7),
                    height: ResponsiveSize.height(0.048)
                )
                .background(
                    RoundedRectangle(cornerRadius: 10)
                        .fill(Color.white)
                )
            Spacer()
        }
        .overlay(
            RoundedRectangle(cornerRadius: 5)
                .stroke(Color.natural40, lineWidth: 0.5)
        )
        .padding(.horizontal, ResponsiveSize.width(0.056))
//        .padding(.vertical, ResponsiveSize.height(0.035))
        .padding(.top, ResponsiveSize.height(0.035))
    }
}
