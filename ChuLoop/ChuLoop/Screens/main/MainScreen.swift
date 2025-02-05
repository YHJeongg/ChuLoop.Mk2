//
//  MainScreen.swift
//  ChuLoop
//

import SwiftUI

struct MainScreen: View {
    @StateObject private var controller = MainScreenController()
    @State private var searchText: String = "" // 검색어 상태
    @State private var showSheet: Bool = false
    
    var body: some View {
        MainNavigationView(title: "타임라인", content: {
            VStack {
                // Search bar
                SearchBar(searchText: $searchText)
                    .padding(.horizontal)
                    .padding(.top)
                
                if controller.isLoading {
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle())
                        .padding()
                } else if controller.contents.isEmpty {
                    VStack {
                        Spacer()
                        Text("타임라인이 비어있어요\n")
                            .foregroundColor(.natural60) +
                        Text("맛집을 추가")
                            .foregroundColor(.blue)
                            .underline() +
                        Text("해 주세요")
                            .foregroundColor(.natural60)
                        
                        Spacer()
                    }
                    .font(.bodyMedium)
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .multilineTextAlignment(.center)
                    .padding()
                } else {
                    ScrollView {
                        VStack(spacing: 20) {
                            ForEach($controller.contents) { $item in
                                TimelineCard(item: $item, showSheet: $showSheet)
                            }
                        }
                        .padding()
                    }
                }
            }
            .navigationDestination(isPresented: $controller.isNavigatingToAddScreen, destination: {MainAddScreen(mainController: controller)})
            .onAppear {
                controller.fetchTimelineData()  // 데이터를 fetch
            }
        }, onAddButtonTapped: {
            controller.goToAddScreen()
        })
        
        
    }
}

struct MainScreen_Previews: PreviewProvider {
    static var previews: some View {
        MainScreen()
    }
}
