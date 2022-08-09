//
//  UITextField+AS.swift
//  huiSenSmart
//
//  Created by jonkersun on 2021/4/28.
//

import UIKit

public extension AriSwift where Base : UITextField{
    
}

public extension UITextField {
    /// 初始化UITextField（文本字体的颜色、字体大小、含占位文字）
    /// - Parameters:
    ///   - placeholders: 占位文字
    ///   - title: 默认文字
    ///   - fontColor: 字体的颜色
    ///   - textFont: 字体
    convenience init(placeholders: String?, title: String?, textColors: UIColor?, textFont: UIFont?) {
        self.init()
        if title != nil {
            text = title
        }
        if placeholders != nil {
            placeholder = placeholders
        }
        if textColors != nil {
            textColor = textColors
        }
        if textFont != nil {
            font = textFont
        }
    }

    /// 初始化UITextField（含文本及占位文字的字体的颜色和字体大小，键盘类型，是否有圆角）
    /// - Parameters:
    ///   - textColors: 字体的颜色
    ///   - textFont: 字体大小
    ///   - placeholders: 含占位文字
    ///   - placeholdersFont: 占位字体大小
    ///   - placeholdersColor: 占位文字颜色
    ///   - cornerRadius: 圆角,大于0就有圆角
    ///   - layColor: 边框颜色
    ///   - boardStyle: 设置边框样式
    ///   - keyBoardStyles: 键盘样式
    ///   - leftWidth: 输入起始位置
    ///   - rightWidth: 输入最后位置
    convenience init(textColors:UIColor?, textFont: UIFont?, placeholders: String?, placeholdersFont: UIFont?, placeholdersColor: UIColor?, cornerRadius:CGFloat, layColor:UIColor?, boardStyle:BorderStyle!, keyBoardStyles:UIKeyboardType!, leftWidth:CGFloat = 15, rightWidth:CGFloat = 15) {
        self.init()
        if placeholders != nil {
            placeholder = placeholders
        }
        if textColors != nil {
            textColor = textColors
        }
        if textFont != nil {
            font = textFont
        }
        if placeholdersFont != nil || placeholdersColor != nil{
            var tempAttr = [NSAttributedString.Key : Any]()
            if placeholdersFont != nil {
                tempAttr[NSAttributedString.Key.font] = placeholdersFont
            }
            if placeholdersColor != nil {
                tempAttr[NSAttributedString.Key.foregroundColor] = placeholdersColor
            }
            let attr:NSAttributedString = NSAttributedString.init(string:placeholders ?? "", attributes: tempAttr)
            attributedPlaceholder = attr
        }
        keyboardType = keyBoardStyles
        leftView = UIView.init(frame:CGRect(x: 0, y: 0, width: leftWidth, height: 0))
        leftView?.isUserInteractionEnabled = true
        leftViewMode = .always
        rightView = UIView.init(frame:CGRect(x: 0, y: 0, width: rightWidth, height: 0))
        rightView?.isUserInteractionEnabled = true
        rightViewMode = .always
        if cornerRadius>0.0 {
            layer.cornerRadius = cornerRadius
        }
        if layColor != nil  {
            layer.borderColor = layColor!.cgColor
            layer.borderWidth = 0.5
        }
        inputAccessoryView = UIView()
        keyboardType = keyBoardStyles
    }
    
    /// 初始化UITextField - 换肤模式（文本字体的颜色、字体大小、含占位文字）
    /// - Parameters:
    ///   - placeholders: 占位文字
    ///   - title: 默认文字
    ///   - textColorsArr: 标题不同皮肤的颜色值的的数组 eg[0xFF0000、"#FF0000"、“FF0000”]
    ///   - textFont: 字体
    
    convenience init(placeholders: String?, title: String?, textColorsArr: [String]?, textFont: UIFont?) {
        self.init()
        if title != nil {
            text = title
        }
        if placeholders != nil {
            placeholder = placeholders
        }
        let order:Int = HSAppThemeManager.nowTheme().rawValue
        if textColorsArr != nil && textColorsArr!.count>0{
            textColor = UIColor.init(textColorsArr![order])
        }
        if textFont != nil {
            font = textFont
        }
    }

    /// 初始化UITextField-换肤模式（含文本及占位文字的字体的颜色和字体大小，键盘类型，是否有圆角）
    /// - Parameters:
    ///   - textColorsArr: 标题不同皮肤的颜色的的数组
    ///   - textFont: 字体大小
    ///   - placeholders: 含占位文字
    ///   - placeholdersFont: 占位字体大小
    ///   - placeholdersColorArr: 占位不同皮肤的颜色值的的数组 eg[0xFF0000、"#FF0000"、“FF0000”]
    ///   - cornerRadius: 圆角,大于0就有圆角
    ///   - layColorArr: 边框不同皮肤的颜色值的的数组 eg[0xFF0000、"#FF0000"、“FF0000”]
    ///   - boardStyle: 设置边框样式
    ///   - keyBoardStyles: 键盘样式
    ///   - leftWidth: 输入起始位置
    ///   - rightWidth: 输入最后位置
    convenience init(textColorsArr:[String]?, textFont: UIFont?, placeholders: String?, placeholdersFont: UIFont?, placeholdersColorArr: [String]?, cornerRadius:CGFloat, layColorArr:[String]?, boardStyle:BorderStyle!, keyBoardStyles:UIKeyboardType!, leftWidth:CGFloat = 15, rightWidth:CGFloat = 15) {
        self.init()
        let order:Int = HSAppThemeManager.nowTheme().rawValue

        if placeholders != nil {
            placeholder = placeholders
        }
        if textColorsArr != nil && textColorsArr!.count>0 {
            textColor = UIColor.init(textColorsArr![order])
        }
        if textFont != nil {
            font = textFont
        }
        if placeholdersFont != nil || (placeholdersColorArr != nil && placeholdersColorArr!.count>0){
            var tempAttr = [NSAttributedString.Key : Any]()
            if placeholdersFont != nil {
                tempAttr[NSAttributedString.Key.font] = placeholdersFont
            }
            if placeholdersColorArr != nil && placeholdersColorArr!.count>0 {
                tempAttr[NSAttributedString.Key.foregroundColor] = UIColor.init(placeholdersColorArr![order])
            }
            let attr:NSAttributedString = NSAttributedString.init(string:placeholders ?? "", attributes: tempAttr)
            attributedPlaceholder = attr
        }
        keyboardType = keyBoardStyles
        if leftWidth > 0 {
            leftView = UIView.init(frame:CGRect(x: 0, y: 0, width: leftWidth, height: 0))
            leftView?.isUserInteractionEnabled = false
            leftViewMode = .always
        }
        if rightWidth > 0 {
            rightView = UIView.init(frame:CGRect(x: 0, y: 0, width: rightWidth, height: 0))
            rightView?.isUserInteractionEnabled = false
            rightViewMode = .always
        }
        if cornerRadius>0.0 {
            layer.cornerRadius = cornerRadius
        }
        if layColorArr != nil && layColorArr!.count>0{
            layer.borderColor = UIColor.init(layColorArr![order]).cgColor
            layer.borderWidth = 0.5
        }
        inputAccessoryView = UIView()
        keyboardType = keyBoardStyles
    }
}
