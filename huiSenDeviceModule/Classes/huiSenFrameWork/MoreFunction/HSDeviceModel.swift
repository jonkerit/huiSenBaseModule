//
//  HSDeviceModel.swift
//  huiSenSmart
//
//  Created by jonker.sun on 2022/2/22.
//

import UIKit
import ObjectMapper

public class HSDeviceModel: Mappable {
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
    public var entry : [[String: Any]] = []
    /// 设备属性的model数组
    public var entryModelArray : [HSDeviceEntryModel] = []
    /// 非空则是开关的条目名称
    public var isSwitch : Bool = false
    /// 开关当前状态值 bool
    public var switchList : [HSDeviceSwitchModel] = []
    /// 是开关的情况下，是否是开启状态
    public var isSwitchOpen: Bool = false
    /// 是灯的情况下，是否是开启状态
    public var switchOpenDesc: String = ""
    /// 网关状态-1，没有状态 0-加载中  1-在线 2-离线
    public var distributionNetworkStatus: Int = -1
    required public init?(map: Map) {
        
    }
    
    public func mapping(map: Map) {
       device_id <- map["device_id"]
       product_id <- map["product_id"]
       device_name <- map["device_name"]
       logo_url <- map["logo_url"]
       room_id <- map["room_id"]
       room_name <- map["room_name"]
       status <- map["status"]
       gateway <- map["gateway"]
       entry <- map["Entry"]
       entryModelArray <- map["Entry"]
       isSwitch <- map["is_switch"]
       switchList <- map["switch_list"]
       distributionNetworkStatus <- map["distribution_network_status"]

       isSwitchOpen = isOpen()
       switchOpenDesc = createDesc()
    }
    /// 改变网关的状态
    public func changeGetwayStatus(_ status: Int) {
        distributionNetworkStatus = status
        switchOpenDesc = createDesc()
     }
    
    public func isOpen() ->Bool {
        for (_, model) in self.switchList.enumerated() {
            if model.value {
                return true
            }
        }
        return false
    }
    
    public func createDesc() ->String {
        if distributionNetworkStatus == 0 {
            return self.room_name+" | 加载中"
        }
        if !self.status {
            return self.room_name+" | 离线"
        }
        if !self.isSwitch {
            return self.room_name+" | 在线"
        }
        var tempString = "开启 "
        var closeNumber = 0
        for (i, model) in self.switchList.enumerated() {
            if model.value {
                tempString = "\(tempString)\(i+1) "
            }else{
                closeNumber += 1
            }
        }
        if closeNumber == 0 {
            if self.switchList.count>1 {
                return self.room_name+" | 全开"
            }else{
                return self.room_name+" | 开启"
            }
        }else if closeNumber == self.switchList.count {
            if self.switchList.count>1 {
                return self.room_name+" | 全关"
            }else{
                return self.room_name+" | 关闭"
            }
        }else{
            return self.room_name+" | \(tempString)"
        }
    }
}

public class HSDeviceEntryModel: Mappable {
    /// 属性名
    public var entry : String = ""
    /// 属性值
    public var value : String = ""
    required public init?(map: Map) {
        
    }
    
    public func mapping(map: Map) {
       entry <- map["name"]
       value <- map["value"]
    }
}

public class HSDeviceSwitchModel: Mappable {
    /// 属性名
    public var name : String = ""
    /// 属性值
    public var value : Bool = false
    public required init?(map: Map) {
        
    }
    
    public func mapping(map: Map) {
       name <- map["name"]
       value <- map["value"]
    }
}
