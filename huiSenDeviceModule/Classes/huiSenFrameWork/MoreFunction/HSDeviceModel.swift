//
//  HSDeviceModel.swift
//  huiSenSmart
//
//  Created by jonker.sun on 2022/2/22.
//

import UIKit

public class HSDeviceModel: NSObject, HSCoadble {
    /// 设备id
    public var device_id : String = ""
    /// 产品id
    public var product_id : String = ""
    /// 设备名称
    public var device_name : String = ""
    /// 设备logo url
    public var logo_url : String = ""
    /// 所在楼层id
    public var home_id : String = ""
    /// 所在房间id
    public var room_id : String = ""
    /// 所在房间name
    public var room_name : String = ""
    /// 设备是否在线
    public var status : Bool = false
    /// 网关ID
    public var gateway: String = ""
    /// 设备属性
//    public var entry : [[String: Any]] = []
    /// 设备属性的model数组
    public var entry : [HSDeviceEntryModel]?
    /// 非空则是开关的条目名称
    public var is_switch : Bool = false
    /// 开关当前状态值 bool
    public var switch_list : [HSDeviceSwitchModel]?
    /// 是开关的情况下，是否是开启状态
    public var isSwitchOpen: Bool? = false
    /// 是灯的情况下，是否是开启状态
    public var switchOpenDesc: String? = ""
    /// 网关状态 fasle: 加载中，true完成加载
    public var distribution_network_status: Bool = false

    public static func changeDeviceModelArray(_ rootData:[HSDeviceModel]) {
        rootData.forEach { deviceModel in
            deviceModel.switchOpenDesc = deviceModel.createDesc()
            deviceModel.isSwitchOpen = deviceModel.isOpen()
        }
    }
    /// 改变网关的状态
    public func changeGetwayStatus(_ status: Int) {
        distribution_network_status = true
        switchOpenDesc = createDesc()
     }
    
    public func isOpen() ->Bool {
        if self.switch_list == nil {
            return false
        }
        for (_, model) in self.switch_list!.enumerated() {
            if model.value {
                return true
            }
        }
        return false
    }
    
    public func createDesc() ->String {
        if !distribution_network_status {
            return self.room_name+" | 加载中"
        }
        if !self.status {
            return self.room_name+" | 离线"
        }
        if !self.is_switch {
            return self.room_name+" | 在线"
        }
        
        var tempString = "开启 "
        var closeNumber = 0
        if self.switch_list == nil {
            self.switch_list = []
        }
        for (i, model) in self.switch_list!.enumerated() {
            if model.value {
                tempString = "\(tempString)\(i+1) "
            }else{
                closeNumber += 1
            }
        }
        if closeNumber == 0 {
            if self.switch_list!.count>1 {
                return self.room_name+" | 全开"
            }else{
                return self.room_name+" | 开启"
            }
        }else if closeNumber == self.switch_list!.count {
            if self.switch_list!.count>1 {
                return self.room_name+" | 全关"
            }else{
                return self.room_name+" | 关闭"
            }
        }else{
            return self.room_name+" | \(tempString)"
        }
    }
}

public class HSDeviceEntryModel: NSObject, HSCoadble {
    /// 属性名
    public var entry : String = ""
    /// 属性值
    public var value : String = ""
}

public class HSDeviceSwitchModel: NSObject, HSCoadble {
    /// 属性名
    public var name : String = ""
    /// 属性值
    public var value : Bool = false
}
