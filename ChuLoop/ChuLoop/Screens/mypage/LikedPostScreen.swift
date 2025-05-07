//
//  LikedPostScreen.swift
//  ChuLoop
//
//  Created by Anna Kim on 3/17/25.
//

import SwiftUI

struct LikedPostScreen: View {
    @EnvironmentObject var commonController: CommonController  // ✅ 환경 객체 가져오기

    @ObservedObject var controller: LikedPostController // 외부에서 주입받음
    
    var body: some View {
        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
    }
}

//#Preview {
//    LikedPostScreen()
//}
