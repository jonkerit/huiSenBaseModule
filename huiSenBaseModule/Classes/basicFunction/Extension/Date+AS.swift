//
//  Date+AS.swift
//  huiSenSmart
//
//  Created by jonkersun on 2021/4/14.
//   

import Foundation
fileprivate let calender = Calendar(identifier: .gregorian)
extension Date: AriSwiftCompatible {}
public extension AriSwift where Base == Date {
    /// 生成date  默认formatter "yyyy-MM-dd HH:mm:ss"
    static func date(from dateStr: String?, fmt: String = "yyyy-MM-dd HH:mm:ss") -> Date? {
        guard let dateStr = dateStr else {return nil}
        let dateFmt = DateFormatter()
        dateFmt.dateFormat = fmt
        return dateFmt.date(from: dateStr)
    }
    
    /// 获取当前时间戳-精确到秒
    static func currentTimeStamp() -> TimeInterval {
        let date = Date()
        return date.timeIntervalSince1970
    }
    
    /// 默认formatter "yyyy-MM-dd HH:mm:ss"
    func dateString(with fmt: String = "yyyy-MM-dd HH:mm:ss") -> String {
        let dateFmt = DateFormatter()
        dateFmt.dateFormat = fmt
        return dateFmt.string(from: base)
    }
    
    
    var year: Int {
        return calender.component(.year, from: base)
    }
    var month: Int {
        return calender.component(.month, from: base)
    }
    var day: Int {
        return calender.component(.day, from: base)
    }
    var hour: Int {
        return calender.component(.hour, from: base)
    }
    var minute: Int {
        return calender.component(.minute, from: base)
    }
    var second: Int {
        return calender.component(.second, from: base)
    }
    var weekDay: Int {
        return calender.component(.weekday, from: base)
    }
}
