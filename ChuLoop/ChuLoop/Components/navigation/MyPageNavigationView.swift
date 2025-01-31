//
//  MyPageNavigationView.swift
//  ChuLoop
//

import SwiftUI

struct MyPageNavigationView<Content: View>: View {
    let title: String
    let content: () -> Content
    
    init(title: String, @ViewBuilder content: @escaping () -> Content) {
        self.title = title
        self.content = content
    }
    
    var body: some View {
        NavigationStack {
            ZStack {
                content()
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    HStack {
                        Image(systemName: "person.circle.fill") // 프로필 이미지
                            .font(.system(size: 30))
                            .foregroundColor(.black)
                        
                        Text("임시닉네임") // 아이디
                            .font(.CookieBold18)
                            .foregroundColor(.black)
                    }
                }
            }
        }
    }
}

struct MyPageNavigationView_Previews: PreviewProvider {
    static var previews: some View {
        MyPageNavigationView(title: "My Page", content: {
            Text("My Page Content")
        })
    }
}
