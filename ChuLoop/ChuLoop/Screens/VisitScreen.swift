//
//  VisitScreen.swift
//  ChuLoop
//

import SwiftUI

struct VisitScreen: View {
    var body: some View {
        MainNavigationView(title: "방문할 맛집") {
            VStack {
                Text("방문할 맛집 테스트")
                    .padding()
            }
        } onAddButtonTapped: {
            print("NavigationView Button Test")
        }
    }
}

#Preview {
    VisitScreen()
}
