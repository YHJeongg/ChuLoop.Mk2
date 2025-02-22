//
//  apis.swift
//  ChuLoop
//
//  Created by Anna Kim on 1/13/25.
//

enum ApisV1: String {
    case reissue = "/auth/refresh"
    
    case googleLogin = "/auth/google"
    case naverLogin = "/auth/naver"
    case kakaoLogin = "/auth/kakao"
    case appleLogin = "/auth/apple"

    case edPost = "/ed-post"
    case edPostShare = "/ed-post/share"
    case edPostImage = "/ed-post/image"
    

    
    

}
