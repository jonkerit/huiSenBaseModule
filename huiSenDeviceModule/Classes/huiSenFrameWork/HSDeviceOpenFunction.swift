//
//  HSDeviceOpenFunction.swift
//  huiSenModule
//
//  Created by jonker.sun on 2022/8/12.
//

import UIKit

public class HSDeviceOpenFunction: NSObject {
    
    /// 操作设备--全开关
    /// - Parameters:
    ///   - deviceID: 设备ID
    ///   - onOrOff: 设备状态
    ///   - completioned: 回调
    /// - Returns: HSRequest
    public static func operationAllDevice(deviceID: String, onOrOff:Bool, completioned:@escaping HSCompletionClosure){
        HSDeviceViewModel.operationAllDevice(deviceID: deviceID, onOrOff: onOrOff, completioned: completioned)
    }
    
    /// 设备列表
    /// - Parameters:
    ///   - homeId: 房间号
    ///   - floorId: 楼层
    ///   - roomId: 房间
    ///   - completioned: 回调
    public static func loadDevieceListData(homeId:String, floorId:String?, roomId:String?, completioned:@escaping HSCompletionClosure)  {
        HSDeviceViewModel.loadDevieceListData(homeId: homeId, floorId: floorId, roomId: roomId, completioned: completioned)
    }

    /// 读取对应的hone ID设备信息
    public static func unSaveDeviceData(homeId: String) -> [HSDeviceModel]?{
       return HSDeviceViewModel.unSaveDeviceData(homeId: homeId)
    }
}
