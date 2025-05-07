//
//  NoticeScreen.swift
//  ChuLoop
//

import SwiftUI



struct NoticeScreen: View {
    @ObservedObject var controller: NoticeController // 외부에서 주입받음
//    @Binding var showTabView: Bool
    
    var body: some View {
        SubPageNavigationView(title: "공지사항") {
            if(controller.notices.isEmpty) {
                VStack(alignment: .center, spacing: 0) {
                    Spacer()
                        .frame(height: ResponsiveSize.height(300))
                    ZStack(alignment: .center) {
                        Rectangle()
                            .frame(height: ResponsiveSize.height(50))
                            .foregroundColor(.clear)
                        Text("공지사항이 비어있어요. 문의사항이 있으면 cs@gmail.com으로 문의주세요")
                            .font(.bodyMedium)
                            .foregroundColor(.natural60)
                            .multilineTextAlignment(.center) // 왼쪽 정렬
                    }
                }
                
            } else {
                List {
                    ForEach(controller.notices) { notice in
                        NoticeCard(title: notice.title, date: formatStringToYYYYMMDD(notice.updatedAt == "none" ? notice.createdAt : notice.updatedAt), content: notice.content)
                    }
                    .listRowSeparator(.hidden)
                    .listRowBackground(Color.clear)
                    .listRowSpacing(0)
                    .listRowInsets(EdgeInsets())
                }
                .listStyle(PlainListStyle()) // ✅ 기본 여백 제거
                .padding(.horizontal, ResponsiveSize.width(24))
                .background(Color.clear)
                .scrollContentBackground(.hidden) // ✅ 배경 투명화 (iOS 16+)
            }
        }

        .onAppear {
            controller.getNoticeList()
        }
        
        
    }
}

//struct NoticeScreen_Previews: PreviewProvider {
//    static var previews: some View {
//        NoticeScreen()
//    }
//}
