////
////  LoginScreen.swift
////  ChuLoop
////
//
//import SwiftUI
//
//struct LoginScreen: View {
//    @StateObject private var loginController = LoginController()
//    
//    var body: some View {
//        NavigationStack {
//            VStack(spacing: 20) {
//                // 로고 및 hook 내용 텍스트
//                Text("ChuLoop")
//                    .font(.CookieBlack44)
//                    .multilineTextAlignment(.center)
//                    .padding(.top, 180)
//                
//                Spacer()
//                
//                // 상태 표시 (임시)
//                // 로그인 메시지
//                if !loginController.loginMessage.isEmpty {
//                    Text(loginController.loginMessage)
//                        .font(.footnote)
//                        .foregroundColor(.red)
//                        .multilineTextAlignment(.center)
//                }
//                // 네비게이션 링크
//                Button(action: {
//                    loginController.loginWithGoogle()
//                }) {
//                    Text("Google 계정으로 로그인")
//                        .font(.headline)
//                        .foregroundColor(.black)
//                        .frame(maxWidth: .infinity)
//                        .padding()
//                        .background(
//                            RoundedRectangle(cornerRadius: 10)
//                                .stroke(Color.gray, lineWidth: 1)
//                        )
//                }
//                .disabled(loginController.isLoading) // 로딩 중일 때 버튼 비활성화
//                // NavigationDestination 정의
//                .navigationDestination(isPresented: $loginController.navigateToMain) {
//                    MainTabView().navigationBarBackButtonHidden(true)
//                }
//                
//                // 네이버 로그인 버튼
//                Text("네이버 계정으로 로그인")
//                    .font(.Cookie16)
//                    .foregroundColor(.white)
//                    .frame(maxWidth: .infinity)
//                    .padding()
//                    .background(Color.green)
//                    .cornerRadius(10)
//                
//                // 카카오 로그인 버튼
//                Text("카카오 계정으로 로그인")
//                    .font(.Cookie16)
//                    .foregroundColor(.black)
//                    .frame(maxWidth: .infinity)
//                    .padding()
//                    .background(Color.yellow)
//                    .cornerRadius(10)
//                
//                // Apple 로그인 버튼
//                Text("애플 계정으로 로그인")
//                    .font(.Cookie16)
//                    .foregroundColor(.white)
//                    .frame(maxWidth: .infinity)
//                    .padding()
//                    .background(Color.black)
//                    .cornerRadius(10)
//            }
//            .padding(.horizontal, 30)
//            .padding(.bottom, 30) // 하단 여백 추가
//        }
//    }
//    
//}
//
//struct LoginScreen_Previews: PreviewProvider {
//    static var previews: some View {
//        LoginScreen()
//    }
//}
