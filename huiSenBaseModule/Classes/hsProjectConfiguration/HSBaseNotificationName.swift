//
//  HSBaseNotificationName.swift
//  huiSenSmart
//
//  Created by jonkersun on 2021/6/4.
//

import UIKit

struct HSBaseNotificationName {
    /// 红点发送改变
    static let redPointChange = Notification.Name(rawValue: "redPointChange")
    /// 网络请求统一处理通知
    static let networkDealResult = Notification.Name(rawValue: "networkDealResult")
    /// 标记首页是否刷新
    static let homePageIsrefresh = Notification.Name(rawValue: "homePageIsrefresh")
}
