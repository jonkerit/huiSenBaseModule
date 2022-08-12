//
//  HSDeviceViewModel.swift
//  huiSenSmart
//
//  Created by jonker.sun on 2022/4/1.
//

import UIKit
import ObjectMapper
//public typealias CompletionDeviceClosure = (HSResponse, String) -> Void

class HSDeviceViewModel: NSObject {
    /// 设备列表
    /// - Parameters:
    ///   - homeId: 房间号
    ///   - floorId: 楼层
    ///   - roomId: 房间
    ///   - completioned: 回调
    static func loadDevieceListData(homeId:String, floorId:String?, roomId:String?, completioned:@escaping HSCompletionClosure)  {
        var parameters = [String: Any]()
        parameters["home_id"] = homeId
        parameters["room_id"] = roomId

        HSH5APIRequest.requstH5ApiData(apiName: HSH5NetworkUrl.deviceListURLString, parameters: parameters){ response, josnString in
            if response.code == 200 && response.data != nil {
                self.saveDeviceData(data: response.data as Any, homeId: homeId)
            }
            guard (response.dataArray) != nil else {
                completioned(response)
                return }
//            var tempArray = [[String: Any]]()
//            for _ in 0..<20 {
//                tempArray.append(contentsOf:response.dataArray!)
//            }
//            let model = Mapper<HSDeviceModel>().mapArray(JSONArray: tempArray)

            let model = Mapper<HSDeviceModel>().mapArray(JSONArray: response.dataArray!)
            response.data = model
            completioned(response)
        }
    }
    
    
    /// 获取设备信息
    /// - Parameters:
    ///   - deviceID: 设备ID
    ///   - completioned: 回调
    /// - Returns: HSRequest
    static func loadDeviceInfo(deviceID: String, completioned:@escaping HSCompletionStringClosure){
        var parameters = [String: Any]()
        parameters["device_id"] = deviceID
        HSH5APIRequest.requstH5ApiData(apiName: HSH5NetworkUrl.deviceDetailInfoURLString, parameters: parameters){ response, josnString in
            completioned(response, josnString)
        }
        
//        let request = HSDeviceDetailRequest()
//        request.device_id = deviceID
//        HSDefaultNetwork.request(request) {response in
//            var jsonString: String?
//            if response.code == 200 && response.dataDictionary != nil {
//                jsonString = String.as.dictionaryToJSONString(response.dataDictionary!)
//            }
//            if jsonString == nil {
//                let errorString = response.message ?? "数据请求失败"
//                let errorDict = ["error":errorString]
//                jsonString = String.as.dictionaryToJSONString(errorDict)
//            }
//            if jsonString == nil {
//                jsonString = ""
//            }
//            completioned(response, jsonString ?? "")
//        }
//        return request
    }
    
    /// 操作设备
    /// - Parameters:
    ///   - deviceID: 设备ID
    ///   - entryDictionary: 设备操作物模型值
    ///   - completioned: 回调
    /// - Returns: HSRequest
    static func operationDevice(deviceID: String, entryDictionary:[String : Any], completioned:@escaping HSCompletionStringClosure){
        var tempDict = [String:Any]()
        tempDict["device_id"] = deviceID
        tempDict["entry"] = (entryDictionary["entry"] as? String) ?? nil
        tempDict["entry_value"] = entryDictionary["entry_value"]
        HSH5APIRequest.requstH5ApiData(apiName: HSH5NetworkUrl.deviceOperationURLString, parameters: tempDict){ response, josnString in
            completioned(response, josnString)
        }
    }
    
    /// 操作设备--全开关
    /// - Parameters:
    ///   - deviceID: 设备ID
    ///   - entryDictionary: 设备操作物模型值
    ///   - completioned: 回调
    /// - Returns: HSRequest
    static func operationAllDevice(deviceID: String, onOrOff:Bool, completioned:@escaping HSCompletionClosure){
        var tempDict = [String:Any]()
        tempDict["device_id"] = deviceID
        tempDict["on_off"] = onOrOff
        HSH5APIRequest.requstH5ApiData(apiName: HSH5NetworkUrl.deviceOperationAllURLString, parameters: tempDict){ response, josnString in
            completioned(response)
        }
    }
    
