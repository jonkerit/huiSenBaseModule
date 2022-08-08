//
//  HSNetworkConfiguration.swift
//  huiSenSmart
//
//  Created by jonker.sun on 2022/6/28.
//

import UIKit

class HSNetworkConfiguration: NSObject {
    /// 创建一个header
    
    /// - Parameter isHaveToken: 是否带token
    /// - Returns: HTTPHeaders
    static func createHeader(isHaveToken: Bool) -> HTTPHeaders {
        var tempDict = ["Accept":"application/json", "Content-Type": "application/json"]
        if isHaveToken && !HSAPPNetworkConfiguration.HSAppToken.isEmpty {
            tempDict["Access-Token"] = HSAPPNetworkConfiguration.HSAppToken
        }
        return HTTPHeaders.init(tempDict)
    }
}
