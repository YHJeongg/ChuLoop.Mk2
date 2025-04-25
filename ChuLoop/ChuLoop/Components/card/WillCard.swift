//
//  WillCard.swift
//  ChuLoop
//

import SwiftUI

struct WillCard: View {
    @Binding var place: WillModel
    var onWriteReview: (() -> Void)? = nil
    var onGetDirections: (() -> Void)? = nil  // 길찾기만 따로 콜백
    
    // 길찾기 버튼 클릭 시 나타낼 Sheet 상태
    @State private var showCustomSheet = false

    var body: some View {
        HStack(spacing: 10) {
            // 이미지 부분
            imageSection

            // 내용 부분
            contentSection
        }
        .frame(width: ResponsiveSize.width(382), height: ResponsiveSize.height(140))
        .background(Color.white)
        .cornerRadius(5)
        .overlay(RoundedRectangle(cornerRadius: 5).stroke(Color.natural60, lineWidth: 0.5))
        .sheet(isPresented: $showCustomSheet) {
            CustomSheetView(place: place)
                .clearModalBackground() // 배경을 투명하게 처리
        }
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

    // 내용 섹션
    var contentSection: some View {
        VStack(alignment: .leading, spacing: 4) {
            titleAndCategorySection
            addressSection
            actionSection
        }
        .padding(.trailing, ResponsiveSize.width(10))
    }

    // 타이틀과 카테고리
    var titleAndCategorySection: some View {
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
        .padding(.top, 5)
    }

    // 주소
    var addressSection: some View {
        Text(place.address)
            .font(.bodyXSmall)
            .foregroundColor(.black)
            .lineLimit(2)
            .padding(.bottom, 8)
    }

    // 액션 버튼 (리뷰 작성, 주소 복사, 길찾기)
    var actionSection: some View {
        HStack {
            Button(action: {
                onWriteReview?()
            }) {
                Text("리뷰 작성")
                    .font(.bodySmall)
                    .foregroundColor(.black)
                    .frame(width: ResponsiveSize.width(70), height: ResponsiveSize.height(30))
                    .background(Color.secondary50)
                    .cornerRadius(8)
            }

            Spacer()

            // 주소복사 버튼
            Button(action: {
                UIPasteboard.general.string = place.address
            }) {
                Text("주소복사")
                    .font(.bodyXXSmall)
                    .foregroundColor(.primary900)
            }

            // 길찾기 버튼
            Button(action: {
                showCustomSheet.toggle()  // 커스텀 시트 띄우기
            }) {
                Text("길찾기")
                    .font(.bodyXXSmall)
                    .foregroundColor(.primary900)
            }
        }
        .padding(.top, 8)
    }
}

struct CustomSheetView: View {
    var place: WillModel

    var body: some View {
        VStack {
            Text("어떤 지도 앱을 사용하시겠어요?")
                .font(.headline)
                .padding()

            // 길찾기 앱 선택 버튼
            HStack {
                Button(action: {
                    if let url = URL(string: "kakaomap://route?sp=\(place.address)") {
                        UIApplication.shared.open(url)
                    }
                }) {
                    Text("카카오맵")
                        .font(.body)
                        .padding()
                }

                Button(action: {
                    if let url = URL(string: "nmap://navigate?query=\(place.address)") {
                        UIApplication.shared.open(url)
                    }
                }) {
                    Text("네이버맵")
                        .font(.body)
                        .padding()
                }

                Button(action: {
                    if let url = URL(string: "maps.apple.com/?q=\(place.address)") {
                        UIApplication.shared.open(url)
                    }
                }) {
                    Text("애플맵")
                        .font(.body)
                        .padding()
                }
            }
        }
        .background(Color.white)
        .cornerRadius(10)
        .padding()
    }
}
