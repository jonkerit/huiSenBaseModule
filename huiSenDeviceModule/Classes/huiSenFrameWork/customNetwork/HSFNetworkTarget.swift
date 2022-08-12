//
//  HSFNetworkTarget.swift
//  JonkerItDemoAPP
//
//  Created by jonker.sun on 2022/2/15.
//

import Foundation

/// 以服务器区分请求
enum HSFNetworkTargetType {
    case Default
    case VCB
    case Other
}

struct HSFNetworkTarget {
    var baseURLString: String  = HSAPPBaseUrl
    var headers = [String : String]()
    var overTime:Float = 10.0
    
    mutating func createNetworkTarget(with NetworkTargetType:HSFNetworkTargetType, isHaveToken:Bool, overTime:Float){
        switch NetworkTargetType {
        case .Default:
            do {
            baseURLString = HSAPPBaseUrl
            self.overTime = overTime
            headers = ["Accept":"application/json","Content-Type":"application/json","mobileType":"IOS"]
            // to do
            if isHaveToken {
                headers["Access-Token"] = HSWebOpenFunction.shared.SDKTokenString
            }
            headers["home_id"] = HSWebOpenFunction.shared.homeIdString
        }
            break
        case .VCB:
            do {
            baseURLString = ""
            self.overTime = overTime
            headers["Access-Token"] = ""
        }
            break
        case .Other:
            do {
            baseURLString = ""
            self.overTime = overTime
                // to do
            if isHaveToken {
                headers["Access-Token"] = HSWebOpenFunction.shared.SDKTokenString
            }
            headers["home_id"] = HSWebOpenFunction.shared.homeIdString
        }
            break
        }
    }
}
