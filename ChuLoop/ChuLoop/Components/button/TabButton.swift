//
//  CButton.swift
//  ChuLoop
//
//  Created by Anna Kim on 3/4/25.
//
import SwiftUI

struct TabButton: View {
    let title: String
    let imageName: String
    let isSelected: Bool
    let paddingValues: EdgeInsets? // ✅ Optional로 수정
    let action: () -> Void

    init(
        title: String,
        imageName: String,
        isSelected: Bool,
        paddingValues: EdgeInsets? = EdgeInsets(
            top: ResponsiveSize.width(15),
            leading: ResponsiveSize.width(12.5),
            bottom: 0,
            trailing: ResponsiveSize.width(12.5)
        ),
        action: @escaping () -> Void
    ) {
        self.title = title
        self.imageName = imageName
        self.isSelected = isSelected
        self.paddingValues = paddingValues // ✅ Optional로 처리
        self.action = action
    }

    var body: some View {
        VStack(spacing: ResponsiveSize.height(8)) {
            ImageView(imageName: imageName,
                      width: ResponsiveSize.width(24),
                      height: ResponsiveSize.width(24))

            Text(title)
                .foregroundColor(isSelected ? .primary500 : .natural70)
                .font(.bodyXXSmall)
                .frame(width: ResponsiveSize.width(60), alignment: .center)
        }
        .padding(paddingValues ?? EdgeInsets()) // ✅ Optional 처리
        .contentShape(Rectangle()) // ✅ 터치 영역 확장
        .onTapGesture {
            action() // ✅ 클릭 이벤트 실행
        }
    }
}
