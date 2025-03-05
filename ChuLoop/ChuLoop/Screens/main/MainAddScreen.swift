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
                VStack(alignment: .leading) {
                    
                    // 이미지 업로드 버튼
                    ImageListView(controller: self.controller)
                    Spacer(minLength: ResponsiveSize.height(24))
                    // 맛집 이름 텍스트필드
                    CTextField(placeholder: "맛집 이름", text: $controller.restaurantName, textIsEmpty: $controller.titleEmpty, errorText: "맛집 이름을 적어주세요")
                    Spacer(minLength: ResponsiveSize.height(34))
                    // 카테고리 선택 1
                    HStack(spacing: ResponsiveSize.width(10)) {
                        ForEach(category1, id: \.self) { category in
                            Button(action: {
                                controller.selectedCategory = category
                            }) {
                                CategoryButton(category: category, selectedCategory: controller.selectedCategory)
                            }
                        }
                    }
                    
                    // 카테고리 선택 2
                    HStack(spacing: ResponsiveSize.width(10)) {
                        ForEach(category2, id: \.self) { category in
                            Button(action: {
                                controller.selectedCategory = category
                            }) {
                                CategoryButton(category: category, selectedCategory: controller.selectedCategory)
                            }
                        }
                    }
                    Spacer(minLength: ResponsiveSize.height(24))
                    // 주소 입력
                    CTextField(placeholder: "주소", text: $controller.address, textIsEmpty: $controller.addressEmpty, errorText: "주소를 입력해 주세요")
                    Spacer(minLength: ResponsiveSize.height(34))
                    // 날짜 선택
                    VStack {
                        CTextField(placeholder: controller.selectedDate, text: $controller.selectedDate, textIsEmpty: $controller.dateEmpty,
                                   onTap: {
                            controller.showDatePicker.toggle()
                        },
                                   readonly: true)
                        
                    }
                    Spacer(minLength: ResponsiveSize.height(24))
                    
                    // 별점
                    VStack(alignment: .leading) {
                        HStack(spacing: ResponsiveSize.width(3)) {
                            Text("평점")
                                .font(.bodyNormal)
                            Text("\(controller.rating).0")
                                .font(.bodySmall)
                        }
                        HStack(spacing: ResponsiveSize.width(5)) {
                            ForEach(1...5, id: \.self) { star in
                                ImageView(imageName: star <= controller.rating ? "star-fill" : "star", width: ResponsiveSize.width(24), height: ResponsiveSize.height(24))
                                    .onTapGesture {
                                        controller.rating = star
                                    }
                            }
                        }
                    }
                    Spacer(minLength: ResponsiveSize.height(24))
                    // 리뷰 작성
                    VStack(alignment: .leading, spacing: ResponsiveSize.height(15)) {
                        Text("리뷰")
                            .font(.bodyNormal)
                        CTextEditor(placeholder: "식사 후 느꼈던 점을 적어보세요.", text: $controller.review, textIsEmpty: $controller.reviewEmpty, errorText: "리뷰를 적어주세요.")
                    }
                    
                    Spacer(minLength: ResponsiveSize.height(24))
                    // 저장 버튼
                    HStack {
                        Spacer()
                        Button(action: {
                            // 저장 로직
                            controller.submit(mainController: mainController)
                            
                        }) {
                            Text("저장하기")
                                .font(.heading4)
                                .padding(.horizontal, ResponsiveSize.width(20))
                                .padding(.vertical, ResponsiveSize.height(10))
                                .background(Color.primary900)
                                .foregroundColor(.white)
                                .cornerRadius(12)
                        }
                        
                    }
                    Spacer(minLength: ResponsiveSize.height(24))
                }
                .padding(.horizontal, ResponsiveSize.width(24))
                .padding(.top, ResponsiveSize.height(20))
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
                        ImageView(imageName: "closes", width: ResponsiveSize.width(16), height: ResponsiveSize.height(16))
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
            // 🔹 날짜 선택
            .sheet(isPresented: $controller.showDatePicker, content: {
                VStack {
                    DatePicker("날짜", selection: $controller.date, displayedComponents: .date)
                        .datePickerStyle(WheelDatePickerStyle())
                        .labelsHidden()
                    
                    Button(action: {
                        controller.selectedDate = formatdotYYYYMMDDEEE(controller.date)
                        controller.showDatePicker = false
                    }) {
                        Text("적용")
                            .font(.bodyNormal)
                            .foregroundColor(.white)
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(Color.primary900)
                            .cornerRadius(8)
                    }
                    .padding(.top, ResponsiveSize.height(16)) // 위쪽 여백 추가
                }
                .padding(.horizontal, ResponsiveSize.width(24)) // 좌우 여백 추가
                .padding(.vertical, ResponsiveSize.height(20))  // 상하 여백 추가
                
                .cornerRadius(26)
                .presentationDetents([.fraction(0.45)]) // 이로 인해
            })
            // 🔹 이미지 선택
            .sheet(isPresented: $controller.openPhoto) {
                ImagePicker(sourceType: .photoLibrary, selectedImage: $controller.images, selectedData: $controller.selectedData)
            }
            
        }
//        .toolbar(.hidden, for: .tabBar) // ✅ TabView를 숨김
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
                .padding(ResponsiveSize.width(10))
        }
        .fixedSize()
    }
}


struct ImageListView: View {
    @ObservedObject var controller = MainAddScreenController()
    
    var body: some View {
        HStack(alignment: .bottom) {
            Button(action: {
                // 이미지 업로드 로직
                controller.openPhoto.toggle()
            }) {
                RoundedRectangle(cornerRadius: 10)
                    .stroke(controller.imageEmpty ? Color.error : Color.natural80, lineWidth: 2)
                    .frame(width: ResponsiveSize.width(100), height: ResponsiveSize.height(100))
                    .foregroundColor(.white)
                    .overlay {
                        ImageView(imageName: "camera", width: ResponsiveSize.height(50), height: ResponsiveSize.height(40))
                    }
            }
            .padding(.trailing, ResponsiveSize.width(2))
            
            // 이미지 리스트 (가로스크롤)
            ScrollView(.horizontal) {
                HStack {
                    ForEach(controller.images.indices, id: \.self) { index in
                        RoundedRectangle(cornerRadius: 10)
                            .fill(.clear)
                            .frame(width: ResponsiveSize.width(108), height: ResponsiveSize.height(108), alignment: .bottomLeading)
                            .overlay(alignment: .bottomLeading) {
                                ZStack(alignment: .topTrailing) {
                                    Image(uiImage: controller.images[index])
                                        .resizable()
                                        .scaledToFill() // 🔹 꽉 차게 채우기
                                        .frame(width: ResponsiveSize.width(100), height: ResponsiveSize.height(100))
                                        .clipShape(RoundedRectangle(cornerRadius: 10)) // 🔹 넘치는 부분 자르기
                                        .clipped()
                                }
                                Button(action: {
                                    controller.images.remove(at: index) // 삭제 기능 추가 가능
                                }) {
                                    ImageView(imageName: "close-circle", width: ResponsiveSize.width(20), height: ResponsiveSize.height(20))
                                }
                                .offset(x: 50, y: -47)
                            }
                    }
                }
            }
            
            
        }
        .frame(height: ResponsiveSize.height(108), alignment: .bottom)
    }
}
