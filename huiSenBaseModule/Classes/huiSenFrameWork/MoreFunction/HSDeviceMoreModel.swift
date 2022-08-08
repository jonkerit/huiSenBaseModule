//
//  HSDeviceMoreModel.swift
//  huiSenSmart
//
//  Created by jonker.sun on 2022/3/29.
//

import UIKit

class HSDeviceMoreModel: NSObject {
    /// 设备其他信息的json
    var deviceInfoDictionary: [String: Any]?
    /// 是否是常用
    var isUsed: Bool = false
    /// 设备名称
    var deviceName: String = ""
    /// 设备序列号
    var devicenumber: String = ""
    /// 设备ID
    var deviceID: String = ""
    /// 设备是否有重启
    var isReset: Bool = false
    /// room ID
    var roomId: String = ""
    /// home ID
    var homeId: String = ""    
}
