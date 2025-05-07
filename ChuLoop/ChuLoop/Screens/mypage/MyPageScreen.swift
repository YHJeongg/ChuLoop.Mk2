//
//  MyPageScreen.swift
//  ChuLoop
//

import SwiftUI

struct ListItem: Identifiable {
    let id = UUID() // 각 항목에 고유 ID 부여
    let title: String
    let icon: String
    let destination: AnyView // 뷰 타입을 AnyView로 래핑
}

struct MyPageScreen: View {
    @StateObject private var controller = MyPageController() // @StateObject 유지
    @Binding var showTabView: Bool  // TabView 상태를 관리하는 바인딩
    
    // ✅ computed property로 변경
    private var items: [ListItem] {
        [
            ListItem(title: "하트 게시물 모아 보기", icon: "heart", destination: AnyView(HeartScreen())),
            ListItem(title: "설정", icon: "setting", destination: AnyView(SettingsScreen(controller: controller))), // ✅ 여기서 controller 사용 가능
            ListItem(title: "공지사항", icon: "info", destination: AnyView(NoticeScreen(controller: NoticeController()))),
            ListItem(title: "개인정보 처리방침", icon: "note", destination: AnyView(PrivacyPolicyScreen()))
        ]
    }
    
    var body: some View {
        MyPageNavigationView(title: controller.userInfo.nickname, profileUrl: controller.userInfo.photos, showTabView: $showTabView, content: {
            VStack(spacing: 0) {
                Spacer().frame(height: ResponsiveSize.height(22))
                List {
                    ForEach(items) { item in
                        HStack(spacing: 0) {
                            HStack(spacing: 0) {
                                ImageView(imageName: item.icon, width: ResponsiveSize.width(30), height: ResponsiveSize.width(30))
                                Text(item.title)
                                    .font(.bodyMediumBold)
                                    .foregroundColor(.natural80)
                                    .padding(.leading, 15)
                            }
                            Spacer() // 왼쪽 HStack과 화살표 사이를 spaceBetween 정렬
                            ImageView(imageName: "arrow-right", width: ResponsiveSize.width(20), height: ResponsiveSize.width(20))
                        }
                        .padding(.vertical, ResponsiveSize.height(15))
                        .padding(.horizontal, ResponsiveSize.width(24))
                        .background(
                            NavigationLink(destination: item.destination
                                .onAppear {
                                    // 해당 페이지로 이동할 때 탭뷰 숨기기
                                    showTabView = false
                                }) {
                                    EmptyView()
                                    
                                }
                                .buttonStyle(PlainButtonStyle()) // 기본 화살표 제거
                                .opacity(0) // 터치 가능한 투명 링크
                        )
                    }
                    .background(Color.primary50)  // 여기에 배경색을 지정 (예: primary50)
                    .listRowSeparator(.hidden) // 구분선 숨기기
                    .listRowInsets(EdgeInsets()) // 기본 패딩 제거
                }
                
                .listStyle(.plain)
                .scrollContentBackground(.hidden) // List 배경 제거
                
            }
            
        })
        .onAppear {
            showTabView = true
            controller.getUserInfo();
        }
        .onDisappear {
            showTabView = false
        }
    }
}

//struct MyPageScreen_Previews: PreviewProvider {
//    static var previews: some View {
//        MyPageScreen()
//    }
//}
