//
//  UIViewController+AS.swift
//  huiSenSmart
//
//  Created by jonkersun on 2021/4/29.
//

import UIKit

public extension AriSwift where Base : UIViewController {
    /// 获取当前控制器
    /// - Returns: 当前控制器
   static func currentVC() -> UIViewController{
       let window:UIWindow =  UIApplication.as.keyWindow ?? UIWindow()
       var rootVC:UIViewController = window.rootViewController ?? UIViewController()
       
       if (rootVC.presentingViewController != nil) {
           rootVC = rootVC.presentingViewController!
       }else if rootVC.isKind(of: UINavigationController.classForCoder()){
           let navVC:UINavigationController = rootVC as! UINavigationController
           rootVC = navVC.children.last!
       }else if rootVC.isKind(of: UITabBarController.classForCoder()){
           let tabarVC:UITabBarController = rootVC as! UITabBarController
           rootVC = tabarVC.selectedViewController!
           let childCount:NSInteger = rootVC.children.count
           if childCount>0 {
               rootVC = rootVC.children.last!
           }
       }else{
           let childCount:NSInteger = rootVC.children.count
           if childCount>0 {
               rootVC = rootVC.children.last!
           }
       }
       return rootVC
    }

    /// 返回className
    var className:String{
        get{
            let name =  type(of: base).description()
            if(name.contains(".")){
                return name.components(separatedBy: ".")[1]
            }else{
                return name
            }
        }
    }
    
    /// 设置有无手势
    func isCanPushing(_ push:Bool){
        base.navigationController?.interactivePopGestureRecognizer?.isEnabled = push
    }
}
