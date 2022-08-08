//
//  HSNetworkQuery.swift
//  huiSenSmart
//
//  Created by jonker.sun on 2022/2/22.
//

import UIKit
import CoreTelephony
import AdSupport
import Reachability

class HSNetworkQuery: NSObject {
    // MARK: - Public
    /// 给请求的url添加query（？后）加入公共参数
    static func addQueryParameters(_ URLString: String) -> String {
//        return URLString
        let query = HSNetworkQuery()
        let parameters = query.createPublicParameters()
        var components: [(String, String)] = []
        for key in parameters.keys.sorted(by: <) {
            let value = parameters[key]!
            components += [(key, value)]
        }
        let temp = components.map { "\($0)=\($1)" }.joined(separator: "&")
        // 编码
        var charSet = CharacterSet.urlQueryAllowed
        charSet.insert(charactersIn: "=,&,?,#")
        let encodingURL = temp.addingPercentEncoding(withAllowedCharacters: charSet)!
        return "\(URLString)?\(encodingURL)"
    }
    
    static func getNetworkStatus() -> String{
        let query = HSNetworkQuery()
        return query.netconnType()
    }
    
    // MARK: - Private
    private func createPublicParameters()-> [String:String]{
        let ​​infoDictionary = Bundle.main.infoDictionary!
        var tempDict = [String: String]()
        tempDict["model"] = UIDevice.current.model
        tempDict["network"] = netconnType()
        tempDict["make"] = "apple"
        tempDict["screen_width"] = "\(UIScreen.as.screenWidth)"
        tempDict["screen_height"] = "\(UIScreen.as.screenHeight)"
        tempDict["os"] = UIDevice.current.systemName
        tempDict["version"] = UIDevice.current.systemVersion
        tempDict["idfa"] = ASIdentifierManager.shared().advertisingIdentifier.uuidString
        tempDict["idfv"] = UIDevice.current.identifierForVendor?.uuidString
        tempDict["language"] = getCurrentLanguage()
        tempDict["country"] = NSLocale.current.identifier
        tempDict["app_version"] = ​​infoDictionary["kCFBundleVersionKey"] as? String
        tempDict["ServiceProvider"] = getServiceProvider()
        tempDict["call_time"] = "\(Date.as.currentTimeStamp()*1000)"
        tempDict["platform"] = UIDevice.current.model

        return tempDict
    }
    
    private func getServiceProvider() -> String? {
        //获取并输出运营商信息
        let info = CTTelephonyNetworkInfo()
        if let carrier = info.subscriberCellularProvider?.carrierName {
            return carrier
        }else {
            return nil
        }
    }
    
    private func getCurrentLanguage() -> String {
        let preferredLang = Bundle.main.preferredLocalizations.first! as NSString
        switch String(describing: preferredLang) {
        case "en-US", "en-CN":
            return "en"//英文
        case "zh-Hans-US","zh-Hans-CN","zh-Hant-CN","zh-TW","zh-HK","zh-Hans":
            return "cn"//中文
        default:
            return String(describing: preferredLang)
        }
    }
        
    // 判断网络类型
    private func netconnType() -> String {
        var netconnType = "5G"
        let rach = Reachability.init(hostName: "www.apple.com")
        let temp = rach?.currentReachabilityStatus()
        switch temp {
        case NotReachable: 
            netconnType = "no network"
            break
        case ReachableViaWiFi:
            netconnType = "Wifi"
            break
        case ReachableViaWWAN:
            do {
                guard let info = CTTelephonyNetworkInfo().currentRadioAccessTechnology else { return "no network" }
                
                if info == "CTRadioAccessTechnologyGPRS" {
                    netconnType = "GPRS"
                }else if info == "CTRadioAccessTechnologyEdge" {
                    netconnType = "2.75G EDGE"
                }else if info == "CTRadioAccessTechnologyWCDMA" {
                    netconnType = "3G"
                }else if info == "CTRadioAccessTechnologyHSDPA" {
                    netconnType = "3.5G HSDPA"
                }else if info == "CTRadioAccessTechnologyHSUPA" {
                    netconnType = "3.5G HSUPA"
                }else if info == "CTRadioAccessTechnologyCDMA1x" {
                    netconnType = "2G"
                }else if info == "CTRadioAccessTechnologyCDMAEVDORev0" {
                    netconnType = "3G"
                }else if info == "CTRadioAccessTechnologyCDMAEVDORevA" {
                    netconnType = "3G"
                }else if info == "CTRadioAccessTechnologyCDMAEVDORevB" {
                    netconnType = "3G"
                }else if info == "CTRadioAccessTechnologyeHRPD" {
                    netconnType = "HRPD"
                }else if info == "CTRadioAccessTechnologyLTE" {
                    netconnType = "4G"
                }
            }
            break
        default:
            break
        }
        
        return netconnType
    }
    // MARK: - setter & getter
    
}
// MARK: - Other Delegate
//extension HSNetworkQuery : {
//
//}
