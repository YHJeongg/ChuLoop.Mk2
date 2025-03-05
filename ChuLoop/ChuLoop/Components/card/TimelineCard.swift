//
//  TimelineCard.swift
//  ChuLoop
//

import SwiftUI

struct TimelineCard: View {
    @Binding var item: MainModel
    @Binding var showSheet: Bool
    var isDeletable: Bool = false
    var onDelete: (() -> Void)? = nil
    var onShare: ((Bool) -> Void)? = nil  // Bool로 공유 여부를 전달

    @State private var showDeleteAlert: Bool = false
    @State private var showShareAlert: Bool = false
    @State private var toggleState: Bool
    @State private var previousToggleState: Bool // 토글 상태 저장

    init(item: Binding<MainModel>, showSheet: Binding<Bool>, isDeletable: Bool = false, onDelete: (() -> Void)? = nil, onShare: ((Bool) -> Void)? = nil) {
        self._item = item
        self._showSheet = showSheet
        self.isDeletable = isDeletable
        self.onDelete = onDelete
        self.onShare = onShare
        self._toggleState = State(initialValue: item.wrappedValue.shared)
        self._previousToggleState = State(initialValue: item.wrappedValue.shared)
    }

    var body: some View {
        VStack {
            // 이미지 부분
            imageSection

            // 내용 부분
            contentSection
        }
        .background(Color.white)
        .cornerRadius(5)
        .overlay(RoundedRectangle(cornerRadius: 5).stroke(Color.natural60, lineWidth: 0.5))
        .swipeActions { swipeActions }
        .alert(isPresented: $showDeleteAlert) {
            Alert(title: Text("삭제 확인"),
                  message: Text("정말 삭제하시겠습니까?"),
                  primaryButton: .cancel(Text("취소")) {
                    showDeleteAlert = false
                  },
                  secondaryButton: .destructive(Text("삭제")) {
                    onDelete?()
                    showDeleteAlert = false
                  })
        }
        .alert(isPresented: $showShareAlert) {
            Alert(title: Text(toggleState ? "게시글 공유 취소" : "게시글 공유"),
                  message: Text(toggleState ? "이 게시글의 공유를 취소하시겠습니까?" : "이 게시글을 공유하시겠습니까?"),
                  primaryButton: .cancel(Text("취소")) {
                    // 취소 시 toggleState를 원래 상태로 복구하고 alert 닫기
                    toggleState = previousToggleState
                    showShareAlert = false
                  },
                  secondaryButton: .default(Text("확인")) {
                    onShare?(toggleState)  // 공유 여부를 전달
                    previousToggleState = toggleState // 상태 저장
                  })
        }
    }
}

private extension TimelineCard {
    // 이미지 섹션
    var imageSection: some View {
        Group {
            if let imageUrl = URL(string: item.images.first ?? "") {
                AsyncImage(url: imageUrl) { phase in
                    switch phase {
                    case .empty:
                        ProgressView()
                            .frame(height: ResponsiveSize.height(250))
                    case .success(let image):
                        image.resizable()
                            .scaledToFill()
                            .frame(height: ResponsiveSize.height(250))
                            .clipped()
                            .onTapGesture { showSheet.toggle() }
                    case .failure:
                        Image(systemName: "photo")
                            .resizable()
                            .scaledToFit()
                            .frame(height: ResponsiveSize.height(250))
                            .foregroundColor(.gray)
                    @unknown default:
                        EmptyView()
                    }
                }
            }
        }
    }

    // 내용 섹션
    var contentSection: some View {
        VStack(alignment: .leading) {
            titleAndDateSection
            addressSection
            ratingAndShareSection
        }
    }

    // 타이틀과 날짜
    var titleAndDateSection: some View {
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
        .padding(.horizontal, ResponsiveSize.width(15))
        .padding(.top, ResponsiveSize.height(5))
    }

    // 주소
    var addressSection: some View {
        Text(item.address)
            .font(.bodyXSmall)
            .foregroundColor(.natural60)
            .padding(.horizontal, ResponsiveSize.width(15))
            .padding(.top, ResponsiveSize.height(5))
    }

    // 별점과 공유 토글
    var ratingAndShareSection: some View {
        HStack {
            HStack() {
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

                Toggle("", isOn: $toggleState)
                    .labelsHidden()
                    .onChange(of: toggleState) { newValue in
                        if previousToggleState != toggleState {
                            // 토글 상태가 변경되었을 때 alert 표시
                            showShareAlert = true
                        }
                    }
            }
        }
        .padding(.horizontal, ResponsiveSize.width(15))
        .padding(.top, ResponsiveSize.height(35))
        .padding(.bottom, ResponsiveSize.height(10))
    }

    // 삭제 버튼 처리
    var swipeActions: some View {
        Group {
            if isDeletable {
                Button(role: .destructive) {
                    showDeleteAlert = true
                } label: {
                    Label("삭제", systemImage: "trash")
                }
            }
        }
    }
}
