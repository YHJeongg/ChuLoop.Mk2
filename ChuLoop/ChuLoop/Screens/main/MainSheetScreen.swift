//
//  MainSheetScreen.swift
//  ChuLoop
//

import SwiftUI

struct MainSheetScreen: View {
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        ZStack {
            VStack(spacing: 20) {
                HStack {
                    Button(action: {
                        dismiss()
                    }) {
                        Image(systemName: "xmark")
                            .font(.title)
                            .foregroundColor(.white)
                    }
                    
                    Spacer()
                    
                    Text("가게 이름")
                        .font(.CookieBold20)
                        .fontWeight(.bold)
                        .lineLimit(1)
                        .foregroundColor(.white)
                    
                    Spacer()
                    
                    Text("1 / 10")
                        .font(.Cookie16)
                        .foregroundColor(.white)
                }
                .padding()
                
                Image("MainTest")
                    .resizable()
                    .scaledToFit()
                
                VStack(alignment: .leading, spacing: 8) {
                    Text("호롤롤로 / 3일전")
                        .font(.Cookie18)
                        .foregroundColor(.white)
                    
                    Text("리뷰 내용 리뷰 내용 리뷰 내용 리뷰 내용 리뷰 내용 리뷰 내용 리뷰 내용 리뷰 내용 리뷰 내용 리뷰 내용 리뷰 내용 리뷰 내용 리뷰 내용 ...")
                        .lineLimit(4)
                        .font(.Cookie16)
                        .foregroundColor(.white)
                    
                    Button(action: {
                        print("더보기 버튼 클릭")
                    }) {
                        Text("더보기")
                            .font(.CookieBold14)
                            .foregroundColor(.blue)
                    }
                }
                .padding()
                
                Spacer()
            }
            .padding()
        }
        .background(Color.black.opacity(0.8))
    }
}

struct ClearBackgroundView: UIViewRepresentable {
    func makeUIView(context: Context) -> UIView {
        let view = UIView()
        DispatchQueue.main.async {
            view.superview?.superview?.backgroundColor = .clear
        }
        return view
    }
    
    func updateUIView(_ uiView: UIView, context: Context) {}
}

struct ClearBackgroundViewModifier: ViewModifier {
    func body(content: Content) -> some View {
        if #available(iOS 16.4, *) {
            content
                .presentationBackground(.clear)
        } else {
            content
                .background(ClearBackgroundView())
        }
    }
}

extension View {
    func clearModalBackground()->some View {
        self.modifier(ClearBackgroundViewModifier())
    }
}

struct MainSheetScreen_Previews: PreviewProvider {
    static var previews: some View {
        MainSheetScreen()
    }
}
