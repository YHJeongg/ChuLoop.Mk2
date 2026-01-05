//
//  SearchRestaurantScreen.swift
//  ChuLoop
//

import SwiftUI

struct SearchRestaurantScreen: View {
    @Binding var showTabView: Bool
    @State private var searchText: String = ""
    @State private var recentSearches: [String] = []
    @State private var searchResults: [Place] = []
    @State private var isSearching: Bool = false
    @State private var isLoading: Bool = false
    @StateObject private var controller = WillScreenController()
    
    private let recentSearchesKey = "RecentSearches"

    var body: some View {
        SubPageNavigationView(title: "맛집 검색", showTabView: $showTabView) {
            VStack(alignment: .leading) {
                // 검색창
                HStack {
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

                        if !searchText.isEmpty {
                            Button(action: {
                                searchText = ""
                            }) {
                                Image(systemName: "xmark.circle.fill")
                                    .foregroundColor(.black)
                            }
                            .padding(.trailing, ResponsiveSize.width(10))
                        }
                    }
                    .frame(width: ResponsiveSize.width(302))

                    Button(action: {
                        if !searchText.isEmpty {
                            isSearching = true
                            isLoading = true
                            searchResults = []

                            // 최근 검색어 저장
                            recentSearches.insert(searchText, at: 0)
                            recentSearches = Array(NSOrderedSet(array: recentSearches)) as! [String]
                            if recentSearches.count > 10 {
                                recentSearches = Array(recentSearches.prefix(10))
                            }
                            UserDefaults.standard.set(recentSearches, forKey: recentSearchesKey)

                            controller.GooglePlace(keyword: searchText) { results in
                                self.searchResults = results
                                self.isLoading = false
                            }
                        }
                    }) {
                        Text("검색")
                            .foregroundColor(.white)
                    }
                    .frame(width: ResponsiveSize.width(70), height: ResponsiveSize.height(45))
                    .background(Color.primary900)
                    .cornerRadius(8)
                }

                Text(isSearching ? "검색 결과" : "최근 검색")
                    .font(.bodyLargeBold)
                    .foregroundColor(.black)
                    .padding(.vertical, ResponsiveSize.height(24))

                // 검색 중일 때
                if isSearching {
                    if isLoading {
                        ZStack {
                            Color.clear

                            ProgressView()
                                .progressViewStyle(CircularProgressViewStyle())
                        }
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                    } else if searchResults.isEmpty {
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
                        // 검색 결과 리스트
                        ScrollView {
                            VStack(alignment: .leading) {
                                ForEach(searchResults) { place in
                                    VStack(alignment: .leading, spacing: 4) {
                                        HStack {
                                            Text(place.name)
                                                .font(.bodySmallBold)
                                                .foregroundColor(.black)
                                            Text(place.category)
                                                .font(.bodyXXSmall)
                                                .foregroundColor(.black)
                                                .frame(maxWidth: .infinity, alignment: .trailing)
                                        }
                                        .padding(.horizontal, ResponsiveSize.width(15))
                                        .padding(.bottom, ResponsiveSize.height(9))

                                        HStack {
                                            Text(place.address)
                                                .font(.bodyXSmall)
                                                .foregroundColor(.black)
                                                .lineLimit(nil)
                                                .fixedSize(horizontal: false, vertical: true)

                                            NavigationLink(
                                                destination: SearchRestaurantMapScreen(
                                                    place: place,
                                                    showTabView: $showTabView
                                                )
                                            ) {
                                                Text("지도보기")
                                                    .font(.bodySmall)
                                                    .foregroundColor(.primary900)
                                                    .padding(.vertical, ResponsiveSize.height(6))
                                                    .padding(.horizontal, ResponsiveSize.width(10))
                                                    .background(Color.secondary50)
                                                    .cornerRadius(8)
                                            }
                                            .frame(width: ResponsiveSize.width(70), height: ResponsiveSize.height(30))
                                            .frame(maxWidth: .infinity, alignment: .trailing)
                                        }
                                        .padding(.horizontal, ResponsiveSize.width(15))
                                    }
                                    .padding(.vertical, ResponsiveSize.height(9))
                                    .frame(width: ResponsiveSize.width(382), height: ResponsiveSize.height(90))
                                    .background(Color.white)
                                    .cornerRadius(5)
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 5)
                                            .stroke(Color.natural40, lineWidth: 1)
                                    )
                                }
                            }
                        }
                    }
                } else {
                    // 최근 검색어
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
                                    Button(action: {
                                        searchText = search
                                        isSearching = true
                                        isLoading = true
                                        searchResults = []

                                        controller.GooglePlace(keyword: search) { results in
                                            self.searchResults = results
                                            self.isLoading = false
                                        }
                                    }) {
                                        HStack {
                                            Image(systemName: "magnifyingglass")
                                                .foregroundColor(.black)
                                            Text(search)
                                                .font(.bodyNormal)
                                                .foregroundColor(.black)
                                        }
                                    }
                                    Spacer()
                                    Button(action: {
                                        if let index = recentSearches.firstIndex(of: search) {
                                            recentSearches.remove(at: index)
                                            UserDefaults.standard.set(recentSearches, forKey: recentSearchesKey)
                                        }
                                    }) {
                                        Image(systemName: "xmark")
                                            .foregroundColor(.black)
                                    }
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
            .onAppear {
                if let savedSearches = UserDefaults.standard.stringArray(forKey: recentSearchesKey) {
                    recentSearches = savedSearches
                }
            }
            .onChange(of: searchText) { newValue in
                if newValue.isEmpty {
                    isSearching = false
                    isLoading = false
                    searchResults = []
                }
            }
        }
    }
}
