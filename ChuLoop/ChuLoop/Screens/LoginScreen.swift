//
//  LoginScreen.swift
//  ChuLoop
//
//  Created by Jeong Yun Hyeon on 11/13/24.
//

import SwiftUI

struct LoginScreen: View {
    var body: some View {
        VStack(spacing: 20) {
            // 로고 및 hook 내용 텍스트
            Text("로고 및\nhook 내용")
                .font(.system(size: 40, weight: .bold))
                .multilineTextAlignment(.center)
                .padding(.top, 150)
            
            Spacer()
            
            // Google 로그인 버튼
            Text("Google 계정으로 로그인")
                .font(.system(size: 16))
                .foregroundColor(.black)
                .frame(maxWidth: .infinity)
                .padding()
                .background(
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(Color.gray, lineWidth: 1)
                )
            
            // 네이버 로그인 버튼
            Text("네이버 계정으로 로그인")
                .font(.system(size: 16))
                .foregroundColor(.white)
                .frame(maxWidth: .infinity)
                .padding()
                .background(Color.green)
                .cornerRadius(10)
            
            // 카카오 로그인 버튼
            Text("카카오 계정으로 로그인")
                .font(.system(size: 16))
                .foregroundColor(.black)
                .frame(maxWidth: .infinity)
                .padding()
                .background(Color.yellow)
                .cornerRadius(10)
            
            // Apple 로그인 버튼
            Text("애플 계정으로 로그인")
                .font(.system(size: 16))
                .foregroundColor(.white)
                .frame(maxWidth: .infinity)
                .padding()
                .background(Color.black)
                .cornerRadius(10)
        }
        .padding(.horizontal, 30)
        .padding(.bottom, 30) // 하단 여백 추가
    }
}

struct LoginScreen_Previews: PreviewProvider {
    static var previews: some View {
        LoginScreen()
    }
}
