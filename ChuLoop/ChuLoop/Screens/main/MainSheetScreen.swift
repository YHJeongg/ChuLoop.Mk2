//
//  MainSheetScreen.swift
//  ChuLoop
//

import SwiftUI

struct MainSheetScreen: View {
    @Environment(\.dismiss) var dismiss  // dismiss 환경 객체 추가
    
    var body: some View {
        VStack(spacing: 20) {
            HStack {
                Button(action: {
                    dismiss()  // 버튼 클릭 시 sheet 닫기
                }) {
                    Image(systemName: "xmark")
                        .font(.title)
                        .foregroundColor(.black)
                        .padding()
                }

                Spacer()
                
                Text("가게 이름")
                    .font(.title)
                    .fontWeight(.bold)
                    .lineLimit(1)
                
                Spacer()
            }
            .padding(.horizontal)
            
            Image("MainTest")
                .resizable()
                .scaledToFit() // 비율을 유지하며 크기 조정
//                .frame(width: 100, height: 100)
            
            Text("호롤롤로 / 3일전")
                .font(.subheadline)
                .foregroundColor(.gray)
                .frame(maxWidth: .infinity, alignment: .leading)

            Text("리뷰 내용 리뷰 내용 리뷰 내용 리뷰 내용 리뷰 내용 리뷰 내용 리뷰 내용 ...")
                .lineLimit(4)
                .font(.body)
//                .padding()
                .frame(maxWidth: .infinity, alignment: .leading)

            Button(action: {
                // "더보기" 버튼 클릭 동작
                print("더보기 버튼 클릭")
            }) {
                Text("더보기")
                    .font(.headline)
                    .foregroundColor(.blue)
                    .frame(maxWidth: .infinity, alignment: .leading)  // 왼쪽 정렬
            }
        }
        .padding()
    }
}

struct SheetView_Previews: PreviewProvider {
    static var previews: some View {
        MainSheetScreen()
    }
}
