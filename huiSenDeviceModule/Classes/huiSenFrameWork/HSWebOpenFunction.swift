//
//  HSWebOpenFunction.swift
//  huiSenSmart
//
//  Created by jonker.sun on 2022/2/21.
//

import UIKit

public class HSWebOpenFunction: NSObject {
    @objc public static var shared: HSWebOpenFunction = HSWebOpenFunction()
    
    /// 配置项
    /// 设置相关信息
    @objc public var deviceInfoDictionary: [String: Any]?
    /// 是否是成员权限（成员不能删除修改设备）
    @objc public var isMemberRole: Bool = false
    /// 登录信息
    @objc public var SDKTokenString: String!
    /// homeID
    @objc public var homeIdString: String!
    /// 是否需要更多
    @objc public var isHaveDeviceMore: Bool = true
    /// 产品ID
    @objc public var productID: String!
    /// 设备ID
    @objc public var deviceID: String!
    
    // MARK: - LifeCycle
    
    // MARK: - Public
    @objc public func showDeviceDetail(_ vc:UIViewController) {
        let deviceInfo = ["device_id":deviceID,"product_id":productID,"device_name": ""]
        let webVC:HSWebViewController = HSWebViewController()
        webVC.deviceInfo = deviceInfo as? [String: String]
        if vc.navigationController == nil {
            let nav = HSBaseNavigationController.init(rootViewController: webVC)
            nav.modalPresentationStyle = .custom
            nav.view.backgroundColor = .clear
            nav.setNavigationBarHidden(true, animated: false)
            vc.present(nav, animated: false, completion: nil)
        }else{
            vc.navigationController!.pushViewController(webVC, animated: false)
        }
    }
     
    @objc public func showH5(vc:UIViewController, deviceInfo: [String: String]) {
        let webVC:HSWebViewController = HSWebViewController()
        webVC.deviceInfo = deviceInfo
        if vc.navigationController == nil {
            let nav = HSBaseNavigationController.init(rootViewController: webVC)
            nav.modalPresentationStyle = .custom
            nav.view.backgroundColor = .clear
            nav.setNavigationBarHidden(true, animated: false)
            vc.present(nav, animated: false, completion: nil)
        }else{
            vc.navigationController!.pushViewController(webVC, animated: false)
        }
    }
    
}
