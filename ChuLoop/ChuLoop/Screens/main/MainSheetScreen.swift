//
//  MainSheetScreen.swift
//  ChuLoop
//

import SwiftUI

struct MainSheetScreen: View {
    @Environment(\.dismiss) var dismiss
    @ObservedObject var controller: MainScreenController
    @State private var currentIndex = 0
    let postId: String
    
    @State private var isExpanded = false
    
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

                        VStack {
                            let title = limitTitle(post.title)
                            if title.count > 12 {
                                Text(title.prefix(12) + "\n" + title.dropFirst(12))
                            } else {
                                Text(title)
                            }
                        }
                        .font(.bodyLargeBold)
                        .fontWeight(.bold)
                        .multilineTextAlignment(.center)
                        .foregroundColor(.white)

                        Spacer()

                        Text("\(currentIndex + 1) / \(post.images.count)")
                            .font(.bodyMedium)
                            .foregroundColor(.white)
                    }
                    .padding()

                    ZStack {
                        // 이미지 슬라이드
                        TabView(selection: $currentIndex) {
                            ForEach(post.images.indices, id: \.self) { index in
                                AsyncImage(url: URL(string: post.images[index])) { image in
                                    image.resizable()
                                } placeholder: {
                                    ProgressView()
                                }
                                .frame(maxWidth: .infinity, maxHeight: ResponsiveSize.height(500))
                                .tag(index) // 현재 인덱스 추적
                            }
                        }
                        .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never)) // 기본 인디케이터 숨김
                        .frame(height: ResponsiveSize.height(500))
                        .padding(.bottom, ResponsiveSize.height(6))

                        // 왼쪽 화살표 (첫 번째 이미지가 아닐 때만 표시)
                        if currentIndex > 0 {
                            Button(action: {
                                withAnimation { currentIndex -= 1 }
                            }) {
                                Image(systemName: "chevron.left")
                                    .font(.title)
                                    .foregroundColor(.white)
                                    .padding()
                            }
                            .offset(x: -UIScreen.main.bounds.width / 2 + 40, y: 0) // 이미지 중앙 왼쪽
                        }

                        // 오른쪽 화살표 (마지막 이미지가 아닐 때만 표시)
                        if currentIndex < post.images.count - 1 {
                            Button(action: {
                                withAnimation { currentIndex += 1 }
                            }) {
                                Image(systemName: "chevron.right")
                                    .font(.title)
                                    .foregroundColor(.white)
                                    .padding()
                            }
                            .offset(x: UIScreen.main.bounds.width / 2 - 40, y: 0) // 이미지 중앙 오른쪽
                        }

                        // 페이지 인디케이터 (하단 중앙)
                        HStack(spacing: 6) {
                            ForEach(post.images.indices, id: \.self) { index in
                                Circle()
                                    .fill(index == currentIndex ? Color.white : Color.gray)
                                    .frame(width: index == currentIndex ? 10 : 6, height: index == currentIndex ? 10 : 6) // 선택된 인디케이터 크기 증가
                                    .animation(.easeInOut(duration: 0.2), value: currentIndex) // 애니메이션 추가
                            }
                        }
                        .offset(y: ResponsiveSize.height(240))
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

                        let description = post.description ?? ""
                        Text(isExpanded ? description : String(description.prefix(62)))
                            .font(.bodyNormal)
                            .foregroundColor(.white)
                            .padding(.vertical, ResponsiveSize.height(7))

                        if description.count > 62 {
                            Button(action: {
                                isExpanded.toggle()
                            }) {
                                Text(isExpanded ? "접기" : "더보기")
                                    .font(.bodySmallBold)
                                    .foregroundColor(.blue)
                            }
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

    func limitTitle(_ title: String) -> String {
        return String(title.prefix(24))
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
