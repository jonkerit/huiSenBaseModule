//
//  HSProgressHUD.swift
//  huiSenSmart
//
//  Created by jonkersun on 2021/7/2.
//

import UIKit
import HSProgressHUD

enum HSProgressHUDUserInteractionType {
    /// 全屏交互
    case allInteractionType
    /// 全屏不能交互
    case noInteractionType
    /// navbar能交互
    case navBarInteractionType
    /// navbar和tabar能交互
    case navAndTabarInteractionType
}
@objcMembers public class HSProgressHUD: JKProgressHUD {

    static var share:HSProgressHUD = HSProgressHUD()
    /// 动画图片名称前缀
    var imageName = "HSRefresh_" {
        didSet{
            imageArray = createImgArr()
        }
    }
    /// 可交互的区域type
    private var userInteractionType:HSProgressHUDUserInteractionType = .allInteractionType {
        didSet {
            let keyWindow = UIApplication.as.keyWindow ?? UIWindow()
            var rect = keyWindow.bounds
            switch userInteractionType {
            case .allInteractionType:
                rect = CGRect.zero
                break
            case .noInteractionType:
                rect = keyWindow.bounds
                break
            case .navBarInteractionType:
                rect = CGRect(x: 0, y: UIScreen.as.navBarHeight, width: rect.width, height: rect.height-UIScreen.as.navBarHeight)
                break
            case .navAndTabarInteractionType:
                rect = CGRect(x: 0, y: UIScreen.as.navBarHeight, width: rect.width, height: rect.height-UIScreen.as.navBarHeight-UIScreen.as.tabBarHeight)
                break
            }
            noInteractionsView.frame = rect
        }
    }
    
    // 重写父类的消息方法，设置遮罩的frame为0
    public override class func dismiss(withDelay delay: TimeInterval, completion: JKProgressHUDDismissCompletion? = nil) {
        super.dismiss(withDelay: delay, completion: completion)
        HSProgressHUD.share.noInteractionsView.frame = CGRect.zero
    }
    
    // 加载动图的图片数组
    private func createImgArr()->[UIImage]{
        var tempArr = [UIImage]()
        for i in 0..<21 {
            let image = UIImage.init(named: imageName+String(i))
            if image != nil {
                tempArr.append(image!)
            }
        }
        return tempArr
    }
    
    static private func customProgressHUD() {
        HSProgressHUD.setCornerRadius(10)
        HSProgressHUD.setDefaultMaskType(.none)
        HSProgressHUD.setFont(UIFont.font(name: .regular, size: 16))
        HSProgressHUD.setBackgroundColor(UIColor.init("#000000",alpha:0.7))
        HSProgressHUD.setForegroundColor(UIColor.init("#FFFFFF"))
    }
    static private func customAnimationProgressHUD() {
        HSProgressHUD.setCornerRadius(10)
        HSProgressHUD.setDefaultMaskType(.none)
        HSProgressHUD.setFont(UIFont.font(name: .regular, size: 13))
        HSProgressHUD.setBackgroundColor(UIColor.clear)
        HSProgressHUD.setForegroundColor(UIColor.init(HSAppThemeModel.wordGay))
    }
    static private func customNoNetworkProgressHUD() {
        HSProgressHUD.setCornerRadius(10)
        HSProgressHUD.setDefaultMaskType(.none)
        HSProgressHUD.setFont(UIFont.font(name: .regular, size: 15))
        HSProgressHUD.setBackgroundColor(UIColor.init("#FFF4F4",alpha:0.7))
        HSProgressHUD.setForegroundColor(UIColor.init(HSAppThemeModel.wordMain))
    }
    // 动图的图片数组
    lazy private var imageArray: [UIImage] = createImgArr()
    // 加载遮罩
    lazy private var noInteractionsView:UIView = {
        var keyWindow = UIWindow()
        if #available(iOS 13.0, *) {
            keyWindow = UIApplication.shared.windows.first ?? UIWindow()
        } else {
            keyWindow = UIApplication.shared.keyWindow ?? UIApplication.shared.windows.first!;
        }
        let view = UIView.init(frame: keyWindow.bounds)
        keyWindow.addSubview(view)
        return view
    }()
}

extension HSProgressHUD{
    /// 有加载动画的toast
    /// - Parameters:
    ///   - discribeStr: 提示语
    ///   - maskType: 设置可交互模式
    ///   - dismiss: 是否自动消失
    ///   - delayTime: 延迟多久消失--dismiss为True时，delayTime必须大于0
    ///   - userInteractionType: 能交互的区域
    static func showAnimation(discribeStr:String? = "努力加载中...", dismiss:Bool = false, delayTime:TimeInterval = 1.5, userInteractionType:HSProgressHUDUserInteractionType = .allInteractionType){
        customAnimationProgressHUD()
        HSProgressHUD.share.userInteractionType = userInteractionType
        HSProgressHUD.showImageAnimation(HSProgressHUD.share.imageArray, status: discribeStr)
        if dismiss && delayTime>0 {
            Timer.as.timerDelay(by: delayTime) {
                HSProgressHUD.dismiss()
            }
        }
        // 还原默认动画
        if HSProgressHUD.share.imageName != "HSRefresh_" {
            HSProgressHUD.share.imageName = "HSRefresh_"
        }
    }
    
    /// 只有提示语得toast
    /// - Parameters:
    ///   - discribeStr: 提示语
    ///   - dismiss: 是否自动消失
    ///   - delayTime: 延迟多久消失--dismiss为True时，delayTime必须大于0
    ///   - userInteractionType: 能交互的区域
    static func showMessage(discribeStr:String? = "加载中", dismiss:Bool = false, delayTime:TimeInterval = 1.5, userInteractionType:HSProgressHUDUserInteractionType = .allInteractionType){
        var tempString = discribeStr
        if discribeStr == "no network" {
            tempString = "网络异常，请检查网络连接。"
            customNoNetworkProgressHUD()
        }else{
            customProgressHUD()
        }
        HSProgressHUD.share.userInteractionType = userInteractionType
        HSProgressHUD.showImageAnimation(nil, status: tempString)
        if dismiss && delayTime>0 {
            Timer.as.timerDelay(by: delayTime) {
                HSProgressHUD.dismiss()
            }
        }
    }
    
    /// 重写show方法，实现自定义UI
    override public static func show() {
        showAnimation(discribeStr: nil, dismiss: false, userInteractionType: .allInteractionType)
    }
}
