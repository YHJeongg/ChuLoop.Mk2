//
//  ShareCard.swift
//  ChuLoop
//

import SwiftUI

struct ShareCard: View {
    @Binding var item: ShareModel
    @Binding var showSheet: Bool
    
    var onLike: (() -> Void)? = nil
    var onShare: (() -> Void)? = nil
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            // 이미지 섹션
            imageSection

            // 사용자 정보 섹션
            HStack(spacing: 8) {
                Image(systemName: "person.circle.fill")
                    .resizable()
                    .frame(width: ResponsiveSize.width(22), height: ResponsiveSize.height(22))
                    .foregroundColor(.natural40)
                
                // 닉네임
                Text(item.nickname)
                    .font(.bodyXSmallBold)
                    .foregroundColor(.natural80)
                
                Spacer()
            }
            .padding(.horizontal, ResponsiveSize.width(15))
            .padding(.top, ResponsiveSize.height(12))

            // 내용 및 액션 버튼 섹션
            VStack(alignment: .leading, spacing: 0) {
                titleAndDateSection
                addressSection
                actionButtonSection
            }
        }
        .background(Color.white)
        .cornerRadius(5)
        .overlay(
            RoundedRectangle(cornerRadius: 5)
                .stroke(Color.natural40, lineWidth: 0.5)
        )
    }
}

// MARK: - Subviews
private extension ShareCard {
    
    var imageSection: some View {
        Group {
            if let firstImage = item.images.first, let imageUrl = URL(string: firstImage) {
                AsyncImage(url: imageUrl) { phase in
                    switch phase {
                    case .empty:
                        ProgressView()
                            .frame(maxWidth: .infinity)
                            .frame(height: ResponsiveSize.height(250))
                    case .success(let image):
                        image.resizable()
                            .scaledToFill()
                            .frame(height: ResponsiveSize.height(250))
                            .clipped()
                    case .failure:
                        placeholderImage
                    @unknown default:
                        EmptyView()
                    }
                }
            } else {
                placeholderImage
            }
        }
    }
    
    var placeholderImage: some View {
        Rectangle()
            .fill(Color.natural20)
            .frame(height: ResponsiveSize.height(250))
            .overlay(
                Image(systemName: "photo")
                    .foregroundColor(.natural40)
            )
    }
    
    var titleAndDateSection: some View {
        HStack {
            Text(item.title)
                .font(.bodyMediumBold)
                .foregroundColor(.natural90)
                .lineLimit(1)
            
            Spacer()
            
            Text(item.date)
                .font(.bodySmall)
                .foregroundColor(.natural60)
        }
        .padding(.horizontal, ResponsiveSize.width(15))
        .padding(.top, ResponsiveSize.height(10))
    }

    var actionButtonSection: some View {
        HStack {
            // 좋아요 버튼
            Button(action: { onLike?() }) {
                HStack(spacing: 6) {
                    Image(systemName: item.mylikes ? "heart.fill" : "heart")
                        .font(.system(size: 16))
                        .foregroundColor(item.mylikes ? .error : .natural60)
                    Text("\(item.likes)명이 좋아해요")
                        .font(.bodyXSmall)
                        .foregroundColor(.natural90)
                }
            }
            .buttonStyle(PlainButtonStyle())

            Spacer()

            Button(action: { shareToSystem(text: "[\(item.title)]\n주소: \(item.address)") }) {
                HStack(spacing: 4) {
                    Image(systemName: "square.and.arrow.up")
                        .font(.system(size: 16))
                        .foregroundColor(.darkBlack)
                    Text("공유하기")
                        .font(.bodyXSmall)
                        .foregroundColor(.natural90)
                }
            }
            .buttonStyle(PlainButtonStyle())
        }
        .padding(.horizontal, ResponsiveSize.width(15))
        .padding(.vertical, ResponsiveSize.height(18))
    }

    // 주소 섹션
    var addressSection: some View {
        Text(item.address)
            .font(.bodyXSmall)
            .foregroundColor(.natural60)
            .padding(.horizontal, ResponsiveSize.width(15))
            .padding(.top, ResponsiveSize.height(4))
            .onTapGesture {
                onShare?()
            }
    }
    
    // iOS 시스템 공유 호출
    private func shareToSystem(text: String) {
        let activityVC = UIActivityViewController(activityItems: [text], applicationActivities: nil)

        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
           let rootVC = windowScene.windows.first?.rootViewController {
            rootVC.present(activityVC, animated: true, completion: nil)
        }
    }
}
