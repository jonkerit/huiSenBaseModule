//
//  UIFont+AS.swift
//  huiSenSmart
//
//  Created by jonkersun on 2021/4/29.
//

import UIKit
public extension AriSwift where Base: UIFont {

}
public extension UIFont{
    enum ESFontName: String {
        case regular = "PingFangSC-Regular"
        case light   = "PingFangSC-Light"
        case medium  = "PingFangSC-Medium"
        case smedium  = "PingFangSC-Semibold"
        case dincondBold  = "DINCond-Bold"
        case dinAlter  = "DINAlterante-Bold"

    }
    /// UIFont 扩展 ps: title.font = UIFont.font(name: .medium, size: 18)
    static func font(name: ESFontName, size: CGFloat) -> UIFont {
        let font: UIFont? = UIFont.init(name: name.rawValue, size: size)
        guard let esfont = font else {
            return UIFont.systemFont(ofSize: size)
        }
        return esfont
    }
}
 
