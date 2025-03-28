//
//  SearchBar.swift
//  ChuLoop
//

import SwiftUI

struct SearchBar: View {
    @Binding var searchText: String
    var onSearch: ((String) -> Void)? // 검색 결과를 처리하는 클로저 추가

    var body: some View {
        HStack(spacing: 0) {
            // 돋보기 아이콘
            Image(systemName: "magnifyingglass")
                .foregroundColor(.natural40)
                .padding(.leading, ResponsiveSize.width(10))

            // 검색 텍스트 입력
            TextField("검색", text: $searchText)
                .font(.bodySmall)
                .background(Color.white)
                .padding(.leading, ResponsiveSize.width(15))
                .padding(.trailing, ResponsiveSize.width(10))
                .padding(.vertical, ResponsiveSize.height(15))
                .onChange(of: searchText) { newValue in
                    // 검색어가 변경될 때마다 서버 요청
                    onSearch?(newValue)
                }
                

           
        }
        .frame(height: ResponsiveSize.height(45))
        .overlay(
            RoundedRectangle(cornerRadius: 5)
                .stroke(Color.natural40, lineWidth: 1)
                
        )
        .padding(.horizontal, ResponsiveSize.width(24))
    }
}
