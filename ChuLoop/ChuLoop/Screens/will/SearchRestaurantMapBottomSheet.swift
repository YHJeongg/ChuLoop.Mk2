//
//  SearchRestaurantMapBottomSheet.swift
//  ChuLoop
//

import SwiftUI

struct SearchRestaurantMapBottomSheet: View {
    @StateObject private var controller = WillScreenController()
    let place: Place
    let googleApiKey: String
    
    var onAddressTap: (WillModel) -> Void // 부모 뷰로 이벤트를 전달하기 위해 추가
    var onSaveSuccess: () -> Void // 저장 성공 시 부모뷰에 알릴 용도

    var body: some View {
        // 메인 컨텐츠
        VStack(spacing: ResponsiveSize.height(20)) {

            // 레스토랑 이름
            Text(place.name)
                .font(.bodyMediumBold)
                .foregroundColor(.natural90)
                .frame(maxWidth: .infinity, alignment: .leading)

            // 사진 + 주소
            HStack(alignment: .center, spacing: ResponsiveSize.width(15)) {

                restaurantImage

                // 주소 클릭 시 부모 뷰의 팝업 트리거 실행
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

            // 저장 버튼
            Button(action: {
                controller.saveWillPost(place: place) { success in
                    if success {
                        onSaveSuccess()
                    }
                }
            }) {
                Text("가고싶은 맛집으로 저장")
                    .font(.bodyMedium)
                    .foregroundColor(.natural10)
                    .frame(
                        maxWidth: ResponsiveSize.width(382),
                        maxHeight: ResponsiveSize.height(50)
                    )
                    .background(Color.primary900)
                    .cornerRadius(10)
            }
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
                    default:
                        Color.gray.opacity(0.3)
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
