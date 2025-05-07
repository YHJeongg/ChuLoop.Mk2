//
//  SubPageNavigationView.swift
//  ChuLoop
//
//  Created by Anna Kim on 3/9/25.
//


import SwiftUI

struct SubPageNavigationView<Content: View>: View {
    @Environment(\.dismiss) private var dismiss
    
    let title: String
    let content: () -> Content
//    @Binding var showTabView: Bool  // TabView 상태를 관리하는 바인딩
    
    
    init(title: String, @ViewBuilder content: @escaping () -> Content) {
        self.title = title
//        self._showTabView = showTabView
        self.content = content
        
    }
    
    var body: some View {
//        NavigationView {
            // body
            ZStack(alignment: .topLeading) {
                Color.primary50
                    .ignoresSafeArea(.all)
                content()
//                    .onAppear {
//                        // SubPageNavigationView로 들어가면 TabView 숨기기
//                        showTabView = false
//                    }
            }
//        }
        .navigationBarBackButtonHidden(true)
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            // 커스텀 뒤로가기 버튼
            ToolbarItem(placement: .topBarLeading) {
                Button(action: {
                    dismiss()
                }) {
                    ImageView(imageName: "arrow-left", width: ResponsiveSize.width(16), height: ResponsiveSize.height(22))
                }
            }
            // 타이틀
            ToolbarItem(placement: .principal) {
                Text(title)
                    .font(Font.bodyLargeBold)
                    .foregroundColor(.black)
            }
        }
        .toolbarBackground(Color.mobileGray, for: .navigationBar)
        .toolbarBackground(.visible, for: .navigationBar)
        .environmentObject(CommonController.shared)
    }
}



