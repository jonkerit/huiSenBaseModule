//
//  String+AS.swift
//  huiSenSmart
//
//  Created by jonkersun on 2021/4/14.
//  Copyright © 2021 Grand. All rights reserved.
//

import Foundation
import UIKit

extension String: AriSwiftCompatible {}
public extension AriSwift where Base == String {
    
    /// 判断字符串是否为空
    func isEmpty() -> Bool {
        return base.isEmpty
            || base.count == 0
            || base == "(null)"
            || base == "null"
    }
    
    /// 计算字符串的size
    /// - Parameters:
    ///   - font: 字体
    ///   - maxSize: 最大尺寸
    ///   - lineMargin: 行间距
    /// - Returns: 尺寸
    func size(font: UIFont, maxSize: CGSize, lineMargin : CGFloat) -> CGSize {
        let options = NSStringDrawingOptions.usesLineFragmentOrigin
        let paragraphStyle : NSMutableParagraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = lineMargin
        var attributes : [NSAttributedString.Key : Any] = [:]
        attributes[NSAttributedString.Key(rawValue: NSAttributedString.Key.font.rawValue)] = font
        attributes[NSAttributedString.Key(rawValue: NSAttributedString.Key.paragraphStyle.rawValue)] = paragraphStyle
        let textBouds = base.boundingRect(with: maxSize, options: options, attributes: attributes, context: nil)
        return textBouds.size
    }
    
    /// 返回字符串的行数
    /// - Parameters:
    ///   - font: 字体
    ///   - maxWidth: 最大宽度
    /// - Returns: 行数
    func lineCount(_ font: UIFont, _ maxWidth: CGFloat = UIScreen.as.screenWidth - 40) -> Int {
        let text = base
        let myFont = CTFontCreateWithName(font.fontName as CFString, font.pointSize, nil)
        let attr = NSMutableAttributedString(string: text)
        attr.addAttribute(NSAttributedString.Key.font, value: myFont, range: NSMakeRange(0, text.count))
        let frameSetter = CTFramesetterCreateWithAttributedString(attr)
        let path = CGMutablePath()
        path.addRect(CGRect(x: 0, y: 0, width: maxWidth, height: CGFloat.greatestFiniteMagnitude))
        let ctFrame = CTFramesetterCreateFrame(frameSetter, CFRangeMake(0, 0), path, nil)
        let lines = CTFrameGetLines(ctFrame) as Array
        return lines.count
    }
    
    /// 根据位置截取字符串 eg:tempStr[0..<3]
    subscript (range: Range<Int>) -> String {
        get {
            let startIndex = base.index(base.startIndex, offsetBy: range.lowerBound)
            let endIndex = base.index(base.startIndex, offsetBy: range.upperBound)
            return String(base[Range(uncheckedBounds: (lower: startIndex, upper: endIndex))])
        }

        set {
            let startIndex = base.index(base.startIndex, offsetBy: range.lowerBound)
            let endIndex = base.index(base.startIndex, offsetBy: range.upperBound)
            let strRange = Range(uncheckedBounds: (lower: startIndex, upper: endIndex))
            base.replaceSubrange(strRange, with: newValue)
        }
    }
    
    /// NSRange转换为Range
    func range(from nsRange: NSRange) -> Range<String.Index>? {
        guard
            let from16 = base.utf16.index(base.utf16.startIndex, offsetBy: nsRange.location,
                                          limitedBy: base.utf16.endIndex),
            let to16 = base.utf16.index(from16, offsetBy: nsRange.length,
                                   limitedBy: base.utf16.endIndex),
            let from = String.Index(from16, within: base),
            let to = String.Index(to16, within: base)
        else { return nil }
        return from ..< to
    }
    
    /// Range转换为NSRange
    func nsRange(from range: Range<String.Index>) -> NSRange {
        guard
            let from = range.lowerBound.samePosition(in: base.utf16),
            let to = range.upperBound.samePosition(in: base.utf16)
            else {
            return NSRange(location: 0, length:0)
        }
        return NSRange(location: base.utf16.distance(from: base.utf16.startIndex, to: from),
                       length: base.utf16.distance(from: from, to: to))
    }
    
