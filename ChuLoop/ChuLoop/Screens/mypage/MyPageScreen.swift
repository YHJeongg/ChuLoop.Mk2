//
//  MyPageScreen.swift
//  ChuLoop
//

import SwiftUI

struct MyPageScreen: View {
    let items = [
        ("하트 게시물 모아 보기", "heart.fill", Color.red),
        ("설정", "gear", Color.black),
        ("공지사항", "exclamationmark.circle.fill", Color.black),
        ("개인정보 처리방침", "doc.fill", Color.black)
    ]
    
    var body: some View {
        MyPageNavigationView(title: "My Page", content: {
            List(items, id: \.0) { item, iconName, iconColor in
                NavigationLink(destination: Text("\(item) 화면")) {
                    HStack {
                        // 아이콘 색상을 동적으로 설정
                        Image(systemName: iconName)
                            .font(.system(size: 20))
                            .foregroundColor(iconColor) // 각 항목에 맞는 아이콘 색상 설정
                        
                        Text(item)
                            .font(.system(size: 20, weight: .medium))
                            .foregroundColor(.black)
                            .padding(.leading, 10) // 텍스트와 이미지 간의 여백
                    }
                }
                .buttonStyle(PlainButtonStyle()) // 기본 NavigationLink 스타일 제거
                .padding(.vertical, 10) // 항목 간 간격
                .listRowSeparator(.hidden)
            }
            .scrollContentBackground(.hidden)
        })
    }
}

struct MyPageScreen_Previews: PreviewProvider {
    static var previews: some View {
        MyPageScreen()
    }
}

