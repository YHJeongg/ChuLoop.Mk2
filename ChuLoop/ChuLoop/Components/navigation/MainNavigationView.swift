//
//  MainNavigationView.swift
//  ChuLoop
//

import SwiftUI

struct MainNavigationView<Content: View, SecondPage: View>: View {
    let title: String
    let content: () -> Content
    let onAddButtonTapped: (() -> Void)?
    @Binding var isSecondPage: Bool
    let secondPage: (() -> SecondPage)?
    
    init(title: String, @ViewBuilder content: @escaping () -> Content, onAddButtonTapped: (() -> Void)? = nil,  isSecondPage: Binding<Bool>, @ViewBuilder secondPage: @escaping () -> SecondPage) {
        self.title = title
        self.content = content
        self.onAddButtonTapped = onAddButtonTapped
        self._isSecondPage = isSecondPage
        self.secondPage = secondPage
    }
    
    var body: some View {
        NavigationStack {
            ZStack {
                content()
            }
            .toolbar { // SwiftUI toolbar 유지
                ToolbarItem(placement: .navigationBarLeading) {
                    Text(title)
                        .font(.CookieBold20)
                        .foregroundColor(.black)
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    if let onAddButtonTapped = onAddButtonTapped {
                        Button(action: onAddButtonTapped) {
                            Image(systemName: "plus")
                                .font(.system(size: 15))
                                .frame(width: 30, height: 30)
                                .foregroundColor(.black)
                                .background(Color.white)
                                .clipShape(RoundedRectangle(cornerRadius: 10))
                                .shadow(color: .black.opacity(0.1), radius: 3, x: 0, y: 2)
                        }
                    }
                }
            }
            
            .navigationDestination(isPresented: $isSecondPage) {
                if let secondPage = secondPage {
                    secondPage() // `secondPage` 클로저 호출
                }
                
            }
            
            
        }
    }
}
