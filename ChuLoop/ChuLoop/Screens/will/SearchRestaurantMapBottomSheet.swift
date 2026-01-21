//
//  SearchRestaurantMapBottomSheet.swift
//  ChuLoop
//

import SwiftUI

struct SearchRestaurantMapBottomSheet: View {
    @StateObject private var controller = WillScreenController()
    let place: Place
    let googleApiKey: String
    var onAddressTap: (WillModel) -> Void
    var onSaveSuccess: () -> Void

    var body: some View {
        VStack(spacing: ResponsiveSize.height(20)) {

            // 레스토랑 이름
            Text(place.name)
                .font(.bodyMediumBold)
                .foregroundColor(.natural90)
                .frame(maxWidth: .infinity, alignment: .leading)

            // 사진 + 주소
            HStack(alignment: .center, spacing: ResponsiveSize.width(15)) {
                restaurantImage

                Button(action: {
                    let model = WillModel(
                        id: UUID().uuidString,
                        title: place.name,
                        category: place.category,
                        address: place.address,
                        date: "",
                        images: place.photoReferences
                    )
                    onAddressTap(model)
                }) {
                    Text(place.address)
                        .font(.bodyNormal)
                        .foregroundColor(.natural80)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .multilineTextAlignment(.leading)
                }
                .buttonStyle(PlainButtonStyle())
            }

            // 저장 버튼 (로딩 상태 추가)
            Button(action: {
                controller.saveWillPost(place: place) { success in
                    if success {
                        onSaveSuccess()
                    }
                }
            }) {
                ZStack {
                    if controller.isLoading {
                        // 로딩 중일 때 표시할 인디케이터
                        ProgressView()
                            .tint(.natural10)
                    } else {
                        Text("가고싶은 맛집으로 저장")
                            .font(.bodyMedium)
                            .foregroundColor(.natural10)
                    }
                }
                .frame(
                    maxWidth: ResponsiveSize.width(382),
                    maxHeight: ResponsiveSize.height(50)
                )
                // 로딩 중일 때는 배경색을 살짝 흐리게 처리
                .background(controller.isLoading ? Color.primary900.opacity(0.7) : Color.primary900)
                .cornerRadius(10)
            }
            // 로딩 중에는 버튼 중복 클릭 방지
            .disabled(controller.isLoading)
        }
        .padding(.horizontal, ResponsiveSize.width(30))
        .padding(.top, ResponsiveSize.height(25))
        .padding(.bottom, ResponsiveSize.height(20))
        .background(
            RoundedRectangle(cornerRadius: 25)
                .fill(Color.white)
                .ignoresSafeArea(edges: .bottom)
        )
    }

    // MARK: - Restaurant Image
    private var restaurantImage: some View {
        Group {
            if let ref = place.photoReferences.first,
               let url = photoURL(photoReference: ref) {

                AsyncImage(url: url) { phase in
                    switch phase {
                    case .success(let image):
                        image
                            .resizable()
                            .scaledToFill()
                    case .failure:
                        emptyPhotoView
                    case .empty:
                        ProgressView()
                    @unknown default:
                        emptyPhotoView
                    }
                }

            } else {
                emptyPhotoView
            }
        }
        .frame(
            width: ResponsiveSize.width(80),
            height: ResponsiveSize.height(80)
        )
        .clipped()
        .cornerRadius(10)
    }

    private var emptyPhotoView: some View {
        ZStack {
            Color.gray.opacity(0.3)
            Image(systemName: "photo")
                .font(.system(size: 24))
                .foregroundColor(.gray)
        }
    }

    private func photoURL(photoReference: String) -> URL? {
        let urlString = "https://maps.googleapis.com/maps/api/place/photo?maxwidth=400&photo_reference=\(photoReference)&key=\(googleApiKey)"
        return URL(string: urlString)
    }
}
