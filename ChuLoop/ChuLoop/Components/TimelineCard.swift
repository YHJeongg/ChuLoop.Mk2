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
//            Image(uiImage: UIImage(data: Data(base64Encoded: item.images)!)!)
            if let base64String = item.images.first,
               let imageData = Data(base64Encoded: base64String),
               let uiImage = UIImage(data: imageData) {
                Image(uiImage: uiImage)
                    .resizable()
                    .scaledToFill()
                    .frame(height: 200)
                    .clipped()
                    .cornerRadius(10)
                    .onTapGesture {
                        showSheet.toggle()
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
