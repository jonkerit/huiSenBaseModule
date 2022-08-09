//
//  HSAPPNetworkConfiguration.swift
//  huiSenSmart
//
//  Created by jonker.sun on 2022/1/17.

// App 主题配置,模式需要与HSAppThemeManagerDataSource的数量一致（不配置是默认三个模式）
enum HSAppTheme: Int{
    /// 正常模式
    case normal = 0
    /// 夜晚模式
    case night = 1
    /// 其他模式
    case other = 2
}
public var HSAppThemeManagerDataSource : [[String: String]] = [[String: String]]()
public var HSAPPBaseUrl = ""
public var HSAppToken = ""
// 存储的账户标识(一般是账号)
public var HSUserKey = ""
