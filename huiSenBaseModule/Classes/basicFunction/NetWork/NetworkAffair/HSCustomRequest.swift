//
//  HSCustomRequest.swift
//  huiSenSmart
//
//  Created by jonker.sun on 2022/5/5.
//

import UIKit


/// 主要是针对body 不是字典的请求
class HSCustomRequest: HSRequest {
    private var customParameters: Any?
    init(method: HTTPMethod,
           path: String,
     parameters: Any? = nil,
        headers: HTTPHeaders? = HSNetworkConfiguration.createHeader(isHaveToken: true)) {
        super.init(method: method, URLString: nil, path: path, parameters: nil, parameterEncoding: URLEncoding.default, headers: headers)
        customParameters = parameters
        loadRequest()
    }
    
    /// 子类需要重写此类，默认是带token的，不需要带可以重写eg headers = HSNetworkConfiguration.createHeader(isHaveToken:false),加入其他配置比如： path = XXXX
    override func loadRequest() {
        super.loadRequest()
        urlRequest = createCustomRequest()
    }

    func createCustomRequest() -> URLRequestConvertible?  {
        let searchURL = NSURL(string: HSAPPBaseUrl + path as String)
        var customRequest = URLRequest.init(url:searchURL! as URL, cachePolicy: .useProtocolCachePolicy, timeoutInterval: timeoutInterval)
        customRequest.headers = headers ?? HSNetworkConfiguration.createHeader(isHaveToken: true)
        var methodString = "POST"
        switch self.method {
            case .post:
                methodString = "POST"
                break
            case .get:
                methodString = "GET"
                break
            case .put:
                methodString = "PUT"
                break
            case .delete:
                methodString = "DELETE"
                break
            case .options:
                methodString = "OPTIONS"
                break
            case .patch:
                methodString = "PATCH"
                break
            case .trace:
                methodString = "TRACE"
                break
            default:
                methodString = "POST"
        }
        customRequest.httpMethod = methodString
        guard let jsonData = try? JSONSerialization.data(withJSONObject: customParameters as Any, options: .fragmentsAllowed) else {
            return customRequest
        }
        guard let stringData = NSString.init(data: jsonData, encoding: String.Encoding.utf8.rawValue) else {
            return customRequest
        }
        customRequest.httpBody = stringData.data(using: String.Encoding.utf8.rawValue)
        return customRequest
    }
}

