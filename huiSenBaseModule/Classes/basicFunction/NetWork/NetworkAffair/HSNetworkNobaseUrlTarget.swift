//
//  HSNetworkNobaseUrlTarget.swift
//  huiSenSmart
//
//  Created by jonker.sun on 2022/3/15.
//

import UIKit
/// 黛马默认的请求Network配置
let HSDefaultNobaseUrlNetwork = HSNetwork(HSNetworkNobaseUrlTarget())

struct HSNetworkNobaseUrlTarget: HSTarget {
    var baseURLString: String = ""
    var IPURLString: String? {
        get {
            return storeIPURLString
        }
        set {
            storeIPURLString = newValue
        }
    }
    // 默认JSONEncoding打包数据，可以在HSBaseRequest中修改
    var parameterEncoding: ParameterEncoding = JSONEncoding.default
    
    var allHostsMustBeEvaluated: Bool = false
    
//    var serverEvaluators: [String : ServerTrustEvaluating]? {
//        #if DEBUG
//        let validateHost = false
//        #else
//        let validateHost = true
//        #endif
//
//        let evaluators: [String: ServerTrustEvaluating] = [
//            host: PinnedCertificatesTrustEvaluator(validateHost: validateHost)
//        ]
//
//        return evaluators
//    }
    
//    var clientTrustPolicy: (secPKCS12Path: String, password: String)? = (secPKCS12Path: Bundle.main.path(forResource: "github", ofType: "p12") ?? "", password: "123456")
    
    var plugins: [HSPlugin]? = [HSNetwworkPlugin()]
    
    var reachabilityListener: ReachabilityListener? {
        return { (status) in
            switch status {
                
            case .unknown:
                debugPrint("unknown")
                
            case .notReachable:
                debugPrint("notReachable")
                
            case .reachable(let connectionType):
                switch connectionType {
                    
                case .ethernetOrWiFi:
                    debugPrint("ethernetOrWiFi")
                    
                case .cellular:
                    debugPrint("cellular")
                    
                }
            }
        }
    }
    
    var storeIPURLString: String?
    // 需要修改
    var status: (codeKey: String, successCode: Int, messageKey: String?, dataKeyPath: String?)?{
        return (codeKey: "code", successCode: 200, messageKey: "err_msg", dataKeyPath: "data")
    }
}

//"api.github.com"
//"https://192.30.255.117"

