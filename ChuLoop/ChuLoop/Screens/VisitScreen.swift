//
//  VisitScreen.swift
//  ChuLoop
//

import SwiftUI

struct VisitScreen: View {
    @State private var visitPlaces: [VisitPlace] = [
        VisitPlace(image: "placeholder", name: "맛집이름은 여기에", address: "인천광역시 나나구 가좌동 예술로 80 대찬병원빌딩 1층 102호", category: "한식"),
        VisitPlace(image: "placeholder", name: "또 다른 맛집", address: "서울특별시 강남구 테헤란로 20", category: "양식"),
        VisitPlace(image: "placeholder", name: "또 다른 맛집", address: "서울특별시 강남구 테헤란로 20", category: "양식"),
        VisitPlace(image: "placeholder", name: "또 다른 맛집", address: "서울특별시 강남구 테헤란로 20", category: "양식")
    ]
    
    @State private var searchText: String = ""
    @State private var isSecondPage: Bool = false
    
    var body: some View {
        MainNavigationView(title: "방문할 맛집", content: {
            VStack(spacing: 0) {
                // 검색창
                SearchBar(searchText: $searchText)
                    .padding(.horizontal)
                    .padding(.top)
                Spacer()

                // 리스트 또는 빈 화면
                if visitPlaces.isEmpty {
                    VStack {
                        Spacer()
                        Text("방문할 맛집 리스트가 비어있어요\n방문하고싶은 맛집을 추가해 주세요")
                            .font(.bodyMedium)
                            .multilineTextAlignment(.center)
                            .foregroundColor(.gray)
                            .padding()
                        Spacer()
                    }
                } else {
                    ScrollView {
                        ForEach(visitPlaces, id: \.id) { place in
                            HStack {
                                Image(systemName: "photo")
                                    .resizable()
                                    .frame(width: 80, height: 80)
                                    .foregroundColor(.gray)
                                    .padding(5)
                                
                                VStack(alignment: .leading, spacing: 5) {
                                    HStack {
                                        Text(place.name)
                                            .font(.bodySmallBold)
                                            .lineLimit(1)
                                        Spacer()
                                        Text(place.category)
                                            .font(.bodyXXSmall)
                                            .foregroundColor(.gray)
                                    }
                                    Text(place.address)
                                        .font(.bodyXSmall)
                                        .foregroundColor(.gray)
                                        .lineLimit(2)
                                    
                                    Button(action: {
                                        print("\(place.name) 리뷰 쓰기 버튼 눌림")
                                    }) {
                                        Text("리뷰쓰기")
                                            .font(.bodySmall)
                                            .foregroundColor(.white)
                                            .padding(.horizontal, 10)
                                            .padding(.vertical, 5)
                                            .background(Color.blue)
                                            .cornerRadius(5)
                                    }
                                }
                                Spacer()
                            }
                            .padding()
                            .background(
                                RoundedRectangle(cornerRadius: 10)
                                    .stroke(Color.gray.opacity(0.3), lineWidth: 1)
                            )
                            .padding(.horizontal)
                            .padding(.vertical, 5)
                        }
                    }
                }
            }
        }, onAddButtonTapped: {
            print("NavigationView Button Test")
        }, isSecondPage: $isSecondPage, secondPage: {
            
        })
         
    }
}

// 임시 데이터 모델
struct VisitPlace: Identifiable {
    let id = UUID()
    let image: String
    let name: String
    let address: String
    let category: String
}

#Preview {
    VisitScreen()
}
