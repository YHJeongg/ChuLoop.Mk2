//
//  TimelineCard.swift
//  ChuLoop
//

import SwiftUI

struct TimelineCard: View {
    @Binding var item: MainModel
    @Binding var showSheet: Bool
    
    var body: some View {
        VStack {
            // 이미지
            if let imageUrl = URL(string: item.images.first ?? "") {
                AsyncImage(url: imageUrl) { phase in
                    switch phase {
                    case .empty:
                        ProgressView()
                            .frame(height: 250)
                    case .success(let image):
                        image.resizable()
                            .scaledToFill()
                            .frame(height: 250)
                            .clipped()
                            .onTapGesture {
                                showSheet.toggle()
                            }
                    case .failure:
                        Image(systemName: "photo")
                            .resizable()
                            .scaledToFit()
                            .frame(height: 200)
                            .foregroundColor(.gray)
                    @unknown default:
                        EmptyView()
                    }
                }
            }
            
            VStack(alignment: .leading, spacing: 1) {
                // 타이틀 + 날짜
                HStack {
                    Text(item.title)
                        .font(.bodyMediumBold)
                        .foregroundColor(.natural90)
                        .lineLimit(1)
                    
                    Spacer()
                    
                    Text(item.date)
                        .font(.bodySmall)
                        .foregroundColor(.natural60)
                }
                
                // 주소
                Text(item.address)
                    .font(.bodyXSmall)
                    .foregroundColor(.natural60)
                    .padding(.bottom, 20)
                
                // 별점 + 공유 토글
                HStack {
                    HStack(spacing: 4) {
                        Image(systemName: "star.fill")
                            .foregroundColor(.error)
                            .font(.caption)
                        
                        Text(String(format: "%.1f", item.rating))
                            .font(.bodyXSmall)
                    }
                    
                    Spacer()
                    
                    HStack {
                        Text("커뮤니티에 공유하기")
                            .font(.bodySmall)
                            .foregroundColor(.natural80)
                        
                        Toggle("", isOn: $item.shared)
                            .labelsHidden()
                    }
                }
            }
            .padding(12)
        }
        .background(Color.primary50)
        .cornerRadius(5)
        .overlay(
            RoundedRectangle(cornerRadius: 5)
                .stroke(Color.natural60, lineWidth: 0.5)
        )
    }
}
