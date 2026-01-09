//
//  SearchRestaurantMapBottomSheet.swift
//  ChuLoop
//

import SwiftUI

struct SearchRestaurantMapBottomSheet: View {
    let place: Place
    let googleApiKey: String

    var body: some View {
        VStack(spacing: ResponsiveSize.height(25)) {

            // 레스토랑 이름
            Text(place.name)
                .font(.bodyMediumBold)
                .foregroundColor(.natural90)
                .frame(maxWidth: .infinity, alignment: .leading)

            // 레스토랑 주소
            Text(place.address)
                .font(.bodyNormal)
                .foregroundColor(.natural80)
                .frame(maxWidth: .infinity, alignment: .leading)

            // Google Place 사진
            photoScrollView

            // 저장 버튼
            Button(action: {
                print("가고싶은 맛집으로 저장")
            }) {
                Text("가고싶은 맛집으로 저장")
                    .font(.bodyMedium)
                    .foregroundColor(.natural10)
                    .frame(maxWidth: ResponsiveSize.width(382), maxHeight: ResponsiveSize.height(50))
                    .background(Color.primary900)
                    .cornerRadius(10)
            }
        }
        .padding(.horizontal, ResponsiveSize.width(30))
        .frame(maxWidth: ResponsiveSize.width(430), maxHeight: ResponsiveSize.height(333))
        .background(
            RoundedRectangle(cornerRadius: 25)
                .fill(Color.white)
        )
    }

    // MARK: - Photo Scroll View
    private var photoScrollView: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: ResponsiveSize.width(15)) {
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
                                Color.gray.opacity(0.5)
                            }
                        }
                        .frame(width: ResponsiveSize.width(80), height: ResponsiveSize.height(80))
                        .clipped()
                        .cornerRadius(10)
                    }
                }
            }
        }
    }

    private var emptyPhotoView: some View {
        ZStack {
            Color.gray.opacity(0.5)
            Image(systemName: "photo")
                .font(.system(size: 28))
                .foregroundColor(.gray)
        }
        .frame(width: ResponsiveSize.width(80), height: ResponsiveSize.height(80))
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
