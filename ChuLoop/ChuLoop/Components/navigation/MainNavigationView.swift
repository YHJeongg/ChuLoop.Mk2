//
//  MainNavigationView.swift
//  ChuLoop
//

import SwiftUI

import SwiftUI

struct MainNavigationView<Content: View>: View {
    let title: String
    let content: () -> Content
    let onAddButtonTapped: (() -> Void)?
    
    init(title: String, @ViewBuilder content: @escaping () -> Content, onAddButtonTapped: (() -> Void)? = nil) {
        self.title = title
        self.content = content
        self.onAddButtonTapped = onAddButtonTapped
    }
    
    var body: some View {
        NavigationView {
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
        }
    }
}
