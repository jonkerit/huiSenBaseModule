//
//  HSNetworkUrl.swift
//  huiSenSmart
//
//  Created by jonker.sun on 2022/2/22.
//

import UIKit

struct HSNetworkUrl {
    /// 家庭列表
    static let homeListURLString = "/app/api/home/list"
    /// 单个家庭信息
    static let homeDetailURLString = "/app/api/home/home_detail"
//    /// 设备信息
//    static let deviceListURLString = "/app/api/device/list"
    /// 登录或者注册
    static let loginOrRegisterURLString = "/app/api/user/login"
    /// 发送验证码
    static let phoneCodeURLString = "/app/api/user/phone_code"
    /// 刷新token
    static let refreshTokenURLString = "/app/api/user/refresh_token"
    /// 创建家庭
    static let addHomeURLString = "/app/api/home/create"
    /// 创建房间
    static let addRoomURLString = "/app/api/home/add_room"
    /// 删除房间
    static let delegateRoomURLString = "/app/api/home/delete_room"
    /// 修改房间
    static let updateRoomURLString = "/app/api/home/update_room"
    /// 房间排序
    static let orderRoomURLString = "/app/api/home/sort_room"
    /// 删除home
    static let delegateHomeURLString = "/app/api/home/delete"
    /// 修改home
    static let updateHomeURLString = "/app/api/home/update"
    /// 修改用户信息
    static let updateUserInfoURLString = "/app/api/user/update"
    /// 用户更新密码
    static let updateUserPasswordURLString = "/app/api/user/update_password"
    /// 产品列表
    static let productListURLString = "/app/api/product/list"
    /// 配网页详情
    static let productDistributionURLString = "/app/api/product/guide"
    /// 配网进度查询/关闭配网
    static let productDistributionStatusURLString = "/app/api/product/listen_status"
    /// 修改设备名称及房间
    static let updateDeviceURLString = "/app/api/device/update"
    /// 开启配网
    static let openDistributionURLString = "/app/api/product/listen"
    /// 注册设备
    static let registerDeviceURLString = "/app/api/device/register"
    /// 场景list（登录后的数据）
    static let secenceListTokenURLString = "/app/api/scene/list"
    /// 场景list（未登录的数据）
    static let secenceListURLString = "/app/api/scene/n_list"
    /// 修改场景列表
    static let secenceListModefyURLString = "/app/api/scene/device_list"
    /// 操作场景
    static let secenceActionURLString = "/app/api/scene/manually"
    /// 系统消息列表获取
    static let systemNoticeURLString = "/app/api/notice/system_list"
    /// 设备消息列表获取
    static let deviceNoticeURLString = "/app/api/notice/device_list"
    /// 系统通知设置
    static let noticeSettingURLString = "/app/api/system/set"
    /// 获取系统通知设置
    static let noticeGettingURLString = "/app/api/system/get"
    /// 获取系统通知未读数量
    static let noticeNumberURLString = "/app/api/notice/count"
    /// 确认/撤销/拒绝邀请
    static let homeMenberInviteActionURLString = "/app/api/home_member/operation_invite"
    /// 家庭成员列表
    static let homeMenberListURLString = "/app/api/home_member/list"
    /// 搜索成员
    static let homeMenberSearchURLString = "/app/api/home_member/search"
    /// 邀请
    static let homeMenberInviteURLString = "/app/api/home_member/invite"
    /// 设置成员权限
    static let homeMenberSetRoleURLString = "/app/api/home_member/set_member_role"
    /// 移除成员
    static let homeMenberRemoveURLString = "/app/api/home_member/remove"
    /// 退出家庭
    static let homeMenberQuitURLString = "/app/api/home_member/quit"
    /// 壁纸列表
    static let wallpaperListURLString = "/app/api/home/wallpaper"
    /// 用户头像列表
    static let photoListURLString = "/app/api/user/photoList"
    /// 查询网关状态
    static let getwayStatusURLString = "/app/api/device/gateway_status"
    /// 是否需要身份转移
    static let acountTransferURLString = "/app/api/logout/is_transfer"
    /// 身份转移列表
    static let acountTransferListURLString = "/app/api/logout/transfer_list"
    /// 确认注销
    static let logoutConfirmURLString = "/app/api/logout/confirm"
}

