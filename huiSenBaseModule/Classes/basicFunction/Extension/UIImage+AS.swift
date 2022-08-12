//
//  UIImage+AS.swift
//  huiSenSmart
//
//  Created by jonkersun on 2021/4/14.
//  Copyright © 2021 Grand. All rights reserved.
//


import Foundation
import UIKit

/// 缓存本SDK的资源位置
fileprivate var huiSenFrameWorkSourceBundle:Bundle?
public extension AriSwift where Base: UIImage {
    
    /// 获取屏幕截图的图片
    /// - Returns: 屏幕截图
    static func getScreenSnap() -> UIImage?{
        //获取到window
        if #available(iOS 13.0, *) {
            let window = UIApplication.shared.windows.first
            return window?.as.obtainViewSnap()
        } else {
            let window = UIApplication.shared.keyWindow
            return  window?.as.obtainViewSnap()
        }
    }
    
    /// 生成指定颜色背景的图片
    ///
    /// - Parameters:
    ///   - color:
    ///   - size:
    /// - Returns: 指定颜色背景的图片
    static func image(with color: UIColor, size: CGSize = CGSize(width: 1, height: 1)) -> UIImage {
        let rect = CGRect(x: 0, y: 0, width: size.width, height: size.height)
        UIGraphicsBeginImageContext(rect.size)
        let context = UIGraphicsGetCurrentContext()
        context?.setFillColor(color.cgColor)
        context?.fill(rect)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image!
    }
    
    /// 获取一个带边框和颜色的image图
    /// - Parameters:
    ///   - rect: 图的尺寸
    ///   - backGroudColor: 图片的底色
    ///   - lineWidth: 边框的宽度
    ///   - lineColor: 边框的颜色
    ///   - cornerRadius: 圆角
    ///   - lineDashPattern: 虚线设置【实线长度，虚线长度】--- 不传则为实线
    /// - Returns: 一张图片
    static func obtainImageWithBorderLine(size:CGSize, backgroundColor:UIColor,lineWidth: CGFloat, lineColor: UIColor, cornerRadius:CGFloat, lineDashPattern: [NSNumber]?) -> UIImage{
        var tempView = UIView.init(frame: CGRect(x: 0, y: 0, width: size.width, height: size.height))
        tempView.backgroundColor = backgroundColor
        if lineWidth>0.0 {
            tempView.as.addBorderLine(lineWidth: lineWidth, lineColor: lineColor, cornerRadius: cornerRadius, lineDashPattern: lineDashPattern)
        }else if cornerRadius>0.0{
            tempView.as.cornerRadius = cornerRadius
        }
        return tempView.as.obtainViewSnap() ?? UIImage.init()
    }
    
    /// 先加载Assets中的资源，如果失败就加载bundle里面资源（主要是针对我们的SDK）
    static func imageNamed(_ name:String, _ bundleName: String = "huiSenBundle") ->UIImage {
        guard let tempImage = UIImage.init(named: name) else {
            var sourceBundle:Bundle?
            if huiSenFrameWorkSourceBundle != nil {
                sourceBundle = huiSenFrameWorkSourceBundle
            }else if let tempBundle = getBundle(bundleName: bundleName, swiftClass: HSNowVCClass){
                sourceBundle = tempBundle
                huiSenFrameWorkSourceBundle = tempBundle
            }else{
                var myFrameworkBunlde:Bundle?
                for frameworkBundel in Bundle.allFrameworks {
                    if frameworkBundel.bundlePath.contains("iOS_libHuiSenFrameWork.framework") {
                        myFrameworkBunlde = frameworkBundel
                        break
                    }
                }
                guard let urlPath = myFrameworkBunlde?.path(forResource: bundleName, ofType: "bundle") else {
                    return UIImage()}
                sourceBundle = Bundle.init(path: urlPath)
                huiSenFrameWorkSourceBundle = sourceBundle
            }
            if #available(iOS 13.0, *) {
                return UIImage.init(named: "\(name)@\(Int(UIScreen.main.scale))x.png", in: sourceBundle, with: nil) ?? UIImage()
            } else {
                return UIImage.init(named: "\(name)@\(Int(UIScreen.main.scale))x.png", in: sourceBundle, compatibleWith: nil) ?? UIImage()
            }
        }
        return tempImage
    }
    
    static func getBundle(bundleName: String, swiftClass:  Swift.AnyClass)-> Bundle? {
        let frameworkBundle = Bundle.as.bundlePath(swiftClass: swiftClass, resource: "huiSenFrameWork", ofType: "framework")
        guard let sourcepath = frameworkBundle.path(forResource: bundleName, ofType: "bundle") else { return nil }
        guard let sourceBundle = Bundle.init(path: sourcepath) else { return nil }
        return sourceBundle
    }
    
    /// 对纯色图片改变颜色
    /// - Parameters:
    ///   - tintColor: 需要的颜色值--0xFF0000、"#FF0000"、“FF0000”
    ///   - blendMode: model
    /// - Returns: 
    func imageWithTintColor(_ tintColor:String) -> UIImage {
        if #available(iOS 13.0, *) {
            return base.withTintColor(UIColor.init(tintColor), renderingMode: .automatic)
        } else {
            UIGraphicsBeginImageContextWithOptions(base.size, false, 0.0)
            UIColor.init(tintColor).setFill()
            let bounds = CGRect(x: 0, y: 0, width: base.size.width, height: base.size.height)
            UIRectFill(bounds)
            base.draw(in: bounds, blendMode: .overlay, alpha: 1.0)
            base.draw(in: bounds, blendMode: .destinationIn, alpha: 1.0)
            let tintedImage = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
            return tintedImage ?? base
        }
    }

    
    
    //缩放到指定宽度
    func scale(to width: CGFloat) -> UIImage{
        if base.size.width < width {
            return base
        }
        let height = base.size.height * (width / base.size.width)
        
        let rect = CGRect(x: 0, y: 0, width: width, height: height)
        //开启上下文
        UIGraphicsBeginImageContext(rect.size)
        //会将当前图片的所有内容完整的画到上下文中
        base.draw(in: rect)
        let result = UIGraphicsGetImageFromCurrentImageContext()!
        //关闭上下文
        UIGraphicsEndImageContext()
        return result
    }
        
    /// 给图片加文字水印
    /// - Parameters:
    ///   - markString: 水印文字
    ///   - starPoint: 水印开始位置
    ///   - markColor: 水印颜色
    ///   - markFont: 水印字体大小
    /// - Returns: 带水印的图片
    func imageWithStringWaterMark(markString: String!, starPoint: CGPoint?, markColor:UIColor!, markFont:UIFont!) -> UIImage {

        if Float(UIDevice.current.systemVersion) ?? 0.0 >= 4.0 {
            UIGraphicsBeginImageContextWithOptions(base.size, false, 0.0)
        }else{
            UIGraphicsBeginImageContext(base.size)
        }
        base.draw(in: CGRect(x: 0, y: 0, width: base.size.width, height: base.size.height))
        markColor.set()
        let style = NSMutableParagraphStyle.init()
        style.alignment = .center
        let tempStr:NSString = NSString(string: markString)
        let size = markString.as.size(font: markFont, maxSize: CGSize(width: base.size.width - (starPoint?.x ?? 0.0), height: base.size.height - (starPoint?.y ?? 0.0)), lineMargin: 0)
        let rect = CGRect(x: starPoint?.x ?? 0.0, y:  starPoint?.y ?? 0.0, width: size.width, height: size.height)
        tempStr.draw(in: rect, withAttributes: [.foregroundColor:markColor!,.font:markFont!,.paragraphStyle:style])
        let resultImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return resultImage ?? base
    }
}
