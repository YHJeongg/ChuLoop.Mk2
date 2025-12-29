//
//  WillCard.swift
//  ChuLoop
//

import SwiftUI

struct WillCard: View {
    @Binding var place: WillModel
    var onWriteReview: (() -> Void)? = nil
    var onGetDirections: (() -> Void)? = nil
    @State private var showCustomSheet = false

    var body: some View {
        ZStack {
            cardContent
        }
    }

    private var cardContent: some View {
        HStack(spacing: 10) {
            imageSection
            contentSection
        }
        .frame(width: ResponsiveSize.width(382), height: ResponsiveSize.height(140))
        .background(Color.white)
        .cornerRadius(5)
        .overlay(RoundedRectangle(cornerRadius: 5).stroke(Color.natural60, lineWidth: 0.5))
    }

    // MARK: - 이미지 섹션
    private var imageSection: some View {
        Group {
            if let imageUrl = URL(string: place.images.first ?? "") {
                AsyncImage(url: imageUrl) { phase in
                    switch phase {
                    case .empty:
                        ProgressView()
                            .frame(width: ResponsiveSize.width(140), height: ResponsiveSize.height(140))
                            .background(Color.gray.opacity(0.1))
                            .scaledToFill()
                    case .success(let image):
                        image.resizable()
                            .scaledToFill()
                            .frame(width: ResponsiveSize.width(140), height: ResponsiveSize.height(140))
                            .clipped()
                    case .failure:
                        Image(systemName: "photo")
                            .resizable()
                            .scaledToFit()
                            .frame(width: ResponsiveSize.width(140), height: ResponsiveSize.height(140))
                            .foregroundColor(.gray)
                    @unknown default:
                        EmptyView()
                    }
                }
            }
        }
    }

    // MARK: - 내용 섹션
    private var contentSection: some View {
        VStack(alignment: .leading, spacing: 4) {
            titleAndCategorySection
            addressSection
            actionSection
        }
        .padding(.trailing, ResponsiveSize.width(10))
    }

    private var titleAndCategorySection: some View {
        HStack {
            Text(place.title)
                .font(.bodySmallBold)
                .foregroundColor(.black)
                .lineLimit(1)

            Spacer()

            Text(place.category)
                .font(.bodyXXSmall)
                .foregroundColor(.black)
        }
        .padding(.top, ResponsiveSize.height(15))
    }

    private var addressSection: some View {
        Text(place.address)
            .font(.bodyXSmall)
            .foregroundColor(.black)
            .lineLimit(2)
            .padding(.vertical, ResponsiveSize.height(15))
    }

    private var actionSection: some View {
        HStack {
            Button(action: {
                onWriteReview?()
            }) {
                Text("리뷰 쓰기")
                    .font(.bodySmall)
                    .foregroundColor(.black)
                    .frame(width: ResponsiveSize.width(70), height: ResponsiveSize.height(30))
                    .background(Color.secondary50)
                    .cornerRadius(8)
            }

            Spacer()

            Button(action: {
                UIPasteboard.general.string = place.address
            }) {
                Text("주소복사")
                    .font(.bodyXXSmall)
                    .foregroundColor(.black)
            }
            
            Text("/")
                .font(.bodyXXSmall)
                .foregroundColor(.natural60)

            Button(action: {
                onGetDirections?()
            }) {
                Text("길찾기")
                    .font(.bodyXXSmall)
                    .foregroundColor(.black)
            }
        }
        .padding(.bottom, ResponsiveSize.height(10))
    }
}
