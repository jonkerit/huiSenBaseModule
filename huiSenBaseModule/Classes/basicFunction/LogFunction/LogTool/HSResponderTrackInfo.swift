//
//  HSResponderTrackInfo.swift
//  JonkerItDemoAPP
//
//  Created by jonker.sun on 2022/2/10.
//

import UIKit

class HSResponderTrackInfo: NSObject {
    
    // MAKR: 各埋点需要的属性
    var pageId:String? {
        get{
            return (getVauleFromKey("pageId") as? String) ?? ""
        }
        set{
            return setVauleToKey("pageId", newValue: newValue)
        }
    }
    var aIdForClick:String? {
        get{
            return (getVauleFromKey("aIdForClick") as? String) ?? ""
        }
        set{
            return setVauleToKey("aIdForClick", newValue: newValue)
        }
    }
    var aIdForShow:String? {
        get{
            return (getVauleFromKey("aIdForShow") as? String) ?? ""
        }
        set{
            return setVauleToKey("aIdForShow", newValue: newValue)
        }
    }
    var showId:String? {
        get{
            return (getVauleFromKey("showId") as? String) ?? ""
        }
        set{
            return setVauleToKey("showId", newValue: newValue)
        }
    }
    var paramsObj:AnyObject? {
        get{
            return getVauleFromKey("paramsObj") as AnyObject
        }
        set{
            return setVauleToKey("paramsObj", newValue: newValue)
        }
    }
    
    /// 只用来传值，而不上报埋点
    var noTrackInfos:[String:Any]?
    
    /// 用来记录属性的字典
    var allTrackInfos = [String:Any]()
    
    /// 遍历埋点信息时，到此为止
    var isRoot:Bool?
    
    private func getVauleFromKey(_ key:String)->Any{
        if allTrackInfos.keys.contains(key) {
            return allTrackInfos[key]!
        }else{
            return ""
        }
    }
    private func setVauleToKey(_ key:String, newValue:Any?){
        if newValue == nil {
            allTrackInfos.removeValue(forKey: key)
        }else{
            allTrackInfos[key] = newValue
        }
    }
    
}
