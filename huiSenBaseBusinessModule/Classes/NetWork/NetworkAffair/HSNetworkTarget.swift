//
//  HSNetworkTarget.swift
//  huiSenSmart
//
//  Created by jonkersun on 2021/5/19.
//

import Foundation

/// 黛马默认的请求Network配置
public let HSDefaultNetwork = HSNetwork(HSNetworkTarget())

public struct HSNetworkTarget: HSTarget {
    public var baseURLString: String = HSAPPBaseUrl
    public var IPURLString: String? {
        get {
            return storeIPURLString
        }
        set {
            storeIPURLString = newValue
        }
    }
    // 默认JSONEncoding打包数据，可以在HSBaseRequest中修改
    public var parameterEncoding: ParameterEncoding = JSONEncoding.default
    
    public var allHostsMustBeEvaluated: Bool = false
    
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
    
    public var plugins: [HSPlugin]? = [HSNetwworkPlugin()]
    
    public var reachabilityListener: ReachabilityListener? {
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
    
    public var storeIPURLString: String?
    // 需要修改
    public var status: (codeKey: String, successCode: Int, messageKey: String?, dataKeyPath: String?)?{
        return (codeKey: "code", successCode: 200, messageKey: "err_msg", dataKeyPath: "data")
    }
}

//"api.github.com"
//"https://192.30.255.117"

