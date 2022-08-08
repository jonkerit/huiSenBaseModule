//
//  Double+AS.swift
//  huiSenSmart
//
//  Created by jonkersun on 2021/4/29.
//

import Foundation
import UIKit

public extension AriSwift where Base == Double {

    /// 数字转字符串
    /// - Returns: String
    func doubleToString()->String {
        let d = base
        if d > Double(Int(d)) {
            return String(format: "%.2f", d)
        } else {
            return "\(Int(d))"
        }
    }
    /// 返回根据屏幕缩放后的宽的尺寸
    var doubleScalVValue: Double {
        let scal = UIScreen.main.bounds.size.width / 375.0
        return scal * Double(base)
    }

    /// 返回根据屏幕缩放后的高的尺寸
    var doubleScalHValue: Double {
        let scal = UIScreen.main.bounds.size.height / 667.0
        return scal * Double(base)
    }
}
