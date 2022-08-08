//
//  CGFloat+AS.swift
//  huiSenSmart
//
//  Created by jonkersun on 2021/4/29.
//

import Foundation
import UIKit

extension CGFloat: AriSwiftCompatible {}
public extension AriSwift where Base == CGFloat {

    /// 数字转字符串
    /// - Returns: String
    func floatToString()->String {
        let d = base
        if d > CGFloat(Int(d)) {
            return String(format: "%.2f", d)
        } else {
            return "\(Int(d))"
        }
    }
    
    /// 返回根据屏幕缩放后的宽的尺寸
    var floatScalVValue: CGFloat {
        let scal = UIScreen.main.bounds.size.width / 375.0
        return CGFloat(scal) * base
    }

    /// 返回根据屏幕缩放后的高的尺寸
    var floatScalHValue: CGFloat {
        let scal = UIScreen.main.bounds.size.height / 667.0
        return CGFloat(scal) * base
    }
}
