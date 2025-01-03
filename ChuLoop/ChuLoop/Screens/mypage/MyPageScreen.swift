//
//  MyPageScreen.swift
//  ChuLoop
//

import SwiftUI

struct MyPageScreen: View {
    let items = [
        ("하트 게시물 모아 보기", "heart.fill", Color.red),
        ("설정", "gear", Color.black),
        ("공지사항", "exclamationmark.circle.fill", Color.black),
        ("개인정보 처리방침", "doc.fill", Color.black)
    ]
    
    var body: some View {
        MyPageNavigationView(title: "My Page", content: {
            List(items, id: \.0) { item, iconName, iconColor in
                if item == "하트 게시물 모아 보기" {
                    NavigationLink(destination: HeartScreen()) {
                        HStack {
                            Image(systemName: iconName)
                                .font(.system(size: 20))
                                .foregroundColor(iconColor)
                            
                            Text(item)
                                .font(.system(size: 20, weight: .medium))
                                .foregroundColor(.black)
                                .padding(.leading, 10)
                        }
                    }
                    .buttonStyle(PlainButtonStyle())
                    .padding(.vertical, 10)
                    .listRowSeparator(.hidden)
                } else if item == "개인정보 처리방침" {
                    NavigationLink(destination: PrivacyPolicyScreen()) {
                        HStack {
                            Image(systemName: iconName)
                                .font(.system(size: 20))
                                .foregroundColor(iconColor)
                            
                            Text(item)
                                .font(.system(size: 20, weight: .medium))
                                .foregroundColor(.black)
                                .padding(.leading, 10)
                        }
                    }
                    .buttonStyle(PlainButtonStyle())
                    .padding(.vertical, 10)
                    .listRowSeparator(.hidden)
                } else if item == "공지사항" {
                    NavigationLink(destination: NoticeScreen()) {
                        HStack {
                            Image(systemName: iconName)
                                .font(.system(size: 20))
                                .foregroundColor(iconColor)
                            
                            Text(item)
                                .font(.system(size: 20, weight: .medium))
                                .foregroundColor(.black)
                                .padding(.leading, 10)
                        }
                    }
                    .buttonStyle(PlainButtonStyle())
                    .padding(.vertical, 10)
                    .listRowSeparator(.hidden)
                } else if item == "설정" {
                    NavigationLink(destination: SettingsScreen()) {
                        HStack {
                            Image(systemName: iconName)
                                .font(.system(size: 20))
                                .foregroundColor(iconColor)
                            
                            Text(item)
                                .font(.system(size: 20, weight: .medium))
                                .foregroundColor(.black)
                                .padding(.leading, 10)
                        }
                    }
                    .buttonStyle(PlainButtonStyle())
                    .padding(.vertical, 10)
                    .listRowSeparator(.hidden)
                } else {
                    NavigationLink(destination: Text("\(item) 화면")) {
                        HStack {
                            Image(systemName: iconName)
                                .font(.system(size: 20))
                                .foregroundColor(iconColor)
                            
                            Text(item)
                                .font(.system(size: 20, weight: .medium))
                                .foregroundColor(.black)
                                .padding(.leading, 10)
                        }
                    }
                    .buttonStyle(PlainButtonStyle())
                    .padding(.vertical, 10)
                    .listRowSeparator(.hidden)
                }
            }
            .scrollContentBackground(.hidden)
        })
    }
}

struct MyPageScreen_Previews: PreviewProvider {
    static var previews: some View {
        MyPageScreen()
    }
}
