//
//  MainNavigationView.swift
//  ChuLoop
//

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
        NavigationStack {
            ZStack {
                Color.primary50
                    .ignoresSafeArea(.all)
                content()
            }
            .toolbar { // SwiftUI toolbar 유지
                ToolbarItem(placement: .navigationBarLeading) {
                    Text(title)
                        .font(.bodyLargeBold)
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
