//
//  HSGetRequest.swift
//  huiSenSmart
//
//  Created by jonker.sun on 2022/2/25.
//

import UIKit

class HSGetRequest: HSRequest {
    /// 子类需要重写此类，默认是带token的，不需要带可以重写eg headers = HSNetworkConfiguration.createHeader(isHaveToken:false),加入其他配置比如： path = XXXX
    override func loadRequest() {
        super.loadRequest()
        headers = HSNetworkConfiguration.createHeader(isHaveToken: true)
        method = .get
    }
    
    /*
     如果带参数直接用属性定义
     var XXX:XXX?
     
     /// model 直接转 jsonObject
     override var jsonObject: Any? { get }
     
     
     /// 不用编码到json里面的内容（传值用的参数）
     override var blackList: [String] { get }
     
     */
}
