//
//  MapBottomSheet.swift
//  ChuLoop
//

import SwiftUI

struct MapBottomSheet: View {
    let item: MapModel
    var onAddressTap: (MapModel) -> Void
    var onReviewTap: (MapModel) -> Void

    // 중앙 팝업 제어를 위한 상태값
    @State private var isShowingDirectionPopup = false

    var body: some View {
        VStack(spacing: ResponsiveSize.height(20)) {
            // 맛집 이름
            HStack(spacing: 8) {
                ImageView(imageName: "red-marker", width: 20, height: 20)
                
                Text(item.title)
                    .font(.bodyMediumBold)
                    .foregroundColor(.natural90)
                    .frame(maxWidth: .infinity, alignment: .leading)
            }

            // 주소 버튼
            Button(action: {
                onAddressTap(item)
                isShowingDirectionPopup = true
            }) {
                HStack(alignment: .top, spacing: 8) {
                    ImageView(imageName: "copy", width: 16, height: 16)
                        .padding(.top, 2)
                    
                    Text(item.address)
                        .font(.bodyNormal)
                        .foregroundColor(.natural80)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .multilineTextAlignment(.leading)
                }
            }
            .buttonStyle(PlainButtonStyle()) // 리퀴드 글래스 효과 차단

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
        // 바텀시트 위치를 고정하고 팝업만 화면 중앙에 띄움
        .overlay {
            if isShowingDirectionPopup {
                GeometryReader { geometry in
                    ZStack {
                        Color.black.opacity(0.3)
                            .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
                            .onTapGesture {
                                isShowingDirectionPopup = false
                            }

                        MapDirectionSheet(
                            title: item.title,
                            address: item.address,
                            onCopy: {
                                isShowingDirectionPopup = false
                            }
                        )
                        .frame(width: 300)
                        .background(Color.white)
                        .cornerRadius(10)
                        .shadow(color: .black.opacity(0.2), radius: 20)
                        .transition(.scale.combined(with: .opacity))
                    }
                    .offset(x: -geometry.frame(in: .global).minX, y: -geometry.frame(in: .global).minY)
                    .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
                }
            }
        }
        .animation(.easeInOut(duration: 0.2), value: isShowingDirectionPopup)
    }
}
