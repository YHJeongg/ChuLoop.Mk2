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
    @StateObject private var controller = WillScreenController()

    private let recentSearchesKey = "RecentSearches"

    var body: some View {
        SubPageNavigationView(title: "맛집 검색") {
            VStack(alignment: .leading) {
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
                            searchResults = []

                            recentSearches.insert(searchText, at: 0)
                            recentSearches = Array(NSOrderedSet(array: recentSearches)) as! [String]
                            if recentSearches.count > 10 {
                                recentSearches = Array(recentSearches.prefix(10))
                            }
                            UserDefaults.standard.set(recentSearches, forKey: recentSearchesKey)

                            controller.GooglePlace(keyword: searchText) { results in
                                self.searchResults = results
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
                        ScrollView {
                            VStack(alignment: .leading, spacing: ResponsiveSize.height(16)) {
                                ForEach(searchResults) { place in
                                    VStack(alignment: .leading, spacing: 4) {
                                        HStack {
                                            Text(place.name)
                                                .font(.bodyLargeBold)
                                                .foregroundColor(.black)
                                            Spacer()
                                            Text(place.category)
                                                .font(.bodySmall)
                                                .foregroundColor(.natural60)
                                        }

                                        HStack {
                                            Text(place.address)
                                                .font(.bodyNormal)
                                                .foregroundColor(.black)
                                            Spacer()
                                            Button(action: {
                                                UIApplication.shared.open(place.mapURL)
                                            }) {
                                                Text("지도보기")
                                                    .font(.bodySmall)
                                                    .foregroundColor(.primary900)
                                            }
                                        }
                                    }
                                    .padding(.vertical, ResponsiveSize.height(6))
                                }
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
                                    Button(action: {
                                        searchText = search
                                        isSearching = true
                                        searchResults = []

                                        controller.GooglePlace(keyword: search) { results in
                                            self.searchResults = results
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
                    searchResults = []
                }
            }
        }
    }
}
