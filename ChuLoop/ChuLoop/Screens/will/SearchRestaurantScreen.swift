//
//  SearchRestaurantScreen.swift
//  ChuLoop
//

import SwiftUI

struct SearchRestaurantScreen: View {
    @Binding var showTabView: Bool
    @State private var searchText: String = ""
    @State private var recentSearches: [String] = [] // 최근 검색 데이터를 저장할 배열
    @State private var searchResults: [String] = [] // 검색 결과를 저장할 배열
    @State private var isSearching: Bool = false // 검색 중 여부를 체크하는 변수

    var body: some View {
        SubPageNavigationView(title: "맛집 검색") {
            VStack(alignment: .leading) {
                HStack() {
                    ZStack(alignment: .trailing) {
                        TextField("검색", text: $searchText)
                            .padding(.horizontal, ResponsiveSize.width(10))
                            .frame(height: ResponsiveSize.height(45))
                            .background(Color.white)
                            .cornerRadius(5)
                            .foregroundColor(.black)
                            .font(.bodySmall)
                            .overlay(
                                RoundedRectangle(cornerRadius: 5)
                                    .stroke(Color.natural40, lineWidth: 1)
                            )
                            .multilineTextAlignment(.leading)

                        if !searchText.isEmpty {
                            Button(action: {
                                searchText = ""
                            }) {
                                Image(systemName: "xmark.circle.fill")
                                    .foregroundColor(.black)
                            }
                            .padding(.trailing, ResponsiveSize.width(10))
                            .zIndex(1)
                        }
                    }
                    .frame(width: ResponsiveSize.width(302))

                    Button(action: {
                        if !searchText.isEmpty {
                            isSearching = true
                            recentSearches.insert(searchText, at: 0)
                            // 서버에서 검색 결과를 받아오는 함수 호출 예정
                            // searchResults = ...
                        }
                    }) {
                        Text("검색")
                            .foregroundColor(.white)
                    }
                    .frame(width: ResponsiveSize.width(70), height: ResponsiveSize.height(45))
                    .background(Color.primary900)
                    .cornerRadius(8)
                }
                .frame(maxWidth: .infinity)
                .multilineTextAlignment(.center)

                Text(isSearching ? "검색 결과" : "최근 검색")
                    .font(.bodyLargeBold)
                    .foregroundColor(.black)
                    .padding(.vertical, ResponsiveSize.height(24))

                if isSearching {
                    if searchResults.isEmpty {
                        VStack {
                            Spacer()
                            Text("검색결과가 없습니다.")
                                .foregroundColor(.natural60)
                                .font(.bodyMedium)
                                .frame(maxWidth: .infinity, alignment: .center)
                            Spacer()
                        }
                        .frame(maxHeight: .infinity)
                    } else {
                        VStack(alignment: .leading) {
                            ForEach(searchResults, id: \.self) { search in
                                HStack {
                                    Image(systemName: "magnifyingglass")
                                        .foregroundColor(.black)
                                    Text(search)
                                        .font(.bodyNormal)
                                        .foregroundColor(.black)
                                }
                                .padding(.vertical, ResponsiveSize.height(10))
                            }
                        }
                    }
                } else {
                    if recentSearches.isEmpty {
                        VStack {
                            Spacer()
                            Text("검색한 내역이 없습니다.")
                                .foregroundColor(.natural60)
                                .font(.bodyMedium)
                                .frame(maxWidth: .infinity, alignment: .center)
                            Spacer()
                        }
                        .frame(maxHeight: .infinity)
                    } else {
                        VStack(alignment: .leading) {
                            ForEach(recentSearches, id: \.self) { search in
                                HStack {
                                    Image(systemName: "magnifyingglass")
                                        .foregroundColor(.black)
                                    Text(search)
                                        .font(.bodyNormal)
                                        .foregroundColor(.black)
                                }
                                .padding(.vertical, ResponsiveSize.height(10))
                            }
                        }
                    }
                }

                Spacer()
            }
            .padding(.horizontal, ResponsiveSize.width(34))
            .padding(.top)
            .navigationBarTitleDisplayMode(.inline)
            .onDisappear {
                showTabView = true
            }
            .onChange(of: searchText) { newValue in
                if newValue.isEmpty {
                    isSearching = false
                    searchResults = []
                }
            }
        }
    }
}
