//
//  HSURLRequest.swift
//  JonkerItDemoAPP
//
//  Created by jonker.sun on 2022/2/14.
//

import UIKit

public struct HSHTTPMethod: RawRepresentable, Equatable, Hashable {
    /// `CONNECT` method.
    public static let connect = HSHTTPMethod(rawValue: "CONNECT")
    /// `DELETE` method.
    public static let delete = HSHTTPMethod(rawValue: "DELETE")
    /// `GET` method.
    public static let get = HSHTTPMethod(rawValue: "GET")
    /// `HEAD` method.
    public static let head = HSHTTPMethod(rawValue: "HEAD")
    /// `OPTIONS` method.
    public static let options = HSHTTPMethod(rawValue: "OPTIONS")
    /// `PATCH` method.
    public static let patch = HSHTTPMethod(rawValue: "PATCH")
    /// `POST` method.
    public static let post = HSHTTPMethod(rawValue: "POST")
    /// `PUT` method.
    public static let put = HSHTTPMethod(rawValue: "PUT")
    /// `TRACE` method.
    public static let trace = HSHTTPMethod(rawValue: "TRACE")

    public let rawValue: String

    public init(rawValue: String) {
        self.rawValue = rawValue
    }
}

public class HSURLRequest: NSObject {
    /// 请求方式
    var method:HSHTTPMethod?
    /// 请求URL
    var URLString:String?
    /// 请求参数
    var parameters:Any?
    /// 服务方式
    var networkTarget:HSFNetworkTarget?
    /// Request
    var myRequest:URLRequest?
    /// Request
    var session:URLSessionDataTask?
    /// 下载的文件的存储地址
    var filePath:String?
    
    func createURLrequest(URLString:String, parameters:Any?, method:HSHTTPMethod, isHaveToken:Bool = true, networkTarget:HSFNetworkTarget) -> URLRequest? {
        self.method = method
        self.URLString = URLString
        self.parameters = parameters
        self.method = method
        self.networkTarget = networkTarget
        
        // 处理URL
        var parameterString = ""
        if method == .get && parameters != nil{
            if let tempP = parameters! as? [String: Any], tempP.keys.count > 0 {
                for (i,item) in tempP.keys.enumerated() {
                    if let string = tempP[item] as? String {
                        parameterString = "\(parameterString)\(item)=\(string)"
                    }else{
                        do {
                            let data = try JSONSerialization.data(withJSONObject: tempP[item] as Any, options: .fragmentsAllowed)
                            
                            let str = String.init(data: data, encoding: .utf8)
                            
                            parameterString = "\(parameterString)\(item)=\(str ?? "")"
                        } catch {
                            return nil
                        }
                    }
                    
                    if i < tempP.keys.count - 2{
                        parameterString = "\(parameterString)&"
                    }
                }
                var charSet = CharacterSet.urlQueryAllowed
                charSet.insert(charactersIn: "#,&,%,@,*")
                parameterString = parameterString.addingPercentEncoding(withAllowedCharacters: charSet)!
            }
        }
        
        var tempURL = HSNetworkQuery.addQueryParameters(networkTarget.baseURLString+URLString)
        if !parameterString.isEmpty {
            if tempURL.contains("?") {
                tempURL = "\(tempURL)&\(parameterString)"
            }else{
                tempURL = "\(tempURL)?\(parameterString)"
            }
        }
        
        guard let url = URL.init(string: tempURL) else {
            return nil
        }
        var customRequest = URLRequest.init(url: url, cachePolicy: .reloadIgnoringCacheData, timeoutInterval: TimeInterval(networkTarget.overTime))
        customRequest.httpMethod = method.rawValue
        customRequest.allHTTPHeaderFields = networkTarget.headers
        // 处理body
        if method == .post {
            guard let parameters = parameters else { return customRequest }

            if let value = parameters as? String {
                if let data = value.data(using: .utf8, allowLossyConversion: false) {
                    customRequest.httpBody = data
                }
            } else if let array = parameters as? [Any]{
                do {
                    let data = try JSONSerialization.data(withJSONObject: array, options: .fragmentsAllowed)
                    customRequest.httpBody = data
                } catch {
                    return nil
                }
            }else if let dictTemp = parameters as? [String: Any] {
                do {
                    let data = try JSONSerialization.data(withJSONObject: dictTemp, options: .fragmentsAllowed)
                    customRequest.httpBody = data
                } catch {
                    return nil
                }
            }else{
                #if huiSenSmart
                HSDebugLog("⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️该请求\(tempURL)的参数类型不支持,只支持string、[Any]、[String： Any]⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️")
                #endif
            }
        }
        #if huiSenSmart
        HSDebugLog("\n------------------------ HSFRequest -----------------------\n URL:\(tempURL)\n  Headers:\(String(describing: customRequest.allHTTPHeaderFields))\nParameters:\(String(describing: self.parameters))\n ----------------------------------------------------------")
        #endif
        
        return customRequest
    }
    
    // 加密数据
    private func encodeData(_ parameters:AnyObject) -> Data{
        let data = try? JSONSerialization.data(withJSONObject: parameters, options: [])
        return data ?? Data()
    }
    public var requestID: String {
        var string = myRequest?.url?.absoluteString ?? ""
        if parameters != nil {
            let data = try? JSONSerialization.data(withJSONObject: parameters!, options: [])
            let str = String(data: data!, encoding: String.Encoding.utf8) ?? ""
            string = string + str
        }
        return string.data(using: .utf8)?.base64EncodedString() ?? ""
    }
}
