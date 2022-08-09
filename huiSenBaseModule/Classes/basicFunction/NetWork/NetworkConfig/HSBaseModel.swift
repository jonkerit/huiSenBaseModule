//
//  HSBaseModel.swift
//  huiSenSmart
//
//  Created by jonker.sun on 2022/2/22.
//

import UIKit


public struct HSBaseModel: Decodable {
    
    var code = 0
    var message = ""
    var data: [String]?
    
    
    
//    public func mapping(map: Map) {
//        code <- map["code"]
//        message <- map["message"]
//        data <- map["data"]
//    }
}

