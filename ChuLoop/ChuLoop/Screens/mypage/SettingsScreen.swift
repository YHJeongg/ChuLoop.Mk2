//
//  SettingsScreen.swift
//  ChuLoop
//

import SwiftUI

struct SettingsScreen: View {
    @State private var username: String = "사용자 이름"
    
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            Spacer()
            // 상단 사용자 정보 섹션
            HStack {
                Image(systemName: "person.crop.circle.fill")
                    .resizable()
                    .frame(width: 60, height: 60)
                    .foregroundColor(.gray)
                
                TextField("사용자 이름", text: $username)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .font(.system(size: 18))
                    .frame(maxWidth: .infinity)
                
                Button(action: {
                    print("이름 변경 버튼 클릭됨")
                }) {
                    Text("변경")
                        .font(.system(size: 16, weight: .bold))
                        .foregroundColor(.white)
                        .padding(.vertical, 8)
                        .padding(.horizontal, 16)
                        .background(Color.blue)
                        .cornerRadius(10)
                }
            }
            .padding(.horizontal)
            
            // 리스트 섹션
            List {
                HStack {
                    Text("이메일:")
                        .font(.system(size: 18, weight: .medium))
                        .foregroundColor(.black)
                    Spacer()
                    Text("example@example.com")
                        .font(.system(size: 18))
                        .foregroundColor(.gray)
                }
                .padding(.vertical, 8)
                
                HStack {
                    Text("연동된 소셜 계정:")
                        .font(.system(size: 18, weight: .medium))
                        .foregroundColor(.black)
                    Spacer()
                    Text("Google")
                        .font(.system(size: 18))
                        .foregroundColor(.gray)
                }
                .padding(.vertical, 8)
                
                HStack {
                    Text("앱버전:")
                        .font(.system(size: 18, weight: .medium))
                        .foregroundColor(.black)
                    Spacer()
                    Text("1.0.0")
                        .font(.system(size: 18))
                        .foregroundColor(.gray)
                }
                .padding(.vertical, 8)
                
                Button(action: {
                    print("로그아웃 버튼 클릭됨")
                }) {
                    Text("로그아웃")
                        .font(.system(size: 18, weight: .medium))
                        .foregroundColor(.red)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.vertical, 8)
                }
                .buttonStyle(PlainButtonStyle())
                
                Button(action: {
                    print("탈퇴하기 버튼 클릭됨")
                }) {
                    Text("탈퇴하기")
                        .font(.system(size: 18, weight: .medium))
                        .foregroundColor(.red)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.vertical, 8)
                }
                .buttonStyle(PlainButtonStyle())
            }
            .listStyle(PlainListStyle())
        }
        .navigationTitle("설정")
    }
}

struct SettingsScreen_Previews: PreviewProvider {
    static var previews: some View {
        SettingsScreen()
    }
}
