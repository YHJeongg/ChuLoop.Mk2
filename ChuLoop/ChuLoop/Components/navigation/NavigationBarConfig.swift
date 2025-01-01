//
//  NavigationBarConfig.swift
//  ChuLoop
//

import Foundation
import UIKit

func configNavigationBarAppearance() {
    let appearance = UINavigationBarAppearance()
    appearance.configureWithOpaqueBackground()
    appearance.backgroundColor = UIColor(red: 142/255, green: 201/255, blue: 255/255, alpha: 1.0) // #8EC9FF
    appearance.titleTextAttributes = [.foregroundColor: UIColor.white]
    appearance.largeTitleTextAttributes = [.foregroundColor: UIColor.white]

    UINavigationBar.appearance().standardAppearance = appearance
    UINavigationBar.appearance().scrollEdgeAppearance = appearance
    UINavigationBar.appearance().compactAppearance = appearance
    UINavigationBar.appearance().tintColor = UIColor.white
}
