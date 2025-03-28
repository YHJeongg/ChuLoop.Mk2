//
//  WillCard.swift
//  ChuLoop
//

import SwiftUI

struct WillCard: View {
    @Binding var place: WillModel
    var onWriteReview: (() -> Void)? = nil
    var onCopyAddressAndGetDirections: (() -> Void)? = nil

    var body: some View {
        HStack(spacing: 15) {
            // 이미지 부분
            imageSection

            // 내용 부분
            contentSection
        }
        .background(Color.white)
        .cornerRadius(5)
        .overlay(RoundedRectangle(cornerRadius: 5).stroke(Color.gray.opacity(0.3), lineWidth: 0.5))
        .padding(.horizontal)
    }
}

private extension WillCard {
    // 이미지 섹션
    var imageSection: some View {
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
                            .scaledToFill()
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

    // 내용 섹션
    var contentSection: some View {
        VStack(alignment: .leading, spacing: 8) {
            titleAndCategorySection
            addressSection
            Spacer()
            actionSection
        }
    }

    // 타이틀과 카테고리
    var titleAndCategorySection: some View {
        HStack {
            Text(place.title)
                .font(.headline)
                .foregroundColor(.black)
                .lineLimit(1)

            Spacer()

            Text(place.category)
                .font(.subheadline)
                .foregroundColor(.black)
        }
        .padding(.top, 5)
    }

    // 주소
    var addressSection: some View {
        Text(place.address)
            .font(.body)
            .foregroundColor(.black)
            .lineLimit(2)
            .padding(.bottom, 8)
    }

    // 액션 버튼 (리뷰 작성, 주소 복사 및 길찾기 버튼)
    var actionSection: some View {
        HStack {
            Button(action: {
                onWriteReview?()
            }) {
                Text("리뷰 작성")
                    .font(.body)
                    .foregroundColor(.blue)
            }

            Spacer()

            // 주소 복사 / 길찾기 버튼
            Button(action: {
                onCopyAddressAndGetDirections?()
            }) {
                Text("주소복사 / 길찾기")
                    .font(.body)
                    .foregroundColor(.blue)
            }
        }
        .padding(.top, 8)
    }
}
