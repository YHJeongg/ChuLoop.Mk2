//
//  MainScreen.swift
//  ChuLoop
//

import SwiftUI

struct MainScreen: View {
    var body: some View {
        MainNavigationView(title: "타임라인") {
            VStack {
                Text("타임라인 테스트")
                    .padding()
            }
        } onAddButtonTapped: {
            print("NavigationView Button Test")
        }
    }
}

struct MainScreen_Previews: PreviewProvider {
    static var previews: some View {
        MainScreen()
    }
}
