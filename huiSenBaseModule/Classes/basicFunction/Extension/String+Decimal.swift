//
//  String+Decimal.swift
//  huiSenSmart
//
//  Created by jonkersun on 2021/4/27.
//

import Foundation

public extension AriSwift where Base == String {
    
    ///  验证字符串是否有数字和小数点、负号- 组成
    func decimalIsNumberRule() -> Bool {
        var tempString = "\(base)"
        if tempString.as.isEmpty() {
            return false
        }
        if tempString.contains(".") {
            tempString = tempString.replacingOccurrences(of: ".", with: "")
        }
        if tempString.contains("-") {
            tempString = tempString.replacingOccurrences(of: "-", with: "")
        }
        let pred = NSPredicate.init(format: "SELF MATCHES  %@", "[0-9]*")
        return pred.evaluate(with: tempString)
    }
    
    ///  基本运算：加法
    func decimalAdd(_ input:String) -> String {
        var tempString = "\(base)"
        tempString = tempString.as.isEmpty() ? "0":tempString
        let tempInput = input.as.isEmpty() ? "0":input
        if decimalIsNumberRule() && tempInput.as.decimalIsNumberRule() {
            let number01 = NSDecimalNumber.init(string: tempString)
            let number02 = NSDecimalNumber.init(string: tempInput)
            let number03 = number01.adding(number02)
            return "\(number03)"
        }
        return tempString
    }
    
    ///  基本运算：减法
    func decimalSub(_ input:String) -> String {
        var tempString = "\(base)"
        tempString = tempString.as.isEmpty() ? "0":tempString
        let tempInput = input.as.isEmpty() ? "0":input
        if decimalIsNumberRule() && tempInput.as.decimalIsNumberRule() {
            let number01 = NSDecimalNumber.init(string: tempString)
            let number02 = NSDecimalNumber.init(string: tempInput)
            let number03 = number01.subtracting(number02)
            return "\(number03)"
        }
        return tempString
    }
    
    ///  基本运算：乘法
    func decimalMulti(_ input:String) -> String {
        var tempString = "\(base)"
        tempString = tempString.as.isEmpty() ? "0":tempString
        let tempInput = input.as.isEmpty() ? "0":input
        if decimalIsNumberRule() && tempInput.as.decimalIsNumberRule() {
            let number01 = NSDecimalNumber.init(string: tempString)
            let number02 = NSDecimalNumber.init(string: tempInput)
            let number03 = number01.multiplying(by: number02)
            return "\(number03)"
        }
        return tempString
    }
    
    ///  基本运算：除法
    func decimalDivi(_ input:String) -> String {
        var tempString = "\(base)"
        tempString = tempString.as.isEmpty() ? "0":tempString
        let tempInput = (input.as.isEmpty() || input=="0") ? "1":input
        if decimalIsNumberRule() && tempInput.as.decimalIsNumberRule() {
            let number01 = NSDecimalNumber.init(string: tempString)
            let number02 = NSDecimalNumber.init(string: tempInput)
            let number03 = number01.dividing(by: number02)
            return "\(number03)"
        }
        return tempString
    }
    
    /// 基本运算： 10为底的乘方运算：数 * 10的power次方
    func decimalPowerOf10(_ input:String) -> String {
        var tempString = "\(base)"
        tempString = tempString.as.isEmpty() ? "0":tempString
        let tempInput = input.as.isEmpty() ? "0":input
        let tempInt = Int16(tempInput) ?? 0
        if tempString.as.decimalIsNumberRule() && tempInput.as.decimalIsNumberRule() {
            let number01 = NSDecimalNumber.init(string: tempString)
            let number03 = number01.multiplying(byPowerOf10:tempInt)
            return "\(number03)"
        }
        return tempString
    }
    
    /// 基本运算： 比较：A 是否大于 B
    func decimalMoreThan(_ input:String) -> Bool {
        var tempString = "\(base)"
        tempString = tempString.as.isEmpty() ? "0":tempString
        let tempInput = input.as.isEmpty() ? "0":input
        if tempString.as.decimalIsNumberRule() && tempInput.as.decimalIsNumberRule() {
            let number01 = NSDecimalNumber.init(string: tempString)
            let number02 = NSDecimalNumber.init(string: tempInput)
            return number01.compare(number02) == .orderedDescending
        }
        return false
    }
    
