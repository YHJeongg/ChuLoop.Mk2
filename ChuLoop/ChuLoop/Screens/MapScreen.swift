//
//  MapScreen.swift
//  ChuLoop
//

import SwiftUI

struct MapScreen: View {
    var body: some View {
        MainNavigationView(title: "맛집지도") {
            VStack {
                Text("지도 테스트")
                    .padding()
            }
        } onAddButtonTapped: {
            print("NavigationView Button Test")
        }
    }
}

#Preview {
    MapScreen()
}
