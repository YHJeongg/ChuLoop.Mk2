//
//  LoginScreen.swift
//  ChuLoop
//

import SwiftUI

struct LoginScreen: View {
    @EnvironmentObject private var loginController: LoginController 
    
    var body: some View {
        if(loginController.navigateToMain) {
            MainTabView()
        } else {
//            NavigationStack {
                VStack(alignment: .center, spacing: 20) {
                    // 로고 및 hook 내용 텍스트
                    Text("ChuLoop")
                        .font(.heading1)
                        .padding(.top, 180)
                    Spacer()
                    if !loginController.loginMessage.isEmpty {
                        Text(loginController.loginMessage)
                            .font(.footnote)
                            .foregroundColor(.red)
                            .multilineTextAlignment(.center)
                    }
                    
                    SocialLoginButton(
                        title: "Google 계정으로 로그인",
                        backgroundColor: .white,
                        borderColor: .gray,
                        iconName: "g.circle",
                        textColor: .black,
                        action: {
                            GoogleLoginController(loginController: loginController).signIn()
                        }
                    )
                    
                    SocialLoginButton(
                        title: "네이버 계정으로 로그인",
                        backgroundColor: .green,
                        iconName: "n.square.fill",
                        textColor: .white,
                        action: {
                            NaverLoginController().signIn()
                        }
                    )
                    
                    SocialLoginButton(
                        title: "카카오 계정으로 로그인",
                        backgroundColor: .yellow,
                        iconName: "message.fill",
                        textColor: .black,
                        action: {
                            KakaoLoginController().signIn()
                        }
                    )
                    
                    SocialLoginButton(
                        title: "애플 계정으로 로그인",
                        backgroundColor: .black,
                        iconName: "applelogo",
                        textColor: .white,
                        action: {
                            AppleLoginController().signIn()
                        }
                    )
                }
                .padding(.horizontal, 30)
                .padding(.bottom, 30) // 하단 여백 추가
    //            .navigationDestination(isPresented: $loginController.navigateToMain) {
    //                MainTabView()
    //            }
//            }
        }
        
    }
}


struct LoginScreen_Previews: PreviewProvider {
    static var previews: some View {
        LoginScreen()
    }
}
