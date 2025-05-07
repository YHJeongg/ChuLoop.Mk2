//
//  NoticeDetail.swift
//  ChuLoop
//
//  Created by Anna Kim on 4/2/25.
//

import SwiftUI



struct NoticeDetailScreen: View {
    @ObservedObject var controller: NoticeController // 외부에서 주입받음
    let title: String
    let content: String
//    @Binding var showTabView: Bool  // TabView 상태를 관리하는 바인딩
        
    
    var body: some View {
        SubPageNavigationView(title: "공지사항") {
            ZStack(alignment: .topLeading) {
                Rectangle()
                    .fill(.white)
                    .overlay(
                        RoundedRectangle(cornerRadius: ResponsiveSize.width(5))
                            .stroke(Color.natural40, lineWidth: 1) // 테두리
                    )
                ScrollView {
                    VStack(alignment: .leading, spacing: ResponsiveSize.height(15)) {
                        Text(title)
                            .font(Font.heading4)
                            .foregroundColor(.natural80)
                        Text(content)
                            .font(Font.bodyNormal)
                            .foregroundColor(.natural70)
                    }
                    .padding(.all, ResponsiveSize.width(20))
                }
                
            }
            .padding(.all, ResponsiveSize.width(24))
        }
        

        
    }
       
}
