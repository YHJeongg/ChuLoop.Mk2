//
//  WillCard.swift
//  ChuLoop
//

import SwiftUI
import UIKit

struct WillCard: View {
    @Binding var place: WillModel
    var onWriteReview: (() -> Void)? = nil
    var onGetDirections: (() -> Void)? = nil
    var onCopyAddress: (() -> Void)? = nil

    // GPlace 카테고리를 한국어로 변환
    private var translatedCategory: String {
        switch place.category.lowercased() {
        case "restaurant":      return "음식점"
        case "establishment":   return "음식점"
        case "cafe":           return "카페"
        case "bakery":         return "빵집"
        case "bar":        return "주점"
        default:           return place.category
        }
    }

    var body: some View {
        HStack(spacing: 10) {
            imageSection
            contentSection
        }
        .frame(
            width: ResponsiveSize.width(382),
            height: ResponsiveSize.height(140)
        )
        .background(Color.white)
        .cornerRadius(5)
        .overlay(
            RoundedRectangle(cornerRadius: 5)
                .stroke(Color.natural60, lineWidth: 0.5)
        )
    }

    // MARK: - 이미지 (기존과 동일)
    private var imageSection: some View {
        Group {
            if let imageUrl = URL(string: place.images.first ?? "") {
                AsyncImage(url: imageUrl) { phase in
                    switch phase {
                    case .empty:
                        ProgressView()
                            .frame(width: ResponsiveSize.width(140), height: ResponsiveSize.height(140))
                            .background(Color.gray.opacity(0.1))
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

    // MARK: - 내용
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

            // 변환된 카테고리 적용
            Text(translatedCategory)
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

    // MARK: - 버튼 영역 (기존과 동일)
    private var actionSection: some View {
        HStack {
            Button {
                onWriteReview?()
            } label: {
                Text("리뷰쓰기")
                    .font(.bodySmall)
                    .foregroundColor(.black)
                    .frame(width: ResponsiveSize.width(70), height: ResponsiveSize.height(30))
                    .background(Color.secondary50)
                    .cornerRadius(8)
            }

            Spacer()

            Button {
                UIPasteboard.general.string = place.address
                onCopyAddress?()
            } label: {
                Text("주소복사")
                    .font(.bodyXXSmall)
                    .foregroundColor(.black)
            }

            Text("/")
                .font(.bodyXXSmall)
                .foregroundColor(.natural60)

            Button {
                onGetDirections?()
            } label: {
                Text("길찾기")
                    .font(.bodyXXSmall)
                    .foregroundColor(.black)
            }
        }
        .padding(.bottom, ResponsiveSize.height(10))
    }
}
