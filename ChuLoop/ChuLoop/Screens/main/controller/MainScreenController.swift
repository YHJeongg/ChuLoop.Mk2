//
//  MainScreenController.swift
//  ChuLoop
//
//  Created by Anna Kim on 1/28/25.
//
import SwiftUI

class MainScreenController: ObservableObject {
    @Published var isNavigatingToAddScreen: Bool = false // 상태 변수 추가
    
    func goToAddScreen() {
        isNavigatingToAddScreen = true
    }
    
    func goBack() {
        isNavigatingToAddScreen = false
    }
}
