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
    
    case userInfo = "/user/info"
    case user = "/user"
    case userImage = "/user/image"
    case likedPost = "/liked-post"

    case edPost = "/ed-post"
    case edPostShare = "/ed-post/share"
    case edPostUnshare = "/ed-post/unshare"
    case edPostImage = "/ed-post/image"
    

    case willPost = "/will-post"

    case noticeList = "/notice"
    
    
    

}
