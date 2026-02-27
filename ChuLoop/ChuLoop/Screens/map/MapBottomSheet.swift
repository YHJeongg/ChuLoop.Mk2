//
//  MapBottomSheet.swift
//  ChuLoop
//

import SwiftUI

struct MapBottomSheet: View {
    let item: MapModel
    var onAddressTap: (MapModel) -> Void
    var onReviewTap: (MapModel) -> Void

    var body: some View {
        VStack(spacing: ResponsiveSize.height(20)) {
            // 맛집 이름
            Text(item.title)
                .font(.bodyMediumBold)
                .foregroundColor(.natural90)
                .frame(maxWidth: .infinity, alignment: .leading)

            // 주소
            Button(action: {
                onAddressTap(item)
            }) {
                HStack(alignment: .top, spacing: 8) {
                    Image(systemName: "mappin.and.ellipse")
                        .font(.system(size: 14))
                        .foregroundColor(.gray)
                        .padding(.top, 2)
                    
                    Text(item.address)
                        .font(.bodyNormal)
                        .foregroundColor(.natural80)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .multilineTextAlignment(.leading)
                }
            }
            .buttonStyle(PlainButtonStyle())

            // 리뷰 작성 버튼
            Button(action: {
                onReviewTap(item)
            }) {
                Text("리뷰 작성하기")
                    .font(.bodyMedium)
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .frame(height: ResponsiveSize.height(50))
                    .background(Color.blue)
                    .cornerRadius(10)
            }
        }
        .padding(.horizontal, ResponsiveSize.width(30))
        .padding(.top, ResponsiveSize.height(25))
        .padding(.bottom, ResponsiveSize.height(40))
        .background(
            RoundedRectangle(cornerRadius: 25)
                .fill(Color.white)
                .shadow(color: .black.opacity(0.15), radius: 15, x: 0, y: -5)
        )
    }
}
