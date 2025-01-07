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
                }
                
                Text("가게 이름")
                    .font(.title)
                    .fontWeight(.bold)
                    .lineLimit(1)
            }
            .padding(.horizontal)
            
            Image("MainTest")
                .resizable()
                .scaledToFit() // 비율을 유지하며 크기 조정
            
            Text("호롤롤로 / 3일전")
                .font(.subheadline)
                .foregroundColor(.gray)
                .frame(maxWidth: .infinity, alignment: .leading)

            Text("리뷰 내용 리뷰 내용 리뷰 내용 리뷰 내용 리뷰 내용 리뷰 내용 리뷰 내용 ...")
                .lineLimit(4)
                .font(.body)
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
        .cornerRadius(10)
        .padding()
        .background(BlurView())
    }
}

// 추가: 배경을 흐리게 하는 블러 효과
struct BlurView: UIViewRepresentable {
    func makeUIView(context: Context) -> UIVisualEffectView {
        let blurEffect = UIBlurEffect(style: .dark) // 어두운 블러 효과
        let blurView = UIVisualEffectView(effect: blurEffect)
        return blurView
    }
    
    func updateUIView(_ uiView: UIVisualEffectView, context: Context) {
        // 아무것도 하지 않음, 블러는 업데이트 필요 없음
    }
}

struct SheetView_Previews: PreviewProvider {
    static var previews: some View {
        MainSheetScreen()
    }
}
