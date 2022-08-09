//
//  HSUserAccountDault.swift
//  huiSenSmart
//
//  Created by jonkersun on 2021/6/3.
//

import UIKit

public class HSUserAccountDault: NSObject, HSUserDefaultsProtocol {
    public static let standard = HSUserAccountDault()
    
    /// 与账户绑定的信息的key需要加入电话号码作为一起作为key
    private func createUserKey(_ key:String) -> String {
        if HSUserKey.isEmpty {
            return key
        }else{
            return "\(key)\(HSUserKey)"
        }
    }
    /// 主题模式
    public var appTheme: HSAppTheme {
        get{
            return  readWithNSUserDefaults(HSUserDefaultsKey.APPThemeSaveKey) as? HSAppTheme ?? .normal
        }
        set{
            saveWithNSUserDefaults(newValue, HSUserDefaultsKey.APPThemeSaveKey)
        }
    }
    /// 查看隐私政策的状态（0:没有查看或者查看了没有操作，1:拒绝，2:同意）
    public var privatePolicyStatus: Int? {
        get{
            return  readWithNSUserDefaults(HSUserDefaultsKey.APPUserPrivatePolicyKey) as? Int ?? 0
        }
        set{
            saveWithNSUserDefaults(newValue, HSUserDefaultsKey.APPUserPrivatePolicyKey)
        }
    }
    
    /// 上一次登录的账号
    public var oldPhone: String? {
        get{
            return  readWithNSUserDefaults(HSUserDefaultsKey.APPOldPhoneSaveKey) as? String
        }
        set{
            saveWithNSUserDefaults(newValue, HSUserDefaultsKey.APPOldPhoneSaveKey)
        }
    }
    
    /// 刷新token的时间
    public var requstTokenTime: CGFloat? {
        get{
            return  readWithNSUserDefaults(createUserKey(HSUserDefaultsKey.APPRequstTokenTimeSaveKey)) as? CGFloat
        }
        set{
            saveWithNSUserDefaults(newValue, createUserKey(HSUserDefaultsKey.APPRequstTokenTimeSaveKey))
        }
    }
    
    /// 用户的相关基础信息(jsonstring)
    public var userInfo: String? {
        get{
            return  readWithNSUserDefaults(HSUserDefaultsKey.APPUserInfoSaveKey) as? String
        }
        set{
            saveWithNSUserDefaults(newValue, HSUserDefaultsKey.APPUserInfoSaveKey)
        }
    }
    
    /// 用户的家庭信息(jsonstring)
    public var homeInfo: String? {
        get{
            return  readWithNSUserDefaults(createUserKey(HSUserDefaultsKey.APPUserHomeInfoSaveKey)) as? String
        }
        set{
            saveWithNSUserDefaults(newValue, createUserKey(HSUserDefaultsKey.APPUserHomeInfoSaveKey))
        }
    }
    
    /// 用户的家庭对应的设备列表信息(jsonstring)
    public var deviceInfo: String? {
        get{
            return  readWithNSUserDefaults(createUserKey(HSUserDefaultsKey.APPUserDeviceInfoSaveKey)) as? String
        }
        set{
            saveWithNSUserDefaults(newValue, createUserKey(HSUserDefaultsKey.APPUserDeviceInfoSaveKey))
        }
    }
    /// 选中的家庭(ID)
    public var chioceHomeId: String? {
        get{
            return  readWithNSUserDefaults(createUserKey(HSUserDefaultsKey.APPUserChioceHomeIDKey)) as? String
        }
        set{
            saveWithNSUserDefaults(newValue, createUserKey(HSUserDefaultsKey.APPUserChioceHomeIDKey))
        }
    }
    
    /// 地图搜索的历史记录（json String）
    public var mapSearchRecord: String? {
        get{
            return  readWithNSUserDefaults(createUserKey(HSUserDefaultsKey.APPUserMapSearchRecordKey)) as? String
        }
        set{
            saveWithNSUserDefaults(newValue, createUserKey(HSUserDefaultsKey.APPUserMapSearchRecordKey))
        }
    }
    
    ///  DEBUG下，是否加载H5
    public var H5IsLoad: Bool {
        get{
            return  readWithNSUserDefaults(createUserKey(HSUserDefaultsKey.APPUserH5loadKey)) as? Bool ?? true
        }
        set{
            saveWithNSUserDefaults(newValue, createUserKey(HSUserDefaultsKey.APPUserH5loadKey))
        }
    }
    
    /// 用户的个人设置-震动
    public var userSwitchVibration: Bool? {
        get{
            return  readWithNSUserDefaults(createUserKey(HSUserDefaultsKey.APPUserSwitchVibrationKey)) as? Bool ?? true
        }
        set{
            saveWithNSUserDefaults(newValue, createUserKey(HSUserDefaultsKey.APPUserSwitchVibrationKey))
        }
    }
}
