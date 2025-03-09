//
//  MyPageNavigationView.swift
//  ChuLoop
//

import SwiftUI

struct MyPageNavigationView<Content: View>: View {
    let title: String
    let profileUrl: String
    let content: () -> Content
    
    init(title: String, profileUrl: String, @ViewBuilder content: @escaping () -> Content) {
        self.title = title
        self.profileUrl = profileUrl
        self.content = content
    }
    
    var body: some View {
        NavigationView {
            VStack(alignment: .leading, spacing: 0) {
                // navigation bar
                ZStack(alignment: .bottomLeading) {
                    Rectangle()
                        .foregroundColor(.primary300) // 원하는 배경색 설정
                        .edgesIgnoringSafeArea(.top) // ✅ 상태바까지 확장
                        .frame(height: ResponsiveSize.height(100))
                    HStack(alignment: .center, spacing: 0) {
                        if(profileUrl == "") {
                            ImageView(imageName: "fill-profile", width: ResponsiveSize.width(36), height: ResponsiveSize.width(36))
                        } else {
                            profile
                        }
                        
                        Spacer().frame(width: ResponsiveSize.width(10))
                        Text(title)
                            .font(.bodyMediumBold)
                            .foregroundColor(.natural90)
                    }
                    .padding(.leading, ResponsiveSize.width(24))
                    .padding(.bottom, ResponsiveSize.height(32))
                }
                // body
                ZStack {
                    Color.primary50
                        .ignoresSafeArea(.all)
                    content()
                }
            }
        }
        .buttonStyle(PlainButtonStyle())
    }
}

//struct MyPageNavigationView_Previews: PreviewProvider {
//    static var previews: some View {
//        MyPageNavigationView(title: "My Page", content: {
//            Text("My Page Content")
//        })
//    }
//}


private extension MyPageNavigationView {
    // 이미지 섹션
    @ViewBuilder
    var profile: some View {
        if let imageUrl = URL(string: profileUrl) {
            AsyncImage(url: imageUrl) { phase in
                switch phase {
                case .empty:
                    ProgressView()
                        .frame(width: ResponsiveSize.width(36), height: ResponsiveSize.width(36))
                case .success(let image):
                    image.resizable()
                        .scaledToFill()
                        .frame(width: ResponsiveSize.width(36), height: ResponsiveSize.width(36))
                        .clipShape(Circle())
                case .failure:
                    ImageView(imageName: "fill-profile", width: ResponsiveSize.width(36), height: ResponsiveSize.width(36))
                @unknown default:
                    ImageView(imageName: "fill-profile", width: ResponsiveSize.width(36), height: ResponsiveSize.width(36))
                }
            }
        } else {
            ImageView(imageName: "fill-profile", width: ResponsiveSize.width(36), height: ResponsiveSize.width(36))
        }
    }
}