    /// 获取字符串的位置NSrange
    func nsRnage(of targetString:String) -> NSRange {
        return base.as.nsRange(from: base.range(of: targetString)!)
    }
    
    func floatVaule() -> CGFloat {
        let double = Double(base)
        //返回的double是个可选值，所以需要给个默认值或者用!强制解包
        return CGFloat(double ?? 0)
    }
    
    /// 富文本操作
    /// - Parameters:
    ///   - diffTxt: 不一样的文本
    ///   - diffTxtColor: 不一样的颜色
    ///   - diffTxtFont: 不一样的字体
    ///   - lineSpace: 行间距-0.f不设置
    ///   - verSpace: 字符间距-0不设置
    /// - Returns: 富文本
    func customAttributed(diffTxt:String!, diffTxtColor:UIColor?, diffTxtFont:UIFont?, lineSpace:CGFloat, verSpace:Int) -> NSMutableAttributedString {
        let attributeStr:NSMutableAttributedString = NSMutableAttributedString.init(string: base)
        if diffTxt.as.isEmpty() || !base.contains(diffTxt) {
            return attributeStr
        }
        let nsRange = base.as.nsRange(from: base.range(of: diffTxt)!)
        if diffTxtColor != nil {
            attributeStr.addAttribute(.foregroundColor, value: diffTxtColor as Any, range: nsRange)
        }
        if diffTxtFont != nil {
            attributeStr.addAttribute(.font, value: diffTxtFont as Any, range: nsRange)
        }
        if verSpace > 0 {
            attributeStr.addAttribute(.kern, value: NSNumber.init(value: verSpace), range: nsRange)
        }
        if lineSpace > 0 {
            let paragraphStyle : NSMutableParagraphStyle = NSMutableParagraphStyle()
           paragraphStyle.lineSpacing = lineSpace
            attributeStr.addAttribute(.paragraphStyle, value: paragraphStyle, range: nsRange)
        }
        return attributeStr
    }
    
    /// json字符串转字典
    func JSONStringtoDictionary() -> [String: AnyObject]?{
        if let data = base.data(using: .utf8) {
            do {
                return try JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.init(rawValue: 0)) as? [String: AnyObject]
            } catch let error as NSError {
                print(error)
            }
        }
        return nil
    }
    
    /// 字典转json字符串
    static func dictionaryToJSONString(_ inputDictnary:[String: Any]) -> String?{
        let data = try? JSONSerialization.data(withJSONObject: inputDictnary, options: JSONSerialization.WritingOptions.init(rawValue: 0))
        let jsonString = NSString.init(data: data!, encoding: String.Encoding.utf8.rawValue)
        return jsonString! as String
    }
    
    /// 字典、数组、字符串转json字符串
    static func JSONObjcToJSONString(_ inputObjt:Any) -> String?{
        let tempArray = inputObjt as? [Any]
        let tempDict = inputObjt as? [String: Any]
        
        if tempArray != nil {
            guard let data = try? JSONSerialization.data(withJSONObject: tempArray!, options: []) else {
                return nil
            }
            
            let jsonString = NSString.init(data: data, encoding: String.Encoding.utf8.rawValue)
            return jsonString! as String
        }else if tempDict != nil {
            guard let data = try? JSONSerialization.data(withJSONObject: tempDict!, options: []) else {
                return nil
            }
            
            let jsonString = NSString.init(data: data, encoding: String.Encoding.utf8.rawValue)
            return jsonString! as String
        }else if let tempString = inputObjt as? String {
            guard let encodedData = try? JSONEncoder().encode(tempString) else {
                return nil
            }
            let jsonString = NSString.init(data: encodedData, encoding: String.Encoding.utf8.rawValue)
            return jsonString! as String
        }else{
            return nil
        }
    }
}
