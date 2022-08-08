//
//  HSWebViewController+MessageHandle.swift
//  huiSenSmart
//
//  Created by jonker.sun on 2022/4/25.
//

import Foundation
import WebKit

// MARK: ---- 处理JS调用的原生方法
extension HSWebViewController:WKScriptMessageHandler{
    // MARK: - pubilc方法
    /// web数据饭回
    func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
        #if huiSenSmart
        HSDebugLog("name:\(message.name)\\\\n body:\(message.body)\\\\n frameInfo:\(message.frameInfo)\\\\n")
        #endif
        userInfoMehod(message: message)
    }
    
   // MARK: - private方法
    private func userInfoMehod(message: WKScriptMessage){
        let methodName = message.name
        // body 不带参数
        if methodName == HSH5VibrationMehod {
            h5SystemVibration("1")
            return
        }
        // 处理body不是json数据的方法
        guard let body = message.body as? String else { return  }
        if methodName == HSH5HanlderToastMehod {
            toastShow(body)
            return
        }
        
        
        /// 下面是处理有json数据的方法
        guard let dict = stringValueDiction(body) else { return  }
        // 缓存回调方法
        if dict.keys.contains(HSH5CallBackName) && dict[HSH5CallBackName] is String{
            callbackMethodCache[message.name] = (dict[HSH5CallBackName] as! String)
        }
        
        if methodName == HSH5GetDeviceInfoMehod {
            getDeviceInfo(mehodName: methodName)
        }else if methodName == HSH5GetOperationMehod {
            operationDevice(mehodName: methodName, dict: dict)
        }else if methodName == HSH5GetDeviceAttributeMehod {
            getDevicePropertyInfo(mehodName: methodName, dict: dict)
        }else if methodName == HSH5HandlerDialogMehod {
            showActionAlterView(dict: dict)
        }else if methodName == HSH5PageChangeMehod {
            h5PageChange(dict: dict)
        }else if methodName == HSH5HandlerApiMehod {
            h5requsetData(mehodName: methodName, dict: dict)
        }else{
            #if huiSenSmart
            HSDebugLog("没有处理该方法\(methodName)")
            #endif
        }
    }
    
    // 获取设备信息
    private func getDeviceInfo(mehodName: String) {
        HSDeviceViewModel.loadDeviceInfo(deviceID: deviceInfo["device_id"] ?? "") {[weak self] (response, jsonString) in
            guard let strongSelf = self else { return }
            strongSelf.passDataToJS(mehodName: strongSelf.callbackMethodCache[mehodName], jsonString: jsonString)
            if response.code == 200 && response.dataDictionary != nil {
                strongSelf.deviceInfoDictionary = response.dataDictionary
                strongSelf.customNavView.titleView.text = strongSelf.deviceInfoDictionary?["device_name"] as? String ?? ""
                // 发现离线给弹窗
                strongSelf.showUnOnlineAlterView()
            }
        }
    }
    
    // 操作设备
    private func operationDevice(mehodName: String, dict:[String : Any]) {
        HSDeviceViewModel.operationDevice(deviceID: deviceInfo["device_id"] ?? "", entryDictionary: dict){[weak self] (response, jsonString) in
            guard let strongSelf = self else { return }
            strongSelf.passDataToJS(mehodName: strongSelf.callbackMethodCache[mehodName], jsonString: jsonString)
            if response.code == 200 {
                // 首页刷新数据
                NotificationCenter.default.post(name: HSBaseNotificationName.homePageIsrefresh, object: nil)
            }
        }
    }
    
    // 获取设备属性
    private func getDevicePropertyInfo(mehodName: String, dict:[String : Any]) {
        HSDeviceViewModel.loadDevicePropertyInfo(deviceID: deviceInfo["device_id"] ?? "", entryDictionary: dict) { [weak self] (response, jsonString) in
            guard let strongSelf = self else { return }
            strongSelf.passDataToJS(mehodName: strongSelf.callbackMethodCache[mehodName], jsonString: jsonString)
        }
    }
    
    // 离线弹窗
    private func showUnOnlineAlterView() {
        guard let deviceInfoDictionary = deviceInfoDictionary, let status = deviceInfoDictionary["status"] as? Bool else { return }
        if !status {
            let vc = HSWebAlterController.alertDefaultView(title: "设备离线", otherTitle: "请检查", contentString: (deviceInfoDictionary["off_desc"] ?? "") as! String, actionButtonTitleArray: ["返回首页"]) {[weak self] (tag, content) in
                self?.comeBackAction()
            }
            vc.closeButton.isHidden = false
            vc.clickEnableClose = false
            vc.show()
        }
    }
    
    // toast弹窗
    private func toastShow(_ contentString: String) {
        HSProgressHUD.showMessage(discribeStr: contentString, dismiss: true, userInteractionType: .noInteractionType)
    }
    
    // 可操作弹窗
    private func showActionAlterView(dict:[String : Any]) {
        let title = (dict["title"] as? String) ?? ""
        let subTitle = (dict["subTitle"] as? String) ?? ""
        let message = (dict["message"] as? String) ?? ""
        let showClose = (dict["showClose"] as? Bool) ?? false
        let buttonTextArray = (dict["buttonText"] as? [[String: String]]) ?? nil
        var titleArray = [String]()
        var callBackNameArray = [String]()
        if buttonTextArray != nil {
            for dict in buttonTextArray! {
                if let str = dict["name"] {
                    titleArray.append(str)
                    callBackNameArray.append(dict["callBackName"] ?? "")
                }
            }
        }
        
        let vc = HSWebAlterController.alertDefaultView(title: title,otherTitle: subTitle, contentString: message, actionButtonTitleArray: titleArray) { [weak self] (tag, content) in
            if callBackNameArray.count > tag {
                let callBackName = callBackNameArray[tag]
                if !callBackName.isEmpty {
                    self?.passDataToJS(mehodName: callBackName, jsonString: nil)
                }
            }
        }
        vc.closeButton.isHidden = !showClose
        vc.show()
    }
    
    // H5切换页面
    private func h5PageChange(dict:[String : Any]) {
        // 页面标题
        let pageTitle = (dict["pageName"] as? String) ?? ""
        // 是否显示更多
        let showMore = (dict["showMore"] as? Bool) ?? false
        // 完成
        let titleRightAction = (dict["titleRightAction"] as? [String: String]) ?? nil
        navBarButtonActionName = titleRightAction?["callBackName"]
        customNavView.titleView.text = pageTitle
        
        moreButton.isHidden = !(showMore && HSWebOpenFunction.shared.isHaveDeviceMore)
        finishButton.isHidden = titleRightAction == nil
        finishButton.setTitle(titleRightAction?["label"], for: .normal)
        finishButton.sizeToFit()
    }
    
    // H5请求API(普通API)
    private func h5requsetData(mehodName: String, dict:[String : Any]) {
        guard let apiName = dict["apiName"] as? String else { return }
        var parameters:[String : Any]? = nil
        if let parametersTring = dict["apiParams"] as? String {
            parameters = stringValueDiction(parametersTring)
        }
        HSH5APIRequest.requstH5ApiData(apiName: apiName, parameters: parameters){[weak self] (response, jsonString) in
            guard let strongSelf = self else { return }
            strongSelf.passDataToJS(mehodName: strongSelf.callbackMethodCache[mehodName], jsonString: jsonString)
        }
    }
    
    // 震动
    private func h5SystemVibration(_ amplitude: String) {
        guard let amplitude = Int("\(amplitude)"), HSUserAccountDault.standard.userSwitchVibration == true else {
            return
        }
        var tempStyle:UIImpactFeedbackGenerator.FeedbackStyle = .medium
        if amplitude == 0 {
            tempStyle = .light
        }else if amplitude == 1 {
            tempStyle = .medium
        }else if amplitude == 2 {
            tempStyle = .heavy
        }else{
            tempStyle = .medium
        }
        let impact = UIImpactFeedbackGenerator.init(style: tempStyle)
        impact.impactOccurred()
    }
}


