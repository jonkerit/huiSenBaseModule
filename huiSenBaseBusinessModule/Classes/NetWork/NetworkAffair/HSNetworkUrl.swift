//
//  HSNetworkUrl.swift
//  huiSenSmart
//
//  Created by jonker.sun on 2022/2/22.
//

import UIKit

public struct HSNetworkUrl {
    /// 家庭列表
    public static let homeListURLString = "/api/home/list"
    /// 单个家庭信息
    public static let homeDetailURLString = "/api/home/home_detail"
//    /// 设备信息
//    public static let deviceListURLString = "/api/device/list"
    /// 登录或者注册
    public static let loginOrRegisterURLString = "/api/user/login"
    /// 发送验证码
    public static let phoneCodeURLString = "/api/user/phone_code"
    /// 刷新token
    public static let refreshTokenURLString = "/api/user/refresh_token"
    /// 创建家庭
    public static let addHomeURLString = "/api/home/create"
    /// 创建房间
    public static let addRoomURLString = "/api/home/add_room"
    /// 删除房间
    public static let delegateRoomURLString = "/api/home/delete_room"
    /// 修改房间
    public static let updateRoomURLString = "/api/home/update_room"
    /// 房间排序
    public static let orderRoomURLString = "/api/home/sort_room"
    /// 删除home
    public static let delegateHomeURLString = "/api/home/delete"
    /// 修改home
    public static let updateHomeURLString = "/api/home/update"
    /// 修改用户信息
    public static let updateUserInfoURLString = "/api/user/update"
    /// 用户更新密码
    public static let updateUserPasswordURLString = "/api/user/update_password"
    /// 产品列表
    public static let productListURLString = "/api/product/list"
    /// 配网页详情
    public static let productDistributionURLString = "/api/product/guide"
    /// 配网进度查询/关闭配网
    public static let productDistributionStatusURLString = "/api/product/listen_status"
    /// 修改设备名称及房间
    public static let updateDeviceURLString = "/api/device/update"
    /// 开启配网
    public static let openDistributionURLString = "/api/product/listen"
    /// 注册设备
    public static let registerDeviceURLString = "/api/device/register"
    /// 场景list（登录后的数据）
    public static let secenceListTokenURLString = "/api/scene/list"
    /// 场景list（未登录的数据）
    public static let secenceListURLString = "/api/scene/n_list"
    /// 修改场景列表
    public static let secenceListModefyURLString = "/api/scene/device_list"
    /// 操作场景
    public static let secenceActionURLString = "/api/scene/manually"
    /// 系统消息列表获取
    public static let systemNoticeURLString = "/api/notice/system_list"
    /// 设备消息列表获取
    public static let deviceNoticeURLString = "/api/notice/device_list"
    /// 系统通知设置
    public static let noticeSettingURLString = "/api/system/set"
    /// 获取系统通知设置
    public static let noticeGettingURLString = "/api/system/get"
    /// 获取系统通知未读数量
    public static let noticeNumberURLString = "/api/notice/count"
    /// 确认/撤销/拒绝邀请
    public static let homeMenberInviteActionURLString = "/api/home_member/operation_invite"
    /// 家庭成员列表
    public static let homeMenberListURLString = "/api/home_member/list"
    /// 搜索成员
    public static let homeMenberSearchURLString = "/api/home_member/search"
    /// 邀请
    public static let homeMenberInviteURLString = "/api/home_member/invite"
    /// 设置成员权限
    public static let homeMenberSetRoleURLString = "/api/home_member/set_member_role"
    /// 移除成员
    public static let homeMenberRemoveURLString = "/api/home_member/remove"
    /// 退出家庭
    public static let homeMenberQuitURLString = "/api/home_member/quit"
    /// 壁纸列表
    public static let wallpaperListURLString = "/api/home/wallpaper"
    /// 用户头像列表
    public static let photoListURLString = "/api/user/photoList"
    /// 查询网关状态
    public static let getwayStatusURLString = "/api/device/gateway_status"
    /// 是否需要身份转移
    public static let acountTransferURLString = "/api/logout/is_transfer"
    /// 身份转移列表
    public static let acountTransferListURLString = "/api/logout/transfer_list"
    /// 确认注销
    public static let logoutConfirmURLString = "/api/logout/confirm"
}

