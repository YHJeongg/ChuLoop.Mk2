//
//  MapDirectionSheet.swift
//  ChuLoop
//

import SwiftUI

struct MapDirectionSheet: View {
    let title: String
    let address: String
    var onCopy: (() -> Void)? = nil

    var body: some View {
        VStack(spacing: 0) {
            // 주소 복사 섹션
            Button(action: {
                UIPasteboard.general.string = address
                onCopy?()
            }) {
                HStack(spacing: 10) {
                    Image(systemName: "doc.on.doc")
                        .font(.bodySmall)
                    
                    Text("주소만 복사")
                        .font(.bodyNormal)
                    
                    Spacer()
                }
                .foregroundColor(.black)
                .padding(.vertical, ResponsiveSize.height(35))
            }

            // 지도 앱 버튼 섹션
            HStack(spacing: ResponsiveSize.width(25)) {
                mapButton(
                    for: "카카오맵",
                    urlString: "kakaomap://route?sp=\(address)",
                    fallbackAppStoreURL: "itms-apps://itunes.apple.com/app/id304608425",
                    imageName: "kakao_map_icon"
                )
                mapButton(
                    for: "네이버맵",
                    urlString: "nmap://navigate?query=\(address.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? "")",
                    fallbackAppStoreURL: "itms-apps://itunes.apple.com/app/id311867728",
                    imageName: "naver_map_icon"
                )
                mapButton(
                    for: "애플맵",
                    urlString: "maps.apple.com/?q=\(address.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? "")",
                    fallbackAppStoreURL: "",
                    imageName: "apple_map_icon"
                )
            }
            .padding(.bottom, ResponsiveSize.height(40))
        }
        .padding(.horizontal, ResponsiveSize.width(24))
        .frame(maxWidth: .infinity)
    }

    // 지도 앱 실행 로직
    private func mapButton(for title: String, urlString: String, fallbackAppStoreURL: String, imageName: String) -> some View {
        Button(action: {
            if let url = URL(string: urlString) {
                if UIApplication.shared.canOpenURL(url) {
                    UIApplication.shared.open(url)
                } else if !fallbackAppStoreURL.isEmpty, let fallback = URL(string: fallbackAppStoreURL) {
                    UIApplication.shared.open(fallback)
                }
            }
        }) {
            VStack(spacing: 8) {
                ImageView(
                    imageName: imageName,
                    width: ResponsiveSize.width(50),
                    height: ResponsiveSize.height(50)
                )
                .cornerRadius(12)

                Text(title)
                    .foregroundColor(.black)
                    .font(.bodySmall)
            }
        }
    }
}
