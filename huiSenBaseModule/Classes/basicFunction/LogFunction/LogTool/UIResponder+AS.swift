//
//  UIResponder+AS.swift
//  JonkerItDemoAPP
//
//  Created by jonker.sun on 2022/2/10.
//

import Foundation
import UIKit
import ObjectMapper

fileprivate var AssociatedKey = "AssociatedKey"
fileprivate var TrackNextResponderKey = "TrackNextResponderKey"

public extension UIResponder {
    
    internal var trackInfo:HSResponderTrackInfo {
        get {
            guard let info = objc_getAssociatedObject(self, &AssociatedKey) as? HSResponderTrackInfo else {
                let tempinfo = HSResponderTrackInfo()
                objc_setAssociatedObject(self, &AssociatedKey, tempinfo, .OBJC_ASSOCIATION_RETAIN)
                return tempinfo
                
            }
            return info
        }
        
        set {
            objc_setAssociatedObject(self, &AssociatedKey, newValue, .OBJC_ASSOCIATION_RETAIN)
        }
    }
    
    internal var trackNextResponder:UIResponder? {
        get {
            return objc_getAssociatedObject(self, &TrackNextResponderKey) as? UIResponder
        }
        
        set {
            objc_setAssociatedObject(self, &TrackNextResponderKey, newValue, .OBJC_ASSOCIATION_RETAIN)
        }
    }
    
    /// 点击事件上报
    func trackSendClickTrack() {
        let baseInfo = baseInfoDictionary()
        var selfInfo = trackMergedTrackInfos()
        // 需要制空非点击事件的key
        selfInfo["aIdForShow"] = nil
        selfInfo["showId"] = nil
        HSDebugLog(selfInfo)
        // 检测点击事件上报
        if (selfInfo["pageId"] == nil) {
            HSDebugLog("点击日志缺少 pageId：\(selfInfo)")
        }
        if (selfInfo["aIdForClick"] == nil) {
            HSDebugLog("点击日志缺少 aIdForClick：\(selfInfo)")
        }
        
        _ = recursiveSetValuesForKeysWithDictionary(inputDictionary: baseInfo, oldDictionary: selfInfo, isSkip: true)
        // 上报埋点
    }
    /// 元素曝光上报
    func trackSendShowTrack() {
        let baseInfo = baseInfoDictionary()
        var selfInfo = trackMergedTrackInfos()
        // 需要制空非点击事件的key
        selfInfo["aIdForClick"] = nil
        HSDebugLog(selfInfo)
        // 检测点击事件上报
        if (selfInfo["aIdForShow"] == nil) {
            HSDebugLog("曝光日志缺少 aIdForShow：\(selfInfo)")
        }
        if (selfInfo["showId"] == nil) {
            HSDebugLog("曝光日志缺少 showId：\(selfInfo)")
        }
        
        _ = recursiveSetValuesForKeysWithDictionary(inputDictionary: baseInfo, oldDictionary: selfInfo, isSkip: true)
        // 上报埋点
    }
}

extension UIResponder{
    /// 创建一个日志所需要的数据的字典,一直向super Responder 取值，当前层根据isSkip判断是否用super的覆盖当前层的数据
    private func trackMergedTrackInfos()-> [String: Any]{
        var nowResponse = self
        var isContinue = true
        var newDictonary = [String: Any]()
        
        while isContinue {
            newDictonary = recursiveSetValuesForKeysWithDictionary(inputDictionary: nowResponse.trackInfo.allTrackInfos, oldDictionary: recursiveMutableCopyDictionary(newDictonary), isSkip: true)
            if nowResponse.trackInfo.isRoot ?? false {
                break
            }
            
            let nextResponse = nowResponse.trackNextResponder
            if (nextResponse == nil) {
                isContinue = false
            }else{
                isContinue = true
                nowResponse = nextResponse!
            }
        }
        return newDictonary
    }
    /// 基础数据
    private func baseInfoDictionary()->[String: Any] {
        var tempDictionary = [String: Any]()
        tempDictionary["time"] = "Date.timeIntervalSince1970"
        return tempDictionary
    }
    
    /// 获取 HSResponderTrackInfo 信息
    private func track_infoIfExist()->HSResponderTrackInfo? {
        return objc_getAssociatedObject(self, &AssociatedKey) as? HSResponderTrackInfo
    }
    
    /// 完全复制一份字典集合
    private func recursiveMutableCopyDictionary(_ inputDictionary:[String: Any]) -> [String: Any] {
        var tempNewDictionary = [String: Any]()
        for key in inputDictionary.keys {
            let vaule = inputDictionary[key]
            if vaule is [String: Any] {
                tempNewDictionary[key] = recursiveMutableCopyDictionary(vaule as! [String : Any])
            }else{
                tempNewDictionary[key] = vaule
            }
            
        }
        return tempNewDictionary
    }
    
    /// 合并字典，内部的字典同样递归合并,把inputDictionary的值合并到oldDictionary，对于已经存在的值是跳过还是覆盖
    private func recursiveSetValuesForKeysWithDictionary(inputDictionary:[String: Any], oldDictionary:[String: Any], isSkip:Bool) -> [String: Any] {
        var newDictionary = oldDictionary
        let oldKeys = oldDictionary.keys
        let inputKeys = inputDictionary.keys
        for key in inputKeys {
            var newVaule = inputDictionary[key]
            if newVaule is [String: Any] {
                newVaule = recursiveMutableCopyDictionary(newVaule as! [String : Any])
            }
            if oldKeys.contains(key) {
                if !isSkip {
                    newDictionary[key] = newVaule
                }
            }else{
                newDictionary[key] = newVaule
            }
        }
        
        return newDictionary
    }
}
