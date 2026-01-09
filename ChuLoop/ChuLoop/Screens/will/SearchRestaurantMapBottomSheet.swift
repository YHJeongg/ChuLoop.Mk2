//
//  SearchRestaurantMapBottomSheet.swift
//  ChuLoop
//

import SwiftUI

struct SearchRestaurantMapBottomSheet: View {
    let place: Place
    let googleApiKey: String

    var body: some View {
        VStack(spacing: 16) {

            // 드래그 바
            Capsule()
                .fill(Color.gray.opacity(0.3))
                .frame(width: 40, height: 5)
                .padding(.top, 8)

            // 레스토랑 이름
            Text(place.name)
                .font(.bodyLargeBold)
                .foregroundColor(.black)
                .frame(maxWidth: .infinity, alignment: .leading)

            // 레스토랑 주소
            Text(place.address)
                .font(.bodySmall)
                .foregroundColor(.natural70)
                .frame(maxWidth: .infinity, alignment: .leading)

            // Google Place 사진
            photoScrollView

            // 저장 버튼
            Button(action: {
                print("가고싶은 맛집으로 저장")
            }) {
                Text("가고싶은 맛집으로 저장")
                    .font(.bodyMediumBold)
                    .foregroundColor(.white)
//                    .frame(maxWidth: .infinity, height: 48)
                    .background(Color.primary900)
                    .cornerRadius(10)
            }
        }
        .padding(.horizontal, 20)
        .padding(.bottom, 24)
        .background(
            RoundedRectangle(cornerRadius: 20)
                .fill(Color.white)
        )
        .shadow(color: .black.opacity(0.1), radius: 8, y: -2)
    }

    // MARK: - Photo Scroll View
    private var photoScrollView: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 12) {
                if place.photoReferences.isEmpty {
                    emptyPhotoView
                } else {
                    ForEach(place.photoReferences, id: \.self) { ref in
                        AsyncImage(url: photoURL(photoReference: ref)) { phase in
                            switch phase {
                            case .success(let image):
                                image
                                    .resizable()
                                    .scaledToFill()
                            default:
                                Color.gray.opacity(0.2)
                            }
                        }
                        .frame(width: 160, height: 120)
                        .clipped()
                        .cornerRadius(10)
                    }
                }
            }
        }
    }

    private var emptyPhotoView: some View {
        ZStack {
            Color.gray.opacity(0.15)
            Image(systemName: "photo")
                .font(.system(size: 28))
                .foregroundColor(.gray)
        }
        .frame(width: 160, height: 120)
        .cornerRadius(10)
    }

    // MARK: - Google Photo URL
    private func photoURL(photoReference: String) -> URL? {
        let urlString =
        "https://maps.googleapis.com/maps/api/place/photo" +
        "?maxwidth=400" +
        "&photo_reference=\(photoReference)" +
        "&key=\(googleApiKey)"

        return URL(string: urlString)
    }
}
