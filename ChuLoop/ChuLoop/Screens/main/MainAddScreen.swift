//
//  MainAddScreen.swift
//  ChuLoop

import SwiftUI

struct MainAddScreen: View {
    @ObservedObject var controller = MainAddScreenController()
    @ObservedObject var mainController = MainScreenController()
   
    
    let category1 = ["한식", "일식", "중식", "양식"]
    let category2 = ["아시안", "기타"]
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    // 이미지 업로드 버튼
                    HStack {
                        Button(action: {
                            // 이미지 업로드 로직
                        }) {
                            ImageView(imageName: "camera", width: 50, height: 40)
                                .frame(width: 50, height: 50)
                                .padding()
                                .background(Color.white)
                                .overlay(RoundedRectangle(cornerRadius: 10).stroke(Color.natural80, lineWidth: 2))
                        }
                    }
                    
                    // 맛집 이름 텍스트필드
                    CTextField(placeholder: "맛집 이름", text: $controller.restaurantName, textIsEmpty: $controller.titleEmpty, errorText: "맛집 이름을 적어주세요")
                    
                    // 카테고리 선택 1
                    HStack(spacing: 10) {
                        ForEach(category1, id: \.self) { category in
                            Button(action: {
                                controller.selectedCategory = category
                            }) {
                                CategoryButton(category: category, selectedCategory: controller.selectedCategory)
                            }
                        }
                    }
                    
                    // 카테고리 선택 2
                    HStack(spacing: 10) {
                        ForEach(category2, id: \.self) { category in
                            Button(action: {
                                controller.selectedCategory = category
                            }) {
                                CategoryButton(category: category, selectedCategory: controller.selectedCategory)
                            }
                        }
                    }
                    
                    // 주소 입력
                    CTextField(placeholder: "주소", text: $controller.address, textIsEmpty: $controller.addressEmpty, errorText: "주소를 입력해 주세요")
                    // 날짜 선택
                    DatePicker("날짜", selection: $controller.selectedDate, displayedComponents: .date)
                        .datePickerStyle(CompactDatePickerStyle())
                        .labelsHidden()
                        .padding()
                        .background(Color.white)
                        .overlay(RoundedRectangle(cornerRadius: 10).stroke(Color.black, lineWidth: 1))
                    
                    // 별점
                    VStack(alignment: .leading) {
                        HStack(spacing: 3) {
                            Text("평점")
                                .font(.bodyNormal)
                            Text("\(controller.rating).0")
                                .font(.bodySmall)
                        }
                        HStack(spacing: 5) {
                            ForEach(1...5, id: \.self) { star in
                                ImageView(imageName: star <= controller.rating ? "star-fill" : "star", width: 24, height: 24)
                                    .onTapGesture {
                                        controller.rating = star
                                    }
                            }
                        }
                    }
                    
                    // 리뷰 작성
                    VStack(alignment: .leading, spacing: 15) {
                        Text("리뷰")
                            .font(.bodyNormal)
                        CTextEditor(placeholder: "식사 후 느꼈던 점을 적어보세요.", text: $controller.review, textIsEmpty: $controller.reviewEmpty, errorText: "리뷰를 적어주세요.")
                    }
                    
                    
                    // 저장 버튼
                    HStack {
                        Spacer()
                        Button(action: {
                            // 저장 로직
                            controller.submit()
                            
                        }) {
                            Text("저장하기")
                                .font(.heading4)
                                .padding(.horizontal, 20)
                                .padding(.vertical, 10)
                                .background(Color.primary900)
                                .foregroundColor(.white)
                                .cornerRadius(12)
                        }
                    }
                }
                .padding(.horizontal, 24)
                .padding(.vertical, 28)
            }
            .background(Color.primary50.ignoresSafeArea()) // 🔹 전체 배경색 변경
            .navigationBarBackButtonHidden(true)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                // 커스텀 뒤로가기 버튼
                ToolbarItem(placement: .topBarTrailing) {
                    Button(action: {
                        mainController.goBack() // 뒤로 가기
                    }) {
                        ImageView(imageName: "closes", width: 16, height: 16)
                    }
                }
                // 타이틀
                ToolbarItem(placement: .principal) {
                    Text("맛집 리뷰 작성")
                        .font(Font.bodyLargeBold)
                        .foregroundColor(.black)
                }
            }
            .toolbarBackground(Color.mobileGray, for: .navigationBar)
            .toolbarBackground(.visible, for: .navigationBar)
        }
    }
}

#Preview {
    MainAddScreen()
}


struct CategoryButton: View {
    let category: String
    var selectedCategory: String
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 12)
                .fill(selectedCategory == category ? Color.natural80 : Color.white) // 배경 색 적용
                .stroke(selectedCategory == category ? Color.natural80 : Color.natural50, lineWidth: 1)
            Text("# \(category)")
                .font(.bodyNormal)
                .foregroundColor(selectedCategory == category ? .natural10 : .natural90)
                .padding(10)
        }
        .fixedSize()
    }
}
