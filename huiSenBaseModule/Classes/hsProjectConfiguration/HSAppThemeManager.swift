//
//  HSAppThemeManager.swift
//  huiSenSmart
//
//  Created by jonker.sun on 2022/2/16.
//

import UIKit
//import ObjectMapper

public let HSAppThemeModel = HSAppThemeManager.shared.themeColorModel

public class HSAppThemeManager {
    public static var shared = HSAppThemeManager()
    /// 保存主题模式
    /// - Parameter theme: 主题模式
    public static func saveTheme(_ theme:HSAppTheme) {
        let themeManager = HSAppThemeManager.shared
        HSUserAccountDault.standard.appTheme = theme
        guard let mdoel = HSAppThemeColor.decode(fromDictionary: themeManager.colorJsonArray[theme.rawValue], to: HSAppThemeColor.self)else {
            return
        }
        themeManager.themeColorModel = mdoel
    }
    
    /// 获取主题模式
    /// - Returns: 主题模式
    public static func nowTheme() -> HSAppTheme {
        return HSUserAccountDault.standard.appTheme
    }
    
    /// 图片的名称的生成
    /// - Parameter defaultImageName: 原始图片名称
    /// - Returns: 皮肤全名称
    public static func themeImageNameSuffix(_ defaultImageName:String) -> String {
           return defaultImageName
//           switch HSUserAccountDault.standard.appTheme {
//           case .normal:
//                return defaultImageName+"_day_theme"
//           case .night:
//                return defaultImageName+"_night_theme"
//           default:
//                return defaultImageName+"_day_theme"
//          }
     }
    
    public lazy var themeColorModel: HSAppThemeColor = {
        guard let mdoel = HSAppThemeColor.decode(fromDictionary: colorJsonArray[HSAppThemeManager.nowTheme().rawValue], to: HSAppThemeColor.self)else {
            return HSAppThemeColor()
        }
        return mdoel
    }()
    
    /// 配置各个模式下的颜色值
    public lazy var colorJsonArray:[[String: String]] = {
        if HSAppThemeManagerDataSource.isEmpty || HSAppThemeManagerDataSource.count == 0 {
           return [["wordMain":"FF6B6B", "wordBlack":"1F1F1F", "wordBlackLight":"333333", "wordGay":"999999", "wordGayLight":"B8B8B8", "backGroundMain":"FF6B6B", "backGroundLight":"FFFFFF", "backGroundGay":"F7F7F7", "lineGay":"F0F0F0", "lineBordGay":"D6D6D7", "imageMain":"FF6B6B", "imageBlack":"333333", "imageGay":"8c8c8c", "imageGayLight":"D6D6D7"],
              ["wordMain":"FF6B6B", "wordBlack":"1F1F1F", "wordBlackLight":"333333", "wordGay":"999999", "wordGayLight":"B8B8B8", "backGroundMain":"FF6B6B", "backGroundLight":"FFFFFF", "backGroundGay":"F7F7F7", "lineGay":"F0F0F0", "lineBordGay":"D6D6D7", "imageMain":"FF6B6B", "imageBlack":"333333", "imageGay":"8c8c8c", "imageGayLight":"D6D6D7"],
              ["wordMain":"FF6B6B", "wordBlack":"1F1F1F", "wordBlackLight":"333333", "wordGay":"999999", "wordGayLight":"B8B8B8", "backGroundMain":"FF6B6B", "backGroundLight":"FFFFFF", "backGroundGay":"F7F7F7", "lineGay":"F0F0F0", "lineBordGay":"D6D6D7", "imageMain":"FF6B6B", "imageBlack":"333333", "imageGay":"8c8c8c", "imageGayLight":"D6D6D7"]
            ]
        }else {
            return HSAppThemeManagerDataSource
        }
    }()

}

public struct HSAppThemeColor: HSCoadble {
    // MARK: 字体颜色
    /// 红色-正常模式：FF6B6B
    public var wordMain: String = "FF6B6B"
    /// 最黑-正常模式：1F1F1F
    public var wordBlack: String = "1F1F1F"
    /// 浅黑-正常模式：333333
    public var wordBlackLight: String = "333333"
    /// 灰色-正常模式：999999
    public var wordGay: String = "999999"
    /// 浅色-正常模式：B8B8B8
    public var wordGayLight: String = "B8B8B8"
    
    // MARK:  背景颜色
    /// 红色-正常模式：FF6B6B
    public var backGroundMain: String = "FF6B6B"
    /// 白色-正常模式：FFFFFF
    public var backGroundLight: String = "FFFFFF"
    /// 浅灰色-正常模式：F7F7F7
    public var backGroundGay: String = "F7F7F7"
    
    // MARK:  线颜色
    /// 线灰色-正常模式：F0F0F0
    public var lineGay: String = "F0F0F0"
    /// 边框灰色-正常模式：D6D6D7
    public var lineBordGay: String = "D6D6D7"
    
    // MARK:  图片渲染颜色
    /// 图片渲染红色-正常模式：FF6B6B
    public var imageMain: String = "FF6B6B"
    /// 图片黑灰色-正常模式：333333
    public var imageBlack: String = "333333"
    /// 图片渲染灰色-正常模式：8c8c8c
    public var imageGay: String = "8c8c8c"
    /// 图片渲染浅灰色-正常模式：D6D6D7
    public var imageGayLight: String = "D6D6D7"
}
