//
//  HSUserDefaultsProtocol.swift
//  huiSenSmart
//
//  Created by jonker.sun on 2022/1/17.
//

import Foundation

public protocol HSUserDefaultsProtocol {}

extension HSUserDefaultsProtocol{
    /// 存储数据
    public func saveWithNSUserDefaults(_ vaule:Any?, _ key:String) {
        // 1、利用NSUserDefaults存储数据
        let defaults = UserDefaults.standard
        // 2、存储数据
        if vaule is Bool {
            defaults.set(vaule as! Bool, forKey: key)
        }else if vaule is Int {
            defaults.set(vaule as! Int, forKey: key)
        }else if vaule is String {
            defaults.set(vaule as! String, forKey: key)
        }else if vaule is Double {
            defaults.set(vaule as! Double, forKey: key)
        }else{
            defaults.set(vaule, forKey: key)
        }
        // 3、同步数据
        defaults.synchronize()
    }
    /// 取出数据
    public func readWithNSUserDefaults(_ key:String)->Any? {
        let defaults = UserDefaults.standard
        return defaults.value(forKey: key)
    }
    /// 与账户绑定的信息的key需要加入电话号码作为一起作为key
    public func createUserKey(_ key:String) -> String {
        if HSUserKey.isEmpty {
            return key
        }else{
            return "\(key)\(HSUserKey)"
        }
    }
}