    /// 基本运算： 比较：A 是否小于 B
    func decimalLessThan(_ input:String) -> Bool {
        var tempString = "\(base)"
        tempString = tempString.as.isEmpty() ? "0":tempString
        let tempInput = input.as.isEmpty() ? "0":input
        if tempString.as.decimalIsNumberRule() && tempInput.as.decimalIsNumberRule() {
            let number01 = NSDecimalNumber.init(string: tempString)
            let number02 = NSDecimalNumber.init(string: tempInput)
            return number01.compare(number02) == .orderedAscending
        }
        return false
    }
    
    /// 基本运算： 比较：A 是否等于 B
    func decimalEqualThan(_ input:String) -> Bool {
        var tempString = "\(base)"
        tempString = tempString.as.isEmpty() ? "0":tempString
        let tempInput = input.as.isEmpty() ? "0":input
        if tempString.as.decimalIsNumberRule() && tempInput.as.decimalIsNumberRule() {
            let number01 = NSDecimalNumber.init(string: tempString)
            let number02 = NSDecimalNumber.init(string: tempInput)
            return number01.compare(number02) == .orderedSame
        }
        return false
    }
    
    /// 截取小数位数，四舍五入，并去除末尾的0
    func decimalSubRoundingDecimal(_ decimalNum:Int) -> String {
        var tempString = "\(base)"
        tempString = tempString.as.isEmpty() ? "0":tempString
        if decimalIsNumberRule() {
            let roundingBehavior = NSDecimalNumberHandler.init(roundingMode: .plain, scale: Int16(decimalNum), raiseOnExactness: false, raiseOnOverflow: false, raiseOnUnderflow: false, raiseOnDivideByZero: false)
            let number01 = NSDecimalNumber.init(string: tempString)
            let roundedOunces = number01.rounding(accordingToBehavior: roundingBehavior)
            return "\(roundedOunces)"
        }
        return tempString
    }
    
    /// 截取小数位数，不四舍五入，并去除末尾的0
    func decimalSubNoRoundingDecimal(_ decimalNum:Int) -> String {
        var tempString = "\(base)"
        tempString = tempString.as.isEmpty() ? "0":tempString
        if decimalIsNumberRule() {
            if decimalNum == 0 && tempString.contains(".") {
                return tempString.components(separatedBy: ".").first ?? "0"
            }
            
            let roundingBehavior = NSDecimalNumberHandler.init(roundingMode: .down, scale: Int16(decimalNum), raiseOnExactness: false, raiseOnOverflow: false, raiseOnUnderflow: false, raiseOnDivideByZero: false)
            let number01 = NSDecimalNumber.init(string: tempString)
            let roundedOunces = number01.rounding(accordingToBehavior: roundingBehavior)
            return "\(roundedOunces)"
        }
        return tempString
    }
    
    /// 字符串去除小数末尾的0和头部无效的0
    func decimalZeroValue() -> String {
        var tempString = "\(base)"
        tempString = tempString.as.isEmpty() ? "0":tempString
        if tempString.as.decimalEqualThan("0") {
            return "0"
        }
        
        if !tempString.contains(".") {
            while tempString.hasPrefix("0") {
                let star = tempString.index(tempString.startIndex, offsetBy: 1)
                tempString = String(tempString[star...])
            }
            return tempString
        }
        
        let tempArr = tempString.components(separatedBy: ".")
        var firstString = tempArr.first ?? ""
        var lastString = tempArr.last ?? ""
        // 去最后的0
        while lastString.hasSuffix("0") {
            let end = lastString.index(before: lastString.endIndex)
            lastString = String(lastString[..<end])
        }
        // 去前面的0
        var isStop = true
        while isStop {
            // 小数点整数位只有一位时，不去0
            if firstString.count == 1 {
                isStop = false
            } else {
                if firstString.hasPrefix("0") {
                    let stars = firstString.index(firstString.startIndex, offsetBy: 1)
                    firstString = String(firstString[stars...])
                } else {
                    isStop = false
                }
            }
        }
        return lastString.count>0 ? "\(firstString).\(lastString)":firstString
    }
}
