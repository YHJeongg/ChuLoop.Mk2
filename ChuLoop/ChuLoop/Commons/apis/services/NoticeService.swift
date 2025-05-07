//
//  NoticeService.swift
//  ChuLoop
//
//  Created by Anna Kim on 3/18/25.
//

import Foundation

final class NoticeService {
    func getNoticeList() async -> ResponseVO {
        return await HTTP.shared.get(
            endpoint: ApisV1.noticeList.rawValue
        )
    }
}
