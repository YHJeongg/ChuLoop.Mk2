//
//  TimelineCard.swift
//  ChuLoop
//

import SwiftUI

struct TimelineCard: View {
    @Binding var item: MainModel
    @Binding var showSheet: Bool
    
    var body: some View {
        VStack(alignment: .leading) {
            if let imageUrl = URL(string: item.images.first ?? "") {
                AsyncImage(url: imageUrl) { phase in
                    switch phase {
                    case .empty:
                        ProgressView() // 로딩 중 표시
                            .frame(height: 200)
                    case .success(let image):
                        image.resizable()
                            .scaledToFill()
                            .frame(height: 200)
                            .clipped()
                            .cornerRadius(10)
                            .onTapGesture {
                                showSheet.toggle()
                            }
                    case .failure:
                        Image(systemName: "MainTest2") // 로드 실패 시 기본 이미지
                            .resizable()
                            .scaledToFit()
                            .frame(height: 200)
                            .foregroundColor(.gray)
                    @unknown default:
                        EmptyView()
                    }
                }
            }
            
            VStack(alignment: .leading, spacing: 10) {
                Text(item.title)
                    .font(.bodyMediumBold)
                    .lineLimit(1)
                
                Text(item.address)
                    .font(.bodyXSmall)
                    .foregroundColor(.black)
                
                HStack {
                    Text("\(item.date)")
                        .font(.bodySmall)
                        .foregroundColor(.black)
                    
                    Spacer()
                    
                    HStack(spacing: 4) {
                        Image(systemName: "star.fill")
                            .foregroundColor(.red)
                            .font(.caption)
                        
                        Text(String(format: "%.1f", item.rating))
                            .font(.caption)
                    }
                }
                
                HStack {
                    Text("커뮤니티에 공유하기")
                        .font(.bodySmall)
                        .foregroundColor(.black)
                    
                    Spacer()
                    
                    Toggle("", isOn: $item.shared)
                        .labelsHidden()
                }
            }
            .padding()
        }
        .background(Color.white)
        .cornerRadius(15)
        .shadow(color: Color.gray.opacity(0.2), radius: 5, x: 0, y: 2)
    }
}
