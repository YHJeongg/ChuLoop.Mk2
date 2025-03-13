//
//  SettingsScreen.swift
//  ChuLoop
//

import SwiftUI

struct SettingsScreen: View {
    @EnvironmentObject var commonController: CommonController  // ✅ 환경 객체 가져오기

    @ObservedObject var controller: MyPageController // 외부에서 주입받음
    @EnvironmentObject var appState: AppState // 전역 상태 객체
    
    var body: some View {
        SubPageNavigationView(title: "설정") {
            VStack(alignment: .leading, spacing: 0) {
                Spacer().frame(height: ResponsiveSize.height(35))
                // 상단 사용자 정보 섹션
                HStack(spacing: 0) {
                    profile
                        .onTapGesture {
                            // 이미지 업로드 로직
                            controller.openPhoto.toggle()
                        }
                    Spacer().frame(width: ResponsiveSize.width(21))
                    TextField("닉네임", text: $controller.userInfo.nickname)
                        .font(.bodyNormal)
                        .background(Color.white)
                        .padding(.horizontal, 15)
                        .overlay(RoundedRectangle(cornerRadius: 8)
                            .stroke(Color.natural60, lineWidth: 1)
                            .frame(height: ResponsiveSize.height(50)))
                    Spacer().frame(width: ResponsiveSize.width(15))
                    Button(action: {
                        print("이름 변경 버튼 클릭됨")
                        controller.changeNickname()
                    }) {
                        Text("변경")
                            .font(.bodyNormal)
                            .foregroundColor(.white)
                            .frame(width: ResponsiveSize.width(70), height: ResponsiveSize.height(50))
                    }
                    .buttonStyle(PlainButtonStyle()) // 스타일 적용
                    .background(Color.blue) // 버튼 전체 배경 지정
                    .cornerRadius(8)
                }
                .padding(.horizontal, ResponsiveSize.width(24))
                Spacer().frame(height: ResponsiveSize.height(30))
                HStack(spacing: 0) {
                    Text("이메일")
                        .font(.bodyNormal)
                        .foregroundColor(.natural80)
                    Spacer()
                    Text(controller.userInfo.email)
                        .font(.bodyNormal)
                        .foregroundColor(.natural80)
                }
                .padding(.vertical, 30)
                .padding(.horizontal, 24)
                Rectangle()
                    .fill(Color.natural20) // 구분선 색상 조정)
                    .frame(height: ResponsiveSize.height(1))
                    .padding(.horizontal, 24)
                HStack {
                    Text("연동된 소셜 계정")
                        .font(.bodyNormal)
                        .foregroundColor(.natural80)
                    Spacer()
                    Text(controller.koreanSocialType)
                        .font(.bodyNormal)
                        .foregroundColor(.natural80)
                }
                .padding(.vertical, 30)
                .padding(.horizontal, 24)
                Rectangle()
                    .fill(Color.natural20) // 구분선 색상 조정)
                    .frame(height: ResponsiveSize.height(1))
                    .padding(.horizontal, 24)
                HStack {
                    Text("앱버전")
                        .font(.bodyNormal)
                        .foregroundColor(.natural80)
                    Spacer()
                    Text("1.0.0")
                        .font(.bodyNormal)
                        .foregroundColor(.natural80)
                }
                .padding(.vertical, 30)
                .padding(.horizontal, 24)
                Rectangle()
                    .fill(Color.natural20) // 구분선 색상 조정)
                    .frame(height: ResponsiveSize.height(1))
                    .padding(.horizontal, 24)
                Button(action: {
                    print("로그아웃 버튼 클릭됨")
                    commonController.logout()
                }) {
                    Text("로그아웃")
                        .font(.bodyNormal)
                        .foregroundColor(.red)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.vertical, 8)
                }
                .buttonStyle(PlainButtonStyle())
                .padding(.vertical, 30)
                .padding(.horizontal, 24)
                Rectangle()
                    .fill(Color.natural20) // 구분선 색상 조정)
                    .frame(height: ResponsiveSize.height(1))
                    .padding(.horizontal, 24)
                Button(action: {
                    print("탈퇴하기 버튼 클릭됨")
                }) {
                    Text("탈퇴하기")
                        .font(.bodyNormal)
                        .foregroundColor(.red)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.vertical, 8)
                }
                .buttonStyle(PlainButtonStyle())
                .padding(.vertical, 30)
                .padding(.horizontal, 24)
                Rectangle()
                    .fill(Color.natural20) // 구분선 색상 조정)
                    .frame(height: ResponsiveSize.height(1))
                    .padding(.horizontal, 24)
            }
        }.ignoresSafeArea(.all)
        // 🔹 이미지 선택
            .sheet(isPresented: $controller.openPhoto) {
                ImagePicker(sourceType: .photoLibrary, selectedImage: $controller.selectedImage, selectedData: $controller.selectedData) {
                    await controller.getProfileImageForUpdate()
                    
                }
            }
    }
}

//struct SettingsScreen_Previews: PreviewProvider {
//    static var previews: some View {
//        SettingsScreen()
//    }
//}

private extension SettingsScreen {
    // 이미지 섹션
    @ViewBuilder
    var profile: some View {
        if let imageUrl = URL(string: controller.userInfo.photos) {
            AsyncImage(url: imageUrl) { phase in
                switch phase {
                case .empty:
                    ProgressView()
                        .frame(width: ResponsiveSize.width(76), height: ResponsiveSize.width(76))
                case .success(let image):
                    
                    image.resizable()
                        .scaledToFill()
                        .frame(width: ResponsiveSize.width(76), height: ResponsiveSize.width(76))
                        .clipShape(Circle())
                    
                    
                case .failure:
                    ImageView(imageName: "profile", width: ResponsiveSize.width(76), height: ResponsiveSize.width(76))
                @unknown default:
                    ImageView(imageName: "profile", width: ResponsiveSize.width(76), height: ResponsiveSize.width(76))
                }
            }
        } else {
            ImageView(imageName: "profile-edit", width: ResponsiveSize.width(76), height: ResponsiveSize.width(76))
        }
    }
}
