//
//  WillDirectionsSheetScreen.swift
//  ChuLoop
//

import SwiftUI

struct WillDirectionsSheetScreen: View {
    var place: WillModel

    var body: some View {
        VStack {
            Text("지도 앱에서 길찾기")
                .font(.bodyNormal)
                .padding(.top, 20)

            HStack {
                mapButton(
                    for: "카카오맵",
                    urlString: "kakaomap://route?sp=\(place.address)",
                    fallbackAppStoreURL: "itms-apps://itunes.apple.com/app/id304608425",  // 카카오맵 앱스토어 링크
                    imageName: "kakao_map_icon"
                )
                mapButton(
                    for: "네이버맵",
                    urlString: "nmap://navigate?query=\(place.address)",
                    fallbackAppStoreURL: "itms-apps://itunes.apple.com/app/id311867728",  // 네이버맵 앱스토어 링크
                    imageName: "naver_map_icon"
                )
                mapButton(
                    for: "애플맵",
                    urlString: "maps.apple.com/?q=\(place.address)",
                    fallbackAppStoreURL: "",  // 애플맵은 기본 앱이라 fallback 불필요
                    imageName: "apple_map_icon"
                )
            }
            .padding(.bottom, 20)
        }
    }

    func mapButton(for title: String, urlString: String, fallbackAppStoreURL: String, imageName: String) -> some View {
        Button(action: {
            if let url = URL(string: urlString) {
                if UIApplication.shared.canOpenURL(url) {
                    // 해당 앱이 설치되어 있으면 해당 앱 열기
                    UIApplication.shared.open(url)
                } else if !fallbackAppStoreURL.isEmpty, let fallback = URL(string: fallbackAppStoreURL) {
                    // 앱이 없으면 앱스토어 링크로 이동
                    UIApplication.shared.open(fallback)
                }
            }
        }) {
            VStack {
                if let image = UIImage(named: imageName) {
                    Image(uiImage: image)
                        .resizable()
                        .frame(width: 40, height: 40)
                } else {
                    Text("Image not found")
                        .foregroundColor(.gray)
                }

                Text(title)
                    .foregroundColor(.black)
                    .font(.bodySmall)
            }
            .frame(width: 80)
        }
    }
}
