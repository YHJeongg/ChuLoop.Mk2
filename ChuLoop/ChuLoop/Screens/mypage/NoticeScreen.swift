//
//  NoticeScreen.swift
//  ChuLoop
//

import SwiftUI

struct NoticeItem: Identifiable {
    let id = UUID()
    let title: String
    let date: String
    let content: String
}

struct NoticeScreen: View {
    let notices: [NoticeItem] = [
        NoticeItem(
            title: "공지사항입니다",
            date: "2025.01.03",
            content: "조부오아서 아둘 손어훓코흐는 민딘에 픡아는 런어 센나가. 기기셈가낭 장가개절너 미신가포고 개논페쯔 조으유맙주를 뇨린이고 쳐렌헤 가랞장"
        ),
        NoticeItem(
            title: "업데이트 안내",
            date: "2025.01.02",
            content: "최신 업데이트가 적용되었습니다. 새로운 기능과 버그 수정 내용을 확인하세요."
        )
    ]
    
    var body: some View {
        List(notices) { notice in
            VStack(alignment: .leading, spacing: 10) {
                HStack {
                    Text(notice.title)
                        .font(.bodySmallBold)
                    Spacer()
                    Text(notice.date)
                        .font(.bodyXSmall)
                        .foregroundColor(.gray)
                }
                Text(notice.content)
                    .font(.bodyXSmall)
                    .foregroundColor(.black)
                    .lineLimit(2)
            }
            .padding()
            .background(
                RoundedRectangle(cornerRadius: 10)
                    .stroke(Color.gray, lineWidth: 1)
            )
            .padding(.vertical, 5)
        }
        .listStyle(PlainListStyle()) // 기본 스타일 제거
        .listRowSeparator(.hidden)
        .navigationTitle("공지사항")
    }
}

struct NoticeScreen_Previews: PreviewProvider {
    static var previews: some View {
        NoticeScreen()
    }
}
