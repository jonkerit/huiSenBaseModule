//
//  String+Date.swift
//  huiSenSmart
//
//  Created by jonkersun on 2021/4/27.
//

import Foundation
import UIKit

public extension AriSwift where Base == String {
    ///  把给定时间转换为NSDSate --- 能处理的时间格式：1、时间戳  2、yyyy-MM-dd HH:mm:ss 格式 （标准国际格式yyyy-MM-dd'T'HH:mm:ss.SSSZ）
    func dateStringChangeToDate() -> Date? {
        var tempDate = Date.init()
        var tempString = "\(base)"
        if tempString.isEmpty
            || tempString.count == 0
            || tempString == "(null)"
            || tempString == "null"{
            return nil
        }
        // 处理时间格式：1、时间戳  2、yyyy-MM-dd HH:mm:ss 格式 （标准国际格式yyyy-MM-dd'T'HH:mm:ss.SSSZ）
        if tempString.contains("-")
            || tempString.contains(":") {
            var formatStr = "yyyy-MM-dd HH:mm:ss"
            if tempString.contains("T")
                && tempString.contains(":")
                && tempString.contains("+") {
                formatStr = "yyyy-MM-dd'T'HH:mm:ssZZZZ"
            } else if tempString.contains("T")
                        && tempString.contains(":")
                        && (tempString.contains(".S") || tempString.contains("SZ") || tempString.contains("S Z")) {
                formatStr = "yyyy-MM-dd'T'HH:mm:ssZZZZ"
            } else if tempString.contains("T"){
                formatStr = "yyyy-MM-dd'T'HH:mm:ss"
            } else if tempString.contains(":"){
                formatStr = "yyyy-MM-dd HH:mm:ss"
            }else{
                formatStr = "yyyy-MM-dd"
            }
            let dateFmt = DateFormatter()
            dateFmt.dateFormat = formatStr
            tempDate = dateFmt.date(from: formatStr) ?? Date.init()
        }else{
            if tempString.count==13 {
                tempString = tempString.as.decimalDivi("1000")
                tempDate = Date.init(timeIntervalSince1970: Double(tempString) ?? 0)
//                Date.init(timeIntervalSinceReferenceDate: Double(tempString) ?? 0.0)
            }else if tempString.count==10 {
                tempDate = Date.init(timeIntervalSince1970: Double(tempString) ?? 0)
            }else{
                return nil
            }
        }
        
        return tempDate
    }
    
    /// 把时间转换为时间戳 --- 中国时区的时间--能处理的时间格式：1、时间戳  2、yyyy-MM-dd HH:mm:ss 格式 （标准国际格式yyyy-MM-dd'T'HH:mm:ss.SSSZ）
    /// - Parameters:
    ///   - zone: 时区（eg.@“8”）
    ///   - millisecond: 是否需要毫秒
    /// - Returns: 时间戳
    func dateChangeToTimestamp(zone:String, millisecond:Bool) -> String {
        let tempString = "\(base)"
        let date = tempString.as.dateStringChangeToDate()
        guard date != nil else {
            return tempString
        }
        // date转换为时间戳
        var timeSp = Int(truncating: NSNumber.init(value: Double(date!.timeIntervalSince1970)))
        timeSp = timeSp+NSInteger(zone.as.decimalMulti("1000"))!;
        let time = millisecond ? timeSp*1000:timeSp
        return "\(time)";
    }
    
    /// 中国时区的时间（包括时间戳、yyyy-MM-dd）转换为指定格式、时区的时间 --能处理的时间格式：1、时间戳  2、yyyy-MM-dd HH:mm:ss 格式 （标准国际格式yyyy-MM-dd'T'HH:mm:ss.SSSZ）
    /// - Parameters:
    ///   - format: 指定格式
    ///   - isZeroTime: 是否需要格林威治时间
    /// - Returns: 转换为指定格式、时区的时间
    func dateChangeToFormatDate(format:String, isZeroTime:Bool) -> String {
        let tempString = "\(base)"
        let date = tempString.as.dateStringChangeToDate()
        guard date != nil else {
            return tempString
        }
        // date转换为时间戳
        var timeSp = Int(truncating: NSNumber.init(value: Double(date!.timeIntervalSince1970)))
        // 判断是否需要格林尼治时间
        timeSp = isZeroTime ? (timeSp - 28800):timeSp
        // 转换为format时间格式
        let nowDate = Date.init(timeIntervalSince1970: TimeInterval(timeSp))
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = TimeZone.init(identifier: "Asia/Shanghai")
        dateFormatter.dateFormat = format
        return dateFormatter.string(from: nowDate);
    }
    
    ///从一个时间格式转换成另一种时间格式
    func dateChangeFormatter(from fmt1: String, to fmt2: String) -> String {
        let dateFmt1 = DateFormatter()
        dateFmt1.dateFormat = fmt1
        let dateFmt2 = DateFormatter()
        dateFmt2.dateFormat = fmt2
        
        guard let date = dateFmt1.date(from: base) else {
            return ""
        }
        return dateFmt2.string(from: date)
        
    }
}
