//
//  HSUserDefaultsProtocol.swift
//  huiSenSmart
//
//  Created by jonker.sun on 2022/1/17.
//

import Foundation

protocol HSUserDefaultsProtocol {}

extension HSUserDefaultsProtocol{
    /// 存储数据
    func saveWithNSUserDefaults(_ vaule:Any?, _ key:String) {
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
        defaults.synchronize();
    }
    /// 取出数据
    func readWithNSUserDefaults(_ key:String)->Any? {
        let defaults = UserDefaults.standard
        return defaults.value(forKey: key)
    }
}
