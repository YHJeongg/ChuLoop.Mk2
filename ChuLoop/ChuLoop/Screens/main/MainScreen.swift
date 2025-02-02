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
    @StateObject private var controller = MainScreenController() // Controller 인스턴스
    @State private var isSecondPage: Bool = false
    
    @State private var searchText: String = "" // 검색어 상태
    @State private var showSheet: Bool = false
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
        
       
            MainNavigationView(title: "타임라인",
                               content: {
                VStack {
                    // Search bar
                    SearchBar(searchText: $searchText)
                        .padding(.horizontal)
                        .padding(.top)
                    
                    if items.isEmpty {
                        // Empty state UI
                        VStack {
                            Spacer()
                            
                            Text("타임라인이 비어있어요\n방문했던 맛집을 추가해 주세요")
                                .font(.bodyMedium)
                                .foregroundColor(.gray)
                                .multilineTextAlignment(.center)
                                .padding()
                            
                            Spacer()
                        }
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                    } else {
                        // Display list of timeline items
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
                .navigationDestination(isPresented: $controller.isNavigatingToAddScreen) {
                    MainAddScreen(mainController: controller)
                    
                }
                .sheet(isPresented: $showSheet) {
                    MainSheetScreen()
                        .clearModalBackground()
                        .presentationDragIndicator(.visible)
                        .presentationCornerRadius(25)
                }
                
                
            }, onAddButtonTapped: {
                controller.goToAddScreen()
            }
                                                              , isSecondPage: $controller.isNavigatingToAddScreen, secondPage: {
                                               MainAddScreen(mainController: controller) // ✅ 기존 컨트롤러를 전달 (뒤로가기용)
                                           }
            )
       
           
        
        
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
                    .font(.bodyMediumBold)
                    .lineLimit(1)
                
                Text(item.location)
                    .font(.bodyXSmall)
                    .foregroundColor(.gray)
                
                HStack {
                    Text("\(item.date)")
                        .font(.bodySmall)
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
                        .font(.bodySmall)
                        .foregroundColor(.black)
                    
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

struct MainScreen_Previews: PreviewProvider {
    static var previews: some View {
        MainScreen()
    }
}
