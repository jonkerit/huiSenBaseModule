//
//  UIButton+AS.swift
//  huiSenSmart
//
//  Created by jonkersun on 2021/4/28.
//

import UIKit

public extension AriSwift where Base: UIButton {

}
public extension UIButton {
    
    /// 创建button(含标题、标题颜色、标题字体、图名称、背景图名称、目标对象、selector事件、变色)（tintColor为空不变色）

    /// - Parameters:
    ///   - title: 标题
    ///   - titleColor: 标题颜色
    ///   - titleFont: 标题字体
    ///   - imageName: 图名称
    ///   - backGroudImgName: 背景图名称
    ///   - target: 目标对象
    ///   - action: selector事
    ///   - tintColor: 图片需要的变色色值--eg:0xFF0000、"#FF0000"、“FF0000”
    convenience init(title:String?, titleColor:UIColor?, titleFont:UIFont?, imageName:String?, backGroudImgName:String?, target:AnyObject?, action:Selector?, tintColor: String? = nil) {
        self.init()
        if title != nil {
            setTitle(title, for: .normal)
        }
        if titleColor != nil {
            setTitleColor(titleColor, for: .normal)
        }
        if titleFont != nil {
            titleLabel?.font = titleFont
        }
        if imageName != nil && !imageName!.isEmpty {
            let img = UIImage.as.imageNamed(imageName!)
            if tintColor == nil {
                setImage(img, for: .normal)
            } else {
                setImage(img.withRenderingMode(.alwaysTemplate), for: .normal)
                self.tintColor = UIColor.init(tintColor)
            }
        }
        if backGroudImgName != nil && !backGroudImgName!.isEmpty {
            let img = UIImage.as.imageNamed(backGroudImgName!)
            if tintColor == nil {
                setBackgroundImage(img, for: .normal)
            } else {
                setBackgroundImage(img.withRenderingMode(.alwaysTemplate), for: .normal)
                self.tintColor = UIColor.init(tintColor)
            }
        }
        titleLabel?.lineBreakMode = .byTruncatingTail
        adjustsImageWhenHighlighted = false
        if action != nil && target != nil{
            addTarget(target, action: action!, for: .touchUpInside)
        }
    }
    
    /// 创建button-换肤模式 (含标题、标题颜色、标题字体、图名称、背景图名称、目标对象、selector事件)

    /// - Parameters:
    ///   - title: 标题
    ///   - titleColorArr: 标题不同皮肤的颜色值的的数组 eg[0xFF0000、"#FF0000"、“FF0000”]
    ///   - titleFont: 标题字体
    ///   - imageName: 图名称
    ///   - backGroudImgName: 背景图名称
    ///   - backGroudColArr: 背景不同皮肤的颜色值的的数组 eg[0xFF0000、"#FF0000"、“FF0000”]
    ///   - target: 目标对象
    ///   - action: selector事
    convenience init(title:String?, titleColorArr:[String]?, titleFont:UIFont?, imageName:String?, backGroudImgName:String?,backGroudColArr:[String]?, target:AnyObject?, action:Selector?) {
        self.init()
        if title != nil {
            setTitle(title, for: .normal)
        }
        titleLabel?.lineBreakMode = .byTruncatingTail
        adjustsImageWhenHighlighted = false
        let order:Int = HSAppThemeManager.nowTheme().rawValue
        if titleColorArr != nil && titleColorArr!.count > 0  {
            setTitleColor(UIColor.init(titleColorArr![order]), for: .normal)
        }
        if titleFont != nil {
            titleLabel?.font = titleFont
        }
        if imageName != nil && !imageName!.isEmpty {
            setImage(UIImage.as.imageNamed(HSAppThemeManager.themeImageNameSuffix(imageName!)), for: .normal)
        }
        if backGroudImgName != nil {
            setBackgroundImage(UIImage.as.imageNamed(HSAppThemeManager.themeImageNameSuffix(backGroudImgName!)), for: .normal)
        }
        if backGroudColArr != nil {
            backgroundColor = UIColor.init(backGroudColArr![order])
        }
        if action != nil && target != nil{
            addTarget(target, action: action!, for: .touchUpInside)
        }
    }

    /// 设置UIButton内容的位置(图片和文字的位置)
    /// - Parameters:
    ///   - image: 图片
    ///   - title: 标题
    ///   - titlePosition:
    ///   - additionalSpacing:
    ///   - state:
    ///   - offset:
    ///   - fontSize:
    func setButtonContentPosition(imageName: String?,title:String,titlePosition: UIView.ContentMode,additionalSpacing: CGFloat,state: UIControl.State, offset: CGFloat = 0, fontSize: CGFloat = 12) {
        
        self.setTitle(title, for: state)
        self.setImage(UIImage.as.imageNamed(HSAppThemeManager.themeImageNameSuffix(imageName!)), for: state)
        positionLabelRespectToImage(title: title, position: titlePosition, offset: offset, fontSize: fontSize, spacing: additionalSpacing)
    }
    
    private func positionLabelRespectToImage(title:String,position:UIView.ContentMode, offset: CGFloat, fontSize: CGFloat, spacing:CGFloat){
        let imageSize = self.imageRect(forContentRect: self.frame)
        let titleFont = self.titleLabel?.font
        let titleSize = title.size(withAttributes: [NSAttributedString.Key.font: titleFont!])
        
        var titleInsets : UIEdgeInsets
        var imageInsets : UIEdgeInsets
        
        switch position {
        case .top:
            titleInsets = UIEdgeInsets(top: offset - (imageSize.height + titleSize.height + spacing),
                                       left: -(imageSize.width), bottom: 0, right: 0)
            imageInsets = UIEdgeInsets(top: offset, left: 0, bottom: 0, right: -(CGFloat(title.count) * fontSize))
        case .bottom:
            titleInsets = UIEdgeInsets(top: offset + (imageSize.height + titleSize.height + spacing),
                                       left: -(imageSize.width), bottom: 0, right: 0)
            imageInsets = UIEdgeInsets(top: offset, left: 0, bottom: 0, right: -titleSize.width)
        case .left:
            titleInsets = UIEdgeInsets(top: 0, left: -(imageSize.width * 2 + spacing), bottom: 0, right: 0)
            imageInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0,
                                       right: -(titleSize.width * 2 + spacing))
        case .right:
            titleInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: -spacing)
            imageInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
            
        default:
            titleInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
            imageInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        }
        self.titleEdgeInsets = titleInsets
        self.imageEdgeInsets = imageInsets
    }

    /// 去除button的高亮
    open override var isHighlighted: Bool{
        set{
            
        }
        get {
            return false
        }
    }
}

