//
//  MainScreen.swift
//  ChuLoop
//

import SwiftUI

struct TimelineItem: Identifiable {
    let id = UUID()
    let image: String
    let title: String
    let location: String
    let date: String
    let rating: Double
    var isShared: Bool
}

struct MainScreen: View {
    @State private var searchText: String = "" // 검색어 상태
    @State private var showSheet: Bool = false
    @State private var isAddButtonTapped: Bool = false
    @State private var items: [TimelineItem] = [
        TimelineItem(
            image: "MainTest",
            title: "가게이름은10글자까지...",
            location: "인천광역시 마포구 가좌동 만와 20길 1층",
            date: "2025.01.03 (수)",
            rating: 4.5,
            isShared: false
        ),
        TimelineItem(
            image: "MainTest",
            title: "맛집이름도 길게 설정 가능",
            location: "서울특별시 강남구 역삼동 123번지",
            date: "2025.01.02 (화)",
            rating: 4.8,
            isShared: true
        )
    ]
    
    var body: some View {
        MainNavigationView(title: "타임라인") {
            VStack {
                // 검색바 추가
                SearchBar(searchText: $searchText)
                    .padding(.horizontal)
                    .padding(.top)
                
                if items.isEmpty {
                    VStack {
                        Spacer()
                        
                        Text("타임라인이 비어있어요\n방문했던 맛집을 추가해 주세요")
                            .font(.title2)
                            .foregroundColor(.gray)
                            .multilineTextAlignment(.center)
                            .padding()
                        
                        Spacer()
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                } else {
                    ScrollView {
                        VStack(spacing: 20) {
                            ForEach($items) { $item in
                                TimelineCard(item: $item, showSheet: $showSheet)
                            }
                        }
                        .padding()
                    }
                }
            }
            .sheet(isPresented: $showSheet) {
                MainSheetScreen()
            }
        } onAddButtonTapped: {
            isAddButtonTapped = true
        }
        NavigationLink(value: isAddButtonTapped) {
            EmptyView()
        }
        .navigationDestination(for: Bool.self) { _ in
            MainAddScreen() // 상태가 true일 때 MainAddScreen으로 이동
        }
        .navigationTitle("타임라인")
    }
}

struct TimelineCard: View {
    @Binding var item: TimelineItem
    @Binding var showSheet: Bool
    
    var body: some View {
        VStack(alignment: .leading) {
            Image(item.image)
                .resizable()
                .scaledToFill()
                .frame(height: 200)
                .clipped()
                .cornerRadius(10)
                .onTapGesture {
                    showSheet.toggle()
                }
            
            VStack(alignment: .leading, spacing: 10) {
                Text(item.title)
                    .font(.headline)
                    .lineLimit(1)
                
                Text(item.location)
                    .font(.subheadline)
                    .foregroundColor(.gray)
                
                HStack {
                    Text("\(item.date)")
                        .font(.caption)
                        .foregroundColor(.gray)
                    
                    Spacer()
                    
                    HStack(spacing: 4) {
                        Image(systemName: "star.fill")
                            .foregroundColor(.red)
                            .font(.caption)
                        
                        Text(String(format: "%.1f", item.rating))
                            .font(.caption)
                    }
                }
                
                HStack {
                    Text("커뮤니티에 공유하기")
                        .font(.caption)
                        .foregroundColor(.gray)
                    
                    Spacer()
                    
                    Toggle("", isOn: $item.isShared)
                        .labelsHidden()
                }
            }
            .padding()
        }
        .background(Color.white)
        .cornerRadius(15)
        .shadow(color: Color.gray.opacity(0.2), radius: 5, x: 0, y: 2)
    }
}

struct SearchBar: View {
    @Binding var searchText: String
    
    var body: some View {
        HStack {
            TextField("검색", text: $searchText)
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

struct MainScreen_Previews: PreviewProvider {
    static var previews: some View {
        MainScreen()
    }
}
