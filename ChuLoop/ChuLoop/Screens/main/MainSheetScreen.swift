//
//  MainSheetScreen.swift
//  ChuLoop
//

import SwiftUI

struct MainSheetScreen: View {
    @Environment(\.dismiss) var dismiss
    @ObservedObject var controller: MainScreenController
    let postId: String

    var body: some View {
        ZStack {
            if controller.isLoading {
                ProgressView()
                    .progressViewStyle(CircularProgressViewStyle(tint: .black))
            } else if let post = controller.selectedPost {
                VStack(spacing: 0) {
                    HStack {
                        Button(action: {
                            dismiss()
                        }) {
                            Image(systemName: "xmark")
                                .font(.title)
                                .foregroundColor(.white)
                        }

                        Spacer()

                        Text(post.title)
                            .font(.bodyLargeBold)
                            .fontWeight(.bold)
                            .lineLimit(1)
                            .foregroundColor(.white)

                        Spacer()

                        Text("1 / \(post.images.count)")
                            .font(.bodyMedium)
                            .foregroundColor(.white)
                    }
                    .padding()

                    if let imageUrl = post.images.first {
                        AsyncImage(url: URL(string: imageUrl)) { image in
                            image
                                .resizable()
//                                .scaledToFit()
                        } placeholder: {
                            ProgressView()
                        }
                        .frame(maxWidth: .infinity, maxHeight: ResponsiveSize.height(500))
                        .padding(.bottom, ResponsiveSize.height(6))
                    }

                    VStack(alignment: .leading, spacing: 4) {
                        HStack {
                            Image(systemName: "star.fill")
                                .foregroundColor(.yellow)
                                .frame(width: 24, height: 24)

                            Text(String(format: "%.1f", Double(post.rating)))
                                .font(.bodyNormal)
                                .foregroundColor(.white)
                        }
                        .padding(.vertical, ResponsiveSize.height(6))

                        Text("\(post.category) / \(timeAgo(from: post.date))")
                            .font(.bodyMedium)
                            .foregroundColor(.white)
                            .padding(.vertical, ResponsiveSize.height(8))

                        Text(post.description!)
                            .lineLimit(4)
                            .font(.bodyNormal)
                            .foregroundColor(.white)
                            .padding(.vertical, ResponsiveSize.height(7))

                        Button(action: {
                            print("더보기 버튼 클릭")
                        }) {
                            Text("더보기")
                                .font(.bodySmallBold)
                                .foregroundColor(.blue)
                        }
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.horizontal, ResponsiveSize.width(20))
                    Spacer()
                }
            } else {
                Text("데이터를 불러올 수 없습니다.")
                    .foregroundColor(.white)
            }
        }
        .background(Color.black.opacity(0.8))
        .clearModalBackground()
        .onAppear {
            controller.getMainSheetPost(postId: postId)
        }
    }
}

// iOS 16.4 이상에서는 SwiftUI API, 이하 버전에서는 UIKit 사용
struct ClearBackgroundViewModifier: ViewModifier {
    func body(content: Content) -> some View {
        if #available(iOS 16.4, *) {
            content
                .presentationBackground(.clear)
        } else {
            content
                .background(ClearBackgroundView())
        }
    }
}

extension View {
    func clearModalBackground() -> some View {
        self.modifier(ClearBackgroundViewModifier())
    }
}

// iOS 16.4 미만에서 사용될 UIViewRepresentable
struct ClearBackgroundView: UIViewRepresentable {
    func makeUIView(context: Context) -> UIView {
        let view = UIView()
        DispatchQueue.main.async {
            view.superview?.superview?.backgroundColor = .clear
        }
        return view
    }
    
    func updateUIView(_ uiView: UIView, context: Context) {}
}
