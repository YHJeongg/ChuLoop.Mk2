//
//  LoginScreen.swift
//  ChuLoop
//

import SwiftUI

struct LoginScreen: View {

    var body: some View {
        NavigationView {
            VStack(alignment: .center, spacing: 20) {
                // 로고 및 hook 내용 텍스트
                Text("ChuLoop")
                    .font(.CookieBlack44)
                    .padding(.top, 180)
                Spacer()

                // Google 로그인 버튼
                Button(action: {
                    GoogleOAuth().signIn()
                }) {
                    ZStack(alignment: .leading) {
                        HStack(alignment: .center) {
                            Text("Google 계정으로 로그인")
                                .font(.Cookie16)
                                .foregroundColor(.black)
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(
                                    RoundedRectangle(cornerRadius: 10)
                                        .stroke(Color.gray, lineWidth: 1)
                                )
                        }
                        Image(systemName: "g.circle")
                            .foregroundColor(.black)
                            .padding(.leading, 16)
                    }
                }
                
                // 네이버 로그인 버튼
                Button(action: {
                    NaverAuth.shared.login()
                }) {
                    ZStack(alignment: .leading) {
                        HStack(alignment: .center) {
                            Text("네이버 계정으로 로그인")
                                .font(.Cookie16)
                                .foregroundColor(.white)
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(Color.green)
                                .cornerRadius(10)
                        }
                        Image(systemName: "n.square.fill")
                            .foregroundColor(.white)
                            .padding(.leading, 16)
                    }
                }
                .onAppear {
                    NaverAuth.configure() // 네이버 로그인 설정
                }
                
                // 카카오 로그인 버튼
                Button(action: {
                    print("카카오")
                }) {
                    ZStack(alignment: .leading) {
                        HStack(alignment: .center) {
                            Text("카카오 계정으로 로그인")
                                .font(.Cookie16)
                                .foregroundColor(.black)
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(Color.yellow)
                                .cornerRadius(10)
                        }
                        Image(systemName: "message.fill")
                            .foregroundColor(.black)
                            .padding(.leading, 16)
                    }
                }
                
                // 애플 로그인 버튼
                Button(action: {
                    print("애플")
                }) {
                    ZStack(alignment: .leading) {
                        HStack(alignment: .center) {
                            Text("애플 계정으로 로그인")
                                .font(.Cookie16)
                                .foregroundColor(.white)
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(Color.black)
                                .cornerRadius(10)
                        }
                        Image(systemName: "applelogo")
                            .foregroundColor(.white)
                            .padding(.leading, 16)
                    }
                }
            }
            .padding(.horizontal, 30)
            .padding(.bottom, 30) // 하단 여백 추가
        }
    }
}

struct LoginScreen_Previews: PreviewProvider {
    static var previews: some View {
        LoginScreen()
    }
}
