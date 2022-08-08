//	
//  UIColor+AS.swift
//  huiSenSmart
//
//  Created by jonkersun on 2021/4/14.
//  Copyright © 2021 Grand. All rights reserved.
//


import UIKit
public extension AriSwift where Base: UIColor {
    /// 获取随机色
    static var random: UIColor {
        return UIColor(red: UInt8(arc4random_uniform(256)), green: UInt8(arc4random_uniform(256)), blue: UInt8(arc4random_uniform(256)))
    }
}

public extension UIColor {
    ///rgba快速构建 - eg:233.0
    convenience init(red r: UInt8, green g:UInt8, blue b: UInt8, alpha a: CGFloat = 1) {
        self.init(red: CGFloat(r) / 255.0, green: CGFloat(g) / 255.0, blue: CGFloat(b) / 255.0, alpha: a)
    }
    
    ///hexCollor快速构建--eg:0xFF0000、"#FF0000"、“FF0000”
    convenience init(_ colorHex: String!,alpha: CGFloat = 1 ) {
        if colorHex.isEmpty {
            self.init()
        }
        var cString = colorHex.trimmingCharacters(in: NSCharacterSet.whitespacesAndNewlines)
        
        if cString.hasPrefix("#") {
            cString.remove(at: cString.startIndex)
        }
        var value = cString
        if !cString.hasPrefix("0x") {
            value = "0x\(cString)"
        }
        if value.count != 8{
            self.init()
        }
        let scanner = Scanner(string:value)
        var hexValue : UInt64 = 0
        //查找16进制是否存在
        if scanner.scanHexInt64(&hexValue) {
            print(hexValue)
            let redValue = CGFloat((hexValue & 0xFF0000) >> 16)/255.0
            let greenValue = CGFloat((hexValue & 0xFF00) >> 8)/255.0
            let blueValue = CGFloat(hexValue & 0xFF)/255.0
            self.init(red: redValue, green: greenValue, blue: blueValue,alpha: alpha)
        }else{
            self.init()
        }
    }
}
