//
//  HSH5APIRequest.swift
//  huiSenSmart
//
//  Created by jonker.sun on 2022/4/21.
//

import UIKit

public class HSH5APIRequest: NSObject {
    
    /// H5请求API
    /// - Parameters:
    ///   - apiName: API路径
    ///   - parameters: 参数,可以是string、[Any]、[String： Any]
    ///   - completioned: 回调
    /// - Returns: 请求
    public static func requstH5ApiData(apiName:String, parameters:Any?, completioned:@escaping HSCompletionStringClosure) {
            var patchURL = apiName
            if !apiName.contains("app/api/") {
                patchURL = "/app/api/\(apiName)"
            }
            HSNetworkManager.sharedInstance.HSNetworkOutTime = 65.0
            HSNetworkManager.sharedInstance.requestHttp(URLString: patchURL, parameters: parameters, hethod:.post) { response in
                var jsonString: String?
                if response.code == 200 && response.data != nil {
                    jsonString = String.as.JSONObjcToJSONString(response.data!)
                }
                if response.code != 200 {
                    let errorString = response.message ?? "数据请求失败"
                    let errorDict = ["error":errorString]
                    jsonString = String.as.dictionaryToJSONString(errorDict)
                }
                if jsonString == nil || jsonString!.isEmpty{
                    jsonString = "{}"
                }
                completioned(response, jsonString!)
            }
        }
//    @discardableResult

//    static func requstH5ApiData(apiName:String, parameters:[String: Any]?, completioned:@escaping CompletionDeviceClosure) -> HSRequest {
//        let patchURL = "/app/api/\(apiName)"
//
//        let requst = HSRequest.init(method: .post, URLString: nil, path:patchURL, parameters: parameters, parameterEncoding: JSONEncoding.default, headers: HSNetworkConfiguration.createHeader(isHaveToken: true))
//        HSDefaultNetwork.request(requst) { response in
//            var jsonString: String?
//            if response.code == 200 && response.data != nil {
//                jsonString = String.as.JSONObjcToJSONString(response.data!)
//            }
//            if response.code != 200 {
//                let errorString = response.message ?? "数据请求失败"
//                let errorDict = ["error":errorString]
//                jsonString = String.as.dictionaryToJSONString(errorDict)
//            }
//            if jsonString == nil {
//                jsonString = ""
//            }
//            completioned(response, jsonString ?? "")
//        }
//        return requst
//    }
}


