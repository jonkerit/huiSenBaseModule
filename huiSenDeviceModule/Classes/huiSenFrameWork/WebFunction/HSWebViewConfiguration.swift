//
//  HSWebViewConfiguration.swift
//  huiSenSmart
//
//  Created by jonker.sun on 2022/3/16.
//

import UIKit
// MARK: ---- JS版本号定义
 let HSH5JSBridgeVision = "1.0"

// MARK: ---- 与H5 交互回调函数的名称的key
 let HSH5CallBackName = "callbackName"

// MARK: ---- JS注册的方法(H5调OC)
/// 获取App版本的方法名称
 let HSH5GetApppVersionMehod = "appVersion"
/// 获取JSBridge版本的方法名称
 let HSH5GetJSBriggeMehod = "bridgeVersion"
/// 获取当前主题
 let HSH5GetThemeMehod = "getTheme"
/// 获取当前用户信息
 let HSH5GetUserInfoMehod = "getUserProfile"
/// 获取获取设备信息的方法名称
 let HSH5GetDeviceInfoMehod = "getDeviceInfo"
/// 读取设备属性的方法名称
 let HSH5GetDeviceAttributeMehod = "getDeviceAttribute"
/// 设备操作
 let HSH5GetOperationMehod = "setDeviceAttribute"
/// 设置存储数据功能
 let HSH5SetStorageMehod = "setStorage"
/// 读取存储数据
 let HSH5GetStorageMehod = "getStorage"
/// toast弹窗
let HSH5HanlderToastMehod = "handlerToast"
/// 可操作弹窗
let HSH5HandlerDialogMehod = "handlerDialog"
/// H5页面切换
let HSH5PageChangeMehod = "pageChange"
/// H5页面请求API
let HSH5HandlerApiMehod = "handlerApi"
/// 短震动
let HSH5VibrationMehod = "systemShortVibrate"

// MARK: ---- H5实现的的方法（OC调H5）
/// 获取当前主题
let HSH5SetThemeActionMehod = "setTheme"
/// 设置设备信息,例如： 设备名称修改后通知H5 -- 参数{key: 'name',value: '单开开关'}
let HSH5SetDeviceInfoMehod = "setDeviceInfo"
/// 返回操作，回调 ok/cancel ，ok 是H5处理返回，其他原生处理返回
let HSH5ComeBackActionMehod = "onBackPage"

// MARK: --- 设备详情的相关API接口
struct HSH5NetworkUrl {
    /// 获取H5压缩包最新版本信息
    public static let getH5ZipInfoURLString = "/app/api/cui/check_update"
    /// 设备操作
    public static let deviceOperationURLString = "/app/api/device/command"
    /// 设备的详细信息
    public static let deviceDetailInfoURLString = "/app/api/device/info"
    /// 获取设置的属性值
    public static let devicePropertyURLString = "/app/api/device/attr_all"
    /// 设备操作-- 全开/全关
    public static let deviceOperationAllURLString = "/app/api/device/switch_command"
    /// 删除设备
    public static let deviceDelegateURLString = "/app/api/device/del"
    /// 重启设备
    public static let deviceRestartURLString = "/app/api/device/restart"
    /// 设备信息
    public static let deviceListURLString = "/app/api/device/list"
    /// 修改设备名称及房间
    public static let updateDeviceURLString = "/app/api/device/update"
}
