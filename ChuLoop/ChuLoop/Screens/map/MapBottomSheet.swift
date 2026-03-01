//
//  MapBottomSheet.swift
//  ChuLoop
//

import SwiftUI

struct MapBottomSheet: View {
    let item: MapModel
    var onAddressTap: (MapModel) -> Void
    var onReviewTap: (MapModel) -> Void

    @State private var isShowingDirectionPopup = false
    @State private var showTopToast = false

    var body: some View {
        ZStack(alignment: .bottom) {
            
            // 메인 바텀시트 콘텐츠
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
                .buttonStyle(PlainButtonStyle())

                // 리뷰 버튼
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
            // 바텀시트 위치를 강제로 바닥에 고정
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottom)

            // 중앙 팝업 레이어
            if isShowingDirectionPopup {
                ZStack {
                    // 배경 어둡게
                    Color.black.opacity(0.3)
                        .ignoresSafeArea()
                        .onTapGesture { isShowingDirectionPopup = false }

                    // 중앙 팝업
                    MapDirectionSheet(
                        title: item.title,
                        address: item.address,
                        onCopy: {
                            isShowingDirectionPopup = false
                            // 복사 후 즉시 토스트 트리거
                            triggerToast()
                        }
                    )
                    .frame(width: 300)
                    .background(Color.white)
                    .cornerRadius(10)
                    .shadow(color: .black.opacity(0.2), radius: 20)
                    .transition(.scale.combined(with: .opacity))
                }
                .zIndex(10) // 바텀시트보다 위에 있도록 설정
            }
        }
        // 토스트 메시지
        .showSaveToast(isShowing: $showTopToast, message: "주소가 복사되었습니다.")
        .animation(.spring(response: 0.3, dampingFraction: 0.8), value: isShowingDirectionPopup)
    }

    private func triggerToast() {
        let generator = UINotificationFeedbackGenerator()
        generator.notificationOccurred(.success)
        showTopToast = true
    }
}
