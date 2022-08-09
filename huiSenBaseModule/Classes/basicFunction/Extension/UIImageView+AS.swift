//
//  UIImageView+AS.swift
//  huiSenSmart
//
//  Created by jonkersun on 2021/4/29.
//

import UIKit
public extension AriSwift where Base: UIImageView {
    
}

public extension UIImageView {
    
    /// 创建可以换色的ImageView （tintColor为空不变色）
    /// - Parameter imageName: 图片名称
    /// - tintColor: 图片需要的变色色值--eg:0xFF0000、"#FF0000"、“FF0000”
    convenience init(imageName: String, tintColor: String? = nil) {
        let tempImage = UIImage.as.imageNamed(imageName)
        if tintColor == nil {
            self.init(image: tempImage)
        }else {
            self.init(image: tempImage.withRenderingMode(.alwaysTemplate))
            self.tintColor = UIColor.init(tintColor)
        }
    }
    
    /// 创建ImageView - 换肤模式
    /// - Parameter imageName: 图片名称
    convenience init(imageNameAppTheme: String) {
        self.init()
        image = UIImage.as.imageNamed(HSAppThemeManager.themeImageNameSuffix(imageNameAppTheme))
    }
}
