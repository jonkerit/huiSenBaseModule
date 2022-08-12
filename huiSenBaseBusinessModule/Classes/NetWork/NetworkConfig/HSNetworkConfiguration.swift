//
//  HSNetworkConfiguration.swift
//  huiSenSmart
//
//  Created by jonker.sun on 2022/6/28.
//

import UIKit

public class HSNetworkConfiguration: NSObject {
    /// 创建一个header
    
    /// - Parameter isHaveToken: 是否带token
    /// - Returns: HTTPHeaders
    public static func createHeader(isHaveToken: Bool) -> HTTPHeaders {
        var tempDict = ["Accept":"application/json", "Content-Type": "application/json"]
        if isHaveToken && !HSAppToken.isEmpty {
            tempDict["Access-Token"] = HSAppToken
        }
        return HTTPHeaders.init(tempDict)
    }
}