    /// 获取设备属性
    /// - Parameters:
    ///   - deviceID: 设备ID
    ///   - entryDictionary: 设备操作物模型值
    ///   - completioned: 回调
    /// - Returns: HSRequest
    static func loadDevicePropertyInfo(deviceID: String, entryDictionary:[String : Any], completioned:@escaping HSCompletionStringClosure)  {
  
        var tempDict = [String:Any]()
        tempDict["device_id"] = deviceID
        tempDict["entry"] = (entryDictionary["entry"] as? String) ?? nil
        HSH5APIRequest.requstH5ApiData(apiName: HSH5NetworkUrl.devicePropertyURLString, parameters: tempDict){ response, josnString in
            completioned(response, josnString)
        }
//        let request = HSDevicePropertyRequest()
//        request.device_id = deviceID
//        request.entry = (entryDictionary["entry"] as? String) ?? nil
//        HSDefaultNetwork.request(request) { response in
//            var jsonString: String?
//            if response.code == 200 && response.dataDictionary != nil {
//                jsonString =  String.as.dictionaryToJSONString([request.entry ?? "" : response.dataDictionary as Any])
//            }
//            if jsonString == nil {
//                let errorString = response.message ?? "数据请求失败"
//                let errorDict = ["error":errorString]
//                jsonString = String.as.dictionaryToJSONString(errorDict)
//            }
//            completioned(response, jsonString ?? "")
//        }
//        return request
    }
    
    /// 删除设备
    /// - Parameters:
    ///   - deviceID: 设备ID
    ///   - completioned: 回调
    /// - Returns: HSRequest
    static func delegateDevice(deviceID: String, completioned:@escaping HSCompletionClosure) {
        
        var tempDict = [String:Any]()
        tempDict["device_id"] = deviceID
        HSH5APIRequest.requstH5ApiData(apiName: HSH5NetworkUrl.deviceDelegateURLString, parameters: tempDict){ response, josnString in
            completioned(response)
        }
        
//        let request = HSDeviceDelegateRequest()
//        request.device_id = deviceID
//
//        HSDefaultNetwork.request(request) { response in
//            completioned(response)
//        }
//        return request
    }
    
    /// 重启设备
    /// - Parameters:
    ///   - deviceID: 设备ID
    ///   - completioned: 回调
    /// - Returns: HSRequest
    static func restartDevice(deviceID: String, completioned:@escaping HSCompletionClosure) {
        
        var tempDict = [String:Any]()
        tempDict["device_id"] = deviceID
        HSH5APIRequest.requstH5ApiData(apiName: HSH5NetworkUrl.deviceRestartURLString, parameters: tempDict){ response, josnString in
            completioned(response)
        }
    }

}


// MARK: - Other Delegate
extension HSDeviceViewModel {
    /// 储存设备信息数据
    static func saveDeviceData(data: Any, homeId: String) {
        // 数据存储操作
        let jsonString = HSUserAccountDault.standard.deviceInfo
        // 如果设置options为NSJSONWritin
        let data : Data! = try? JSONSerialization.data(withJSONObject:data as Any, options: [])
        guard let str = NSString(data:data, encoding: String.Encoding.utf8.rawValue) as String? else { return }
        var tempdict = [String: String]()
        do {
            if jsonString != nil {
                let data = jsonString!.data(using: String.Encoding.utf8)!
                //把NSData对象转换回JSON对象
                let json : Any! = try JSONSerialization.jsonObject(with: data, options:JSONSerialization.ReadingOptions.mutableContainers)
                tempdict = json as! [String: String]
            }
            tempdict[homeId] = str
            let newdata : Data! = try? JSONSerialization.data(withJSONObject:  tempdict as Any, options: [])
            guard let newStr = NSString(data:newdata, encoding: String.Encoding.utf8.rawValue) as String? else { return }
            HSUserAccountDault.standard.deviceInfo = newStr
        } catch  {
            
        }
    }
    
    /// 读取对应的hone ID设备信息
    static func unSaveDeviceData(homeId: String) -> [HSDeviceModel]?{
        // 数据存储操作
        let jsonString = HSUserAccountDault.standard.deviceInfo
        if jsonString != nil {
            do {
                let data = jsonString!.data(using: String.Encoding.utf8)!
                //把NSData对象转换回JSON对象
                let json : Any! = try JSONSerialization.jsonObject(with: data, options:JSONSerialization.ReadingOptions.mutableContainers)
                guard let tempDict = json as? [String:String] else { return [HSDeviceModel]() }
                guard let tempArrayJson = tempDict[homeId] else { return [HSDeviceModel]() }
                let tempData = tempArrayJson.data(using: String.Encoding.utf8)!
                let tempJson : Any! = try JSONSerialization.jsonObject(with: tempData, options:JSONSerialization.ReadingOptions.mutableContainers)
                guard let tempArray = tempJson as? [[String: Any]] else { return [HSDeviceModel]() }
                let model = Mapper<HSDeviceModel>().mapArray(JSONArray: tempArray)

                return model
            } catch  {
            }
        }
        return [HSDeviceModel]()
    }
}
