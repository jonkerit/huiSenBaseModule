//
//  HSAPPNetworkConfiguration.swift
//  huiSenSmart
//
//  Created by jonker.sun on 2022/1/17.
//

import UIKit

// 网络请求相关配置
struct HSAPPNetworkConfiguration {
    // 请求的base URL
    #if DEBUG
    static let HSAPPBaseUrl = "https://staging.huisensmart.com"
//    static let HSAPPBaseUrl = "http://106.15.107.104:7711"
    #elseif BATE
    static let HSAPPBaseUrl = "https://staging.huisensmart.com"
    #else
    static let HSAPPBaseUrl = "https://api.huisensmart.com"
    #endif
    // 网络请求token
    static let HSAppToken = ""
}

// App 主题配置,模式需要与HSAppThemeManagerDataSource的数量一致
enum HSAppTheme: Int{
    /// 正常模式
    case normal = 0
    /// 夜晚模式
    case night = 1
    /// 其他模式
    case other = 2
}
let HSAppThemeManagerDataSource : [[String: String]] = [[String: String]]()

// 需要的网络类型
let HSAppNetconnType = ""

// 存储的账户标识
let HSUserKey = ""
