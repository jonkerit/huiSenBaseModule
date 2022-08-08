//
//  HSDeviceModel.swift
//  huiSenSmart
//
//  Created by jonker.sun on 2022/2/22.
//

import UIKit
import ObjectMapper

class HSDeviceModel: Mappable {
    /// 设备id
    var device_id : String = ""
    /// 产品id
    var product_id : String = ""
    /// 设备名称
    var device_name : String = ""
    /// 设备logo url
    var logo_url : String = ""
    /// 所在楼层id
    var home_id : String = ""
    /// 所在房间id
    var room_id : String = ""
    /// 所在房间name
    var room_name : String = ""
    /// 设备是否在线
    var status : Bool = false
    /// 网关ID
    var gateway: String = ""
    /// 设备属性
    var entry : [[String: Any]] = []
    /// 设备属性的model数组
    var entryModelArray : [HSDeviceEntryModel] = []
    /// 非空则是开关的条目名称
    var isSwitch : Bool = false
    /// 开关当前状态值 bool
    var switchList : [HSDeviceSwitchModel] = []
    /// 是开关的情况下，是否是开启状态
    var isSwitchOpen: Bool = false
    /// 是灯的情况下，是否是开启状态
    var switchOpenDesc: String = ""
    /// 网关状态-1，没有状态 0-加载中  1-在线 2-离线
    var distributionNetworkStatus: Int = -1
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
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
    func changeGetwayStatus(_ status: Int) {
        distributionNetworkStatus = status
        switchOpenDesc = createDesc()
     }
    
    func isOpen() ->Bool {
        for (_, model) in self.switchList.enumerated() {
            if model.value {
                return true
            }
        }
        return false
    }
    
    func createDesc() ->String {
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

class HSDeviceEntryModel: Mappable {
    /// 属性名
    var entry : String = ""
    /// 属性值
    var value : String = ""
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
       entry <- map["name"]
       value <- map["value"]
    }
}

class HSDeviceSwitchModel: Mappable {
    /// 属性名
    var name : String = ""
    /// 属性值
    var value : Bool = false
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
       name <- map["name"]
       value <- map["value"]
    }
}
