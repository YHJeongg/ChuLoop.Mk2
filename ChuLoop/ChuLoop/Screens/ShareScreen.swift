//
//  ShareScreen.swift
//  ChuLoop
//

import SwiftUI

struct ShareScreen: View {
    var body: some View {
        MainNavigationView(title: "맛집 커뮤니티") {
            Text("공유된 맛집이 없어요\n타임라인에 올린 맛집을 함께 공유해보세요")
                .multilineTextAlignment(.center)
        }
    }
}

#Preview {
    ShareScreen()
}
