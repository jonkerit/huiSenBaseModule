//
//  UIScreen+AS.swift
//  huiSenSmart
//
//  Created by jonkersun on 2021/4/14.
//  Copyright © 2021 Grand. All rights reserved.
//


import Foundation
import UIKit
public extension AriSwift where Base: UIScreen {

    /// statusBar height
    static var statusBarHeight: CGFloat {
        if #available(iOS 13.0, *) {
            let statusBarManager = UIApplication.shared.windows.first?.windowScene?.statusBarManager
            return statusBarManager?.statusBarFrame.size.height ?? 0.0
        } else {
            return UIApplication.shared.statusBarFrame.size.height
        }
    }
    /// navBar heihgt
    static var navBarHeight: CGFloat {
        return statusBarHeight + 44
    }
    /// tabBar heihgt
    static var tabBarHeight: CGFloat {
        return tabBarSafeHeight + 49
    }
    /// tabBar safe height
    static var tabBarSafeHeight: CGFloat {
        return (statusBarHeight > 20) ? 34:0
    }
    /// screen Width
    static var screenWidth: CGFloat {
        return UIScreen.main.bounds.width
    }
    /// screen Height
    static var screenHeight: CGFloat {
        return UIScreen.main.bounds.height
    }
    /// 4 4s
    static var is4s: Bool {
        return UIScreen.main.currentMode?.size == CGSize(width: 640, height: 960)
    }
    /// 5 5s 5c se
    static var is5: Bool {
        return UIScreen.main.currentMode?.size == CGSize(width: 640, height: 1136)
    }
    /// 6 6s 7 8
    static var is6: Bool {
        return UIScreen.main.currentMode?.size == CGSize(width: 750, height: 1334)
    }
    /// 6p 6sp 7p 8p
    static var is6plus: Bool {
        return UIScreen.main.currentMode?.size == CGSize(width: 1242, height: 2208)
    }
    /// x xs
    static var isX: Bool {
        return UIScreen.main.currentMode?.size == CGSize(width: 1125, height: 2436)
    }
    /// xr
    static var isXR: Bool {
        return UIScreen.main.currentMode?.size == CGSize(width: 828, height: 1792)
    }
    /// xsmax
    static var isXMax: Bool {
        return UIScreen.main.currentMode?.size == CGSize(width: 1242, height: 2688)
    }

}
