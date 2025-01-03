//
//  MainAddScreen.swift
//  ChuLoop

import SwiftUI

struct MainAddScreen: View {
    @State private var restaurantName: String = ""
    @State private var address: String = ""
    @State private var review: String = ""
    @State private var selectedDate = Date()
    @State private var rating: Int = 2
    @State private var selectedCategory: String = "한식"
    
    let categories = ["한식", "일식", "중식", "양식", "아시안", "기타"]

    var body: some View {
        NavigationView {
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    // 이미지 업로드 버튼
                    HStack {
                        Button(action: {
                            // 이미지 업로드 로직
                        }) {
                            Image(systemName: "camera")
                                .resizable()
                                .frame(width: 50, height: 50)
                                .padding()
                                .background(Color.white)
                                .overlay(RoundedRectangle(cornerRadius: 10).stroke(Color.black, lineWidth: 1))
                        }
                    }
                    
                    // 맛집 이름 텍스트필드
                    TextField("맛집 이름", text: $restaurantName)
                        .padding()
                        .background(Color.white)
                        .overlay(RoundedRectangle(cornerRadius: 10).stroke(Color.black, lineWidth: 1))
                    
                    // 카테고리 선택
                    VStack(alignment: .leading, spacing: 10) {
                        ForEach(categories.chunked(into: 4), id: \.self) { row in
                            HStack {
                                ForEach(row, id: \.self) { category in
                                    Button(action: {
                                        selectedCategory = category
                                    }) {
                                        Text("# \(category)")
                                            .padding(.horizontal)
                                            .padding(.vertical, 8)
                                            .background(selectedCategory == category ? Color.black : Color.white)
                                            .foregroundColor(selectedCategory == category ? .white : .black)
                                            .cornerRadius(15)
                                            .overlay(
                                                RoundedRectangle(cornerRadius: 15)
                                                    .stroke(Color.black, lineWidth: 1)
                                            )
                                    }
                                }
                            }
                        }
                    }
                    
                    // 주소 입력
                    TextField("주소", text: $address)
                        .padding()
                        .background(Color.white)
                        .overlay(RoundedRectangle(cornerRadius: 10).stroke(Color.black, lineWidth: 1))
                    
                    // 날짜 선택
                    DatePicker("날짜", selection: $selectedDate, displayedComponents: .date)
                        .datePickerStyle(CompactDatePickerStyle())
                        .labelsHidden()
                        .padding()
                        .background(Color.white)
                        .overlay(RoundedRectangle(cornerRadius: 10).stroke(Color.black, lineWidth: 1))

                    // 별점
                    HStack {
                        Text("평점 \(rating).0")
                        HStack(spacing: 5) {
                            ForEach(1...5, id: \.self) { star in
                                Image(systemName: star <= rating ? "star.fill" : "star")
                                    .foregroundColor(star <= rating ? .red : .gray)
                                    .onTapGesture {
                                        rating = star
                                    }
                            }
                        }
                    }
                    
                    // 리뷰 작성
                    VStack(alignment: .leading) {
                        Text("리뷰")
                            .font(.headline)
                        TextEditor(text: $review)
                            .frame(height: 100)
                            .padding()
                            .background(Color.white)
                            .overlay(RoundedRectangle(cornerRadius: 10).stroke(Color.black, lineWidth: 1))
                            .overlay(
                                VStack {
                                    if review.isEmpty {
                                        Text("식사 후 느꼈던 점을 적어보세요.")
                                            .foregroundColor(.gray)
                                            .padding(.horizontal, 8)
                                            .padding(.vertical, 12)
                                    }
                                    Spacer()
                                }
                            )
                    }
                    
                    // 저장 버튼
                    HStack {
                        Spacer()
                        Button(action: {
                            // 저장 로직
                        }) {
                            Text("저장하기")
                                .padding(.horizontal, 20)
                                .padding(.vertical, 10)
                                .background(Color.blue)
                                .foregroundColor(.white)
                                .cornerRadius(10)
                        }
                    }
                }
                .padding()
            }
            .navigationTitle("맛집 리뷰 작성")
            .navigationBarTitleDisplayMode(.inline)
            .background(Color.white)
        }
    }
}

extension Array {
    func chunked(into size: Int) -> [[Element]] {
        var chunks: [[Element]] = []
        for index in stride(from: 0, to: count, by: size) {
            let chunk = Array(self[index..<Swift.min(index + size, count)])
            chunks.append(chunk)
        }
        return chunks
    }
}

#Preview {
    MainAddScreen()
}
