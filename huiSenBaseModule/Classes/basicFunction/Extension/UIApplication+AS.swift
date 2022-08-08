//
//  UIApplication+AS.swift
//  huiSenSmart
//
//  Created by jonkersun on 2021/4/14.
//  Copyright © 2021 Grand. All rights reserved.
//


import Foundation
import UIKit
public extension AriSwift where Base: UIApplication {
    static var isNewVersion: Bool {
        let infoDic = Bundle.main.infoDictionary
        let currentVersion = infoDic?["CFBundleShortVersionString"] as? String
        
        // 2.2 获取之前存储的版本号
        let userDefault = UserDefaults.standard
        let oldVersion = userDefault.object(forKey: "app_version") as? String
        
        if oldVersion == currentVersion {
            return false
        }else{
            userDefault.set(currentVersion, forKey: "app_version")
            userDefault.synchronize()
            return true
        }
    }
    static var version: String {
        let infoDic = Bundle.main.infoDictionary
        return (infoDic?["CFBundleShortVersionString"] as? String) ?? "1.0.0"
    }
    
    /// 获取keyWindow
    static var keyWindow: UIWindow? {
        var window: UIWindow?
        if #available(iOS 13.0, *) {
            window = UIApplication.shared.windows.filter({ $0.isKeyWindow }).last
        } else {
            window = UIApplication.shared.keyWindow
        }
        return window
    }
    
    /// 获取最后一次Present的VC
    static var lastPresentedViewController: UIViewController? {
        let window = UIApplication.as.keyWindow
        var presentedViewController = window?.rootViewController
        while presentedViewController?.presentedViewController != nil {
            presentedViewController = presentedViewController?.presentedViewController
        }
        return presentedViewController
    }
}
