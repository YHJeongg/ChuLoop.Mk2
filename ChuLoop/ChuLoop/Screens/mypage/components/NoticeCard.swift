//
//  NoticeCard.swift
//  ChuLoop
//
//  Created by Anna Kim on 3/17/25.
//

import SwiftUI

struct NoticeCard: View {
    let title: String
    let date: String
    let content: String
    @Binding var showTabView: Bool  // TabView 상태를 관리하는 바인딩
    
//    @ObservedObject var controller: NoticeController // 외부에서 주입받음
    
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: ResponsiveSize.width(5))
                .fill(Color.white) // 배경 색상
                .overlay(
                    RoundedRectangle(cornerRadius: 5)
                        .stroke(Color.natural40, lineWidth: 1) // 테두리
                        
                )
                .frame(height: ResponsiveSize.height(90)) // 높이 설정
                
                
            VStack(alignment: .leading, spacing: 0) {
                HStack(spacing: 0) {
                    Text(title)
                        .font(.bodySmallBold)
                        .foregroundColor(.natural80)
                    Spacer()
                    Text(date)
                        .font(.bodyXSmall)
                        .foregroundColor(.natural70)
                }
                Spacer()
                    .frame(height: ResponsiveSize.height(10))
                
                Text(content)
                    .font(.bodyXSmall)
                    .foregroundColor(.natural70)
                    .lineLimit(2)
            }
            .padding(.horizontal, ResponsiveSize.width(15))
            .background(Color.clear)
            .background(
                NavigationLink(destination: AnyView(NoticeDetailScreen(controller: NoticeController(), title: title, content: content, showTabView: $showTabView)
                   
                                                   )
                   ) {
                        EmptyView()
                        
                    }
                   
                    .buttonStyle(PlainButtonStyle()) // 기본 화살표 제거
                    .opacity(0) // 터치 가능한 투명 링크
            )
            
        }
        .frame(height: ResponsiveSize.height(90))
        .padding(.top, ResponsiveSize.height(24))
//        .onTapGesture {
//            NoticeController().goToNoticeDetail()
//        }

        
    }
}
