//
//  MyPageScreen.swift
//  ChuLoop
//


import SwiftUI

struct MyPageScreen: View {
    var body: some View {
        MyPageNavigationView(title: "My Page", content: {
            // MyPage의 콘텐츠
            VStack {
                Text("MyPage Test")
                    .font(.title)
                    .padding()
            }
        })
    }
}

#Preview {
    MyPageScreen()
}
