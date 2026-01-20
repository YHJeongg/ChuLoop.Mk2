//
//  WillController.swift
//  ChuLoop
//

import Foundation
import Combine

class WillScreenController: ObservableObject {
    @Published var contents: [WillModel] = []
    @Published var isLoading: Bool = false
    @Published var hasMorePages: Bool = true
    
    private var page: Int = 1
    private let limit: Int = 5
    private let willService = WillService()

    func getWillPosts(searchText: String = "", isRefreshing: Bool = false) {
        // 중복 호출 방지 + 데이터가 더 없으면 요청 중단
        guard !isLoading, hasMorePages || isRefreshing else { return }

        if isRefreshing {
            page = 1
            hasMorePages = true
            contents.removeAll()
        }

        isLoading = true

        Task { @MainActor in
            let queryParameters: [String: String] = [
                "searchWord": searchText,
                "page": "\(page)",
                "limit": "\(limit)"
            ]

            // WillService에서 데이터를 가져옴
            let response = await willService.fetchWillPosts(queryParameters: queryParameters)

            // 실패시 처리
            guard response.success else {
                print("데이터 요청 실패: \(response.message ?? "알 수 없는 오류")")
                isLoading = false
                return
            }

            if let data = response.data {
                do {
                    let jsonData = try JSONSerialization.data(withJSONObject: data)

                    let willResponse = try JSONDecoder().decode(WillResponseModel.self, from: jsonData)

                    DispatchQueue.main.async {
                        if isRefreshing {
                            self.contents = willResponse.contents
                        } else {
                            self.contents.append(contentsOf: willResponse.contents)
                        }
                        
                        // 더 이상 데이터가 없으면 페이징 중지
                        self.hasMorePages = willResponse.contents.count == self.limit
                        if self.hasMorePages { self.page += 1 }
                        self.isLoading = false
                    }
                } catch {
                    print("디코딩 오류: \(error)")
                    isLoading = false
                }
            } else {
                isLoading = false
            }
        }
    }
    
    // 음식점 정보 GPlace에서 불러오기
    func GooglePlace(keyword: String, completion: @escaping ([Place]) -> Void) {
        guard let apiKey = Bundle.main.infoDictionary?["GOOGLE_PLACE"] as? String else {
            print("API Key가 없습니다.")
            completion([])
            return
        }

        let query = keyword.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
        let urlStr =
        "https://maps.googleapis.com/maps/api/place/textsearch/json" +
        "?query=\(query)&key=\(apiKey)"

        guard let url = URL(string: urlStr) else {
            completion([])
            return
        }

        URLSession.shared.dataTask(with: url) { data, _, _ in
            guard let data = data else {
                DispatchQueue.main.async { completion([]) }
                return
            }

            do {
                let json = try JSONSerialization.jsonObject(with: data) as? [String: Any]
                let results = json?["results"] as? [[String: Any]] ?? []

                let places: [Place] = results.compactMap { result -> Place? in
                    guard
                        let name = result["name"] as? String,
                        let address = result["formatted_address"] as? String,
                        let types = result["types"] as? [String],
                        let geometry = result["geometry"] as? [String: Any],
                        let location = geometry["location"] as? [String: Any],
                        let lat = location["lat"] as? Double,
                        let lng = location["lng"] as? Double
                    else {
                        return nil
                    }

                    let photos = result["photos"] as? [[String: Any]] ?? []
                    let photoRefs = photos.compactMap {
                        $0["photo_reference"] as? String
                    }

                    return Place(
                        name: name,
                        category: types.first ?? "카테고리 없음",
                        address: address,
                        latitude: lat,
                        longitude: lng,
                        photoReferences: photoRefs
                    )
                }

                DispatchQueue.main.async {
                    completion(places)
                }
            } catch {
                print("디코딩 에러:", error)
                DispatchQueue.main.async { completion([]) }
            }
        }
        .resume()
    }

    // 맛집 저장
    func saveWillPost(place: Place, completion: @escaping (Bool) -> Void) {
        self.isLoading = true

        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy.MM.dd"
        let dateString = formatter.string(from: Date())

        let requestBody = WillSaveRequest(
            title: place.name,
            category: "한식",
            address: place.address,
            date: dateString,
            images: place.photoReferences
        )

        Task { @MainActor in
            let response = await willService.saveWillPost(data: requestBody)
            
            if response.success {
                print("DB 저장 성공!")
                completion(true)
            } else {
                print("서버 응답 에러: \(response.message ?? "")")
                completion(false)
            }
            self.isLoading = false
        }
    }
}
