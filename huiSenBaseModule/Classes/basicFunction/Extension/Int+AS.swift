//
//  Int+AS.swift
//  huiSenSmart
//
//  Created by jonkersun on 2021/4/29.
//

import Foundation
import UIKit

extension Int: AriSwiftCompatible {}
public extension AriSwift where Base == Int {

    /// 数字转字符串
    /// - Returns: String
    func intToString()->String {
        if base == 0 {
            return ""
        } else {
            return "\(base)"
        }
    }
    
    /// 返回根据屏幕缩放后的宽的尺寸
    var intScalVValue: CGFloat {
        let scal = UIScreen.main.bounds.size.width / 375.0
        return scal * CGFloat(base)
    }
    
    /// 返回根据屏幕缩放后的高的尺寸
    var intScalHValue: CGFloat {
        let scal = UIScreen.main.bounds.size.height / 667.0
        return scal * CGFloat(base)
    }

    /// 数字转X小时X分钟X秒
    /// - Returns: X小时X分钟X秒
    func intToFormatCN() -> String {
        let spent_time = base
        let hour = spent_time/3600
        let zMin = spent_time/60
        let m = zMin%60
        let s = spent_time%60
        if hour > 0 {
            return "\(hour)小时\(m)分钟\(s)秒"
        } else {
            if zMin > 0 {
                return "\(zMin)分钟\(s)秒"
            } else {
                return "\(s)秒"
            }
        }
    }
        
    /// 数字转XX:XX:XX
    /// - Parameter formatSpace: 分割样式
    /// - Returns: XX:XX:XX
    func intToFormatSpace(_ formatSpace:String = ":") -> String {
        let spent_time = base
        let hour = spent_time/3600
        let zMin = spent_time/60
        let m = zMin%60
        let s = spent_time%60
        if hour < 100 {
            return String(format: "%02d:%02d:%02d", hour,m,s)
        } else {
            return "\(hour)" + String(format: ":%02d:%02d",m,s)
        }
    }
    
    
    /// 数字转X时X分X秒
    /// - Returns: X时X分X秒
    func intToFormatCNShort() -> String {
        let spent_time = base
        let hour = spent_time/3600
        let zMin = spent_time/60
        let m = zMin%60
        let s = spent_time%60
        let h = hour%24
        let day = hour / 24
        let dStr = day > 0 ? "\(day)天" : ""
        let hStr = h > 0 ? "\(h)时" : ""
        let mStr = m > 0 ? "\(m)分" : ""
        let sStr = s > 0 ? "\(s)秒" : ""
        return dStr + hStr + mStr + sStr
    }
    
    
    /// 两个时间相差几天
    /// - Parameter nowTime: 当前时间
    /// - Returns: 相差的天数
    func intIntervalDay(by nowTime: Int) -> Int {
        let endTime = base
        let spentTime = endTime >= nowTime ? (endTime - nowTime) / 1000 : (nowTime - endTime) / 1000
        let hour = spentTime/3600
        let day = hour / 24
        return day
    }
    

//    func getTimeCostString() -> String {
//        let ts = Double(base)
//        let min = Int(floor(ts/60).truncatingRemainder(dividingBy: 60))
//        let hours = Int(floor(ts/3600))
//        let se = Int(ts.truncatingRemainder(dividingBy: 60))
//        let h = String.init(format: "%02d", Int(hours))
//        let m = String.init(format: "%02d", Int(min))
//        let s = String.init(format: "%02d", Int(se))
//        return "\(h):\(m):\(s)"
//    }
//
//    func getMASCostString() -> String {
//        let ts = Double(base)
//        let min = Int(floor(ts/60))
//        let se = Int(ts.truncatingRemainder(dividingBy: 60))
//        var m = ""
//        if Int(min) < 100 {
//            m = String.init(format: "%02d", Int(min))
//        } else {
//            m = "\(min)"
//        }
//        let s = String.init(format: "%02d", Int(se))
//        return "\(m):\(s)"
//    }
//
//    func getMASCostAttrString(maxFont: UIFont, minFont: UIFont) -> NSMutableAttributedString {
//        let attr = NSMutableAttributedString()
//        let spent_time = base
//        let zMin = spent_time/60
//        let s = spent_time%60
//        if zMin > 0 {
//            let a1 = NSAttributedString(string: "\(zMin)", attributes: [NSAttributedString.Key.font : maxFont])
//            let a2 = NSAttributedString(string: "分", attributes: [NSAttributedString.Key.font : minFont])
//            let a3 = NSAttributedString(string: "\(s)", attributes: [NSAttributedString.Key.font : maxFont])
//            let a4 = NSAttributedString(string: "秒", attributes: [NSAttributedString.Key.font : minFont])
//            attr.append(a1)
//            attr.append(a2)
//            attr.append(a3)
//            attr.append(a4)
//        } else {
//            let a5 = NSAttributedString(string: "\(s)", attributes: [NSAttributedString.Key.font : maxFont])
//            let a6 = NSAttributedString(string: "秒", attributes: [NSAttributedString.Key.font : minFont])
//            attr.append(a5)
//            attr.append(a6)
//        }
//        return attr
//    }
//
//    func caculateExamDate(by endTime: Int) -> String {
//        let startTime = base
//        let startDate = Date(timeIntervalSince1970: TimeInterval(startTime/1000))
//        let endDate = Date(timeIntervalSince1970: TimeInterval(endTime/1000))
//        var calendar = Calendar.current
//        calendar.locale = Locale(identifier: "zh_CN")
//        let day = calendar.component(Calendar.Component.weekday, from: startDate)
//        let weakDay = day >= kWeekArr.count ? (kWeekArr.last ?? "") : "（\(kWeekArr[day - 1])）"
//        let sd = formater.string(from: startDate)
//        let ed = formater.string(from: endDate)
//        let month = sd[0..<6]
//        let sTime = sd[6..<11]
//        let eTime = ed[6..<11]
//        return "\(month)\(weakDay)\(sTime)-\(eTime)"
//    }
//    private let kWeekArr: [String] = ["周日", "周一", "周二", "周三", "周四", "周五", "周六"]
    //private let formater = DateFormatter(withFormat: "MM月dd日HH:mm", locale: "zh_CN")

}

