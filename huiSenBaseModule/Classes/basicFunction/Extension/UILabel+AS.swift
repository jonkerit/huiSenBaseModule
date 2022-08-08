//
//  UILabel+AS.swift
//  huiSenSmart
//
//  Created by jonkersun on 2021/4/14.
//  Copyright © 2021 Grand. All rights reserved.
//


import UIKit
public extension AriSwift where Base: UILabel {
    
    /// 计算label的高度
    /// NSString的 boundingRect(with: , options: , attributes: , context: )方法
    /// 只能计算文本在某宽度的时候的高度,但是label如果用同样的文本的话是有细微的差别
    /// 所以使用以下方法让label先去模拟一遍布局完的状态来获取高度
    /// 由于会走一遍UI流程,肯定会有性能影响,但是手机屏幕的label量并不能表现出来
    ///
    /// - Parameters:
    ///   - text: 文本
    ///   - fontSize: 字体大小
    ///   - width: 最大宽度
    /// - Returns: 计算后的label高度
    static func calculateLabelSize(with text: String,fontSize: CGFloat = 16, width: CGFloat = UIScreen.as.screenWidth * 0.7) -> CGSize {
        let view = UIView(frame: CGRect(x: 0, y: 0, width: CGFloat.greatestFiniteMagnitude, height: CGFloat.greatestFiniteMagnitude))
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: fontSize)
        label.text = text
        label.numberOfLines = 0
        view.addSubview(label)
        view.translatesAutoresizingMaskIntoConstraints = false
        label.translatesAutoresizingMaskIntoConstraints = false
        let widthC = NSLayoutConstraint(item: label, attribute: .width, relatedBy: .lessThanOrEqual, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: width)
        let centerX = NSLayoutConstraint(item: label, attribute: .centerX, relatedBy: .equal, toItem: view, attribute: .centerX, multiplier: 1, constant: 0)
        let centerY = NSLayoutConstraint(item: label, attribute: .centerY, relatedBy: .equal, toItem: view, attribute: .centerY, multiplier: 1, constant: 0)
        label.addConstraint(widthC)
        view.addConstraints([centerX,centerY])
        view.layoutIfNeeded()
        return label.frame.size
        
    }
}
extension UILabel{
    
    /// 创建Label(包含标题、字体颜色、字体大小、对齐方式)
    /// - Parameters:
    ///   - title: 标题
    ///   - fontColor: 字体颜色
    ///   - font: 字体大小
    ///   - alignment: 对齐方式
    convenience init(title: String?, fontColor: UIColor?, fonts: UIFont?, alignment:NSTextAlignment) {
        self.init()
        text = title
        textColor = fontColor
        lineBreakMode = .byTruncatingTail
        if fonts != nil {
            font = fonts
        }
        textAlignment = alignment
    }
    /// 创建Label-换肤模式 (包含标题、字体颜色、字体大小、对齐方式)
    /// - Parameters:
    ///   - title: 标题
    ///   - fontColorArr: 标题不同皮肤的颜色值的的数组 eg[0xFF0000、"#FF0000"、“FF0000”]
    ///   - font: 字体大小
    ///   - alignment: 对齐方式
    convenience init(title: String?, fontColorArr: [String]?, fonts: UIFont?, alignment:NSTextAlignment) {
        self.init()
        text = title
        let order:Int = HSAppThemeManager.nowTheme().rawValue
        if fontColorArr != nil && fontColorArr!.count > 0  {
            textColor = UIColor.init(fontColorArr![order])
        }
        if fonts != nil {
            font = fonts
        }
        lineBreakMode = .byTruncatingTail
        textAlignment = alignment
    }
}
