//
//  HSNetworkManager.swift
//  JonkerItDemoAPP
//
//  Created by jonker.sun on 2022/2/15.
//

//
//  HSNetworkManager.swift
//  JonkerItDemoAPP
//
//  Created by jonkersun on 2021/5/19.
//

import UIKit
import Foundation

enum HSNetworkStatus {
    case unKown         //unkonwn
    case noReachable    //无网
    case wifi           //Wi-Fi
    case wWAN           //WWAN
}
public typealias HSCompletionClosure = (HSFResponse) -> Void
public typealias HSProgressClosure = (HSFProgress) -> Void
public typealias HSCompletionStringClosure = (HSFResponse, String) -> Void

class HSNetworkManager: NSObject {
    /// request请求超时时间（数据上传和下载也默认用这个时间）
    var HSNetworkOutTime:Float = 10.0
    static let sharedInstance = HSNetworkManager()
    
    private override init() {}
    // 缓存的请求-结构【VCName:[HSURLRequest]】
    private var HSURLRequestCacheDict:[String:[HSURLRequest]] = [String:[HSURLRequest]]()
    
    // 创建一个请求服务
    private func createNetworkTarget(_ networkTargetType:HSFNetworkTargetType, _ isHaveToken: Bool) -> HSFNetworkTarget{
         var networkTarget = HSFNetworkTarget()
        networkTarget.createNetworkTarget(with: networkTargetType, isHaveToken: isHaveToken, overTime:HSNetworkOutTime)
        // 恢复默认设置
        HSNetworkOutTime = 10.0
        return networkTarget
    }

    // 缓存请求 - 判断该请求是否存在（存在就需要覆盖上一次的请求）
//    private func cacheNetworkRequest(_ request:HSURLRequest){
//        let vcName = NSStringFromClass(type(of: self))
//        var isHave:Bool = false
//        var tempArry:[HSURLRequest] = HSURLRequestCacheDict[vcName] ?? [HSURLRequest]()
//    
//        for (index, element) in tempArry.enumerated() {
//            if element.requestID == request.requestID {
//                element.cancel()
//                tempArry[index] = request
//                isHave = true
//                break
//            }
//        }
//        if !isHave {
//            tempArry.append(request)
//        }
//        HSURLRequestCacheDict[vcName] = tempArry
//    }
    
    // 处理请求结果
    private func dealResult(response:HSFResponse, completioned: @escaping HSCompletionClosure){
        // 移除缓存请求
//        if response.request != nil {
//            for key in HSURLRequestCacheDict.keys {
//                guard var tempArr =  HSURLRequestCacheDict[key] else {
//                    break
//                }
//                for (index,request) in tempArr.enumerated() {
//                    if request.requestID == response.request!.requestID {
//                        tempArr.remove(at: index)
//                        HSURLRequestCacheDict[key] = tempArr
//                        break
//                    }
//
//                }
//            }
//        }
        
        // 判断是否请求失效
        if response.statusCode == 0 {
            // 重新登录
        }
        // 回调
        completioned(response)
    }
    
    // 加密数据
    private func encodeData(_ parameters:AnyObject) -> Data{
        let data = try? JSONSerialization.data(withJSONObject: parameters, options: [])
        return data ?? Data()
    }
}

/// 对外请求接口
extension HSNetworkManager{
    
    /// http data请求 -- 对请求不加密
    /// - Parameters:
    ///   - URLString: URL
    ///   - parameters: 参数,可以是string、[Any]、[String： Any]
    ///   - hethod: 请求的方式
    ///   - isHaveToken: 是否需要登录信息
    ///   - networkTargetType: 请求的目标服务
    ///   - completioned: 完成后的回调
    func requestHttp(URLString:String, parameters:Any?, hethod:HSHTTPMethod = .get, isHaveToken:Bool = true, networkTargetType:HSFNetworkTargetType = .Default, completioned: @escaping HSCompletionClosure) {

        HSFURLSession.sharedInstance.queue.addOperation {
            let networkTarget = self.createNetworkTarget(networkTargetType, isHaveToken)
            let request = HSURLRequest()
            let MyURLRequest = request.createURLrequest(URLString: URLString, parameters: parameters, method: hethod, isHaveToken: isHaveToken, networkTarget: networkTarget)
            guard let MyURLRequest = MyURLRequest else {
                let response = HSFResponse.init(sessionTask: nil, urlRequest: nil, httpURLResponse: nil)
                response.code = 500
                response.message = "网络错误"
                completioned(response)
                return  }
            let mySessiontask = HSFURLSession.sharedInstance.dataTask(request: MyURLRequest) { [weak self] data, Response, error in
                self?.dealResponseOfDataRequest(sessionTask: nil, urlRequest: request, URLResponse: Response,originData:data,error:error, completionClosure: completioned)
            }
            mySessiontask.resume()
            request.myRequest = MyURLRequest
            request.session = mySessiontask
        }
                
//        request
//        HSURLRequest.init(method: hethod, URLString: URLString, path: URLString, parameters: parameters, parameterEncoding: URLEncoding.default, headers: nil)
//        cacheNetworkRequest(request)
//        // 发出请求
//        network.request(request) { [weak self] (response) in
//            // 处理请求结果
//            self?.dealResult(response:response,completioned:completioned)
//        }
    }
   
    
    /// http data post请求  -- 对请求的body需要加密
    /// - Parameters:
    ///   - URLString: URL
    ///   - parameters: 参数-【这里只支持数组和字典】
    ///   - isHaveToken: 是否需要登录信息
    ///   - networkTargetType: 请求的目标服务
    ///   - completioned: 完成后的回调
//    func requestEncodeHttp(URLString:String, parameters:AnyObject, isHaveToken:Bool = true, networkTargetType:HSNetworkTargetType = .Default, completioned: @escaping HSNetworkRequestCompletionBlock) {
//        let network = createNetworkTarget(networkTargetType, isHaveToken)
//        let request = HSURLRequest.init(method: .post, URLString: URLString, path: URLString, parameters: nil, parameterEncoding: JSONEncoding.default, headers: nil)
//        var customURLRequest:URLRequest = URLRequest.init(url: URL.init(string: URLString)!, cachePolicy: .useProtocolCachePolicy, timeoutInterval: TimeInterval(HSNetworkOutTime))
//        // 加密可以在这做
//        customURLRequest.httpBody = encodeData(parameters)
//        request.urlRequest = customURLRequest
//        cacheNetworkRequest(request)
//        // 发出请求
//        network.request(request) { [weak self] (response) in
//            // 处理请求结果
//            self?.dealResult(response:response,completioned:completioned)
//        }
//    }
//
//    /// 上传数据
//    /// - Parameters:
//    ///   - upData: 数据
//    ///   - URLString: URL
//    ///   - parameters: 参数-【这里只支持数组和字典】
//    ///   - serviceName: 该文件在服务器的key
//    ///   - fileName: 该文件在服务器的文件名称
//    ///   - isHaveToken: 是否需要登录信息
//    ///   - networkTargetType: 请求的目标服务
//    ///   - completioned: 完成后的回调
//    func requestUpData(upData:Data, URLString:String, parameters:Parameters?, serviceName:String, fileName:String, isHaveToken:Bool = true, networkTargetType:HSNetworkTargetType = .Default, progresses:@escaping ProgressClosure, completioned: @escaping HSNetworkRequestCompletionBlock) {
//        let network = createNetworkTarget(networkTargetType, isHaveToken)
//        let request = HSUploadRequest.init(method: .post, URLString: URLString, path: URLString, parameters: parameters, parameterEncoding: URLEncoding.default, headers: nil)
//        request.data = upData
//        cacheNetworkRequest(request)
//        network.upload(request, progressClosure: { (progress) in
//            progresses(progress)
//        }) { [weak self] (response) in
//            // 处理请求结果
//            self?.dealResult(response:response,completioned:completioned)
//        }
//    }
//
//
    /// 下载数据
    /// - Parameters:
    ///   - URLString: URL
    ///   - fileName: 该文件在下载完后的文件名称
    ///   - isHaveToken: 是否需要登录信息
    ///   - networkTargetType: 请求的目标服务
    ///   - progress: 下载进度
    ///   - completioned: 完成回调
    func requestDownData(URLString:String, resultPath:String, isHaveToken:Bool = true, networkTargetType:HSFNetworkTargetType = .Default, progresses:@escaping HSProgressClosure, completioned: @escaping HSCompletionClosure) {
        let networkTarget = self.createNetworkTarget(.Other, isHaveToken)
        let request = HSURLRequest()
        let MyURLRequest = request.createURLrequest(URLString: URLString, parameters: nil, method: .get, isHaveToken: isHaveToken, networkTarget: networkTarget)
        let url = URL.init(fileURLWithPath: resultPath)

        guard let MyURLRequest = MyURLRequest else { return  }
        let _ = DownloaderManager.shared.download(request: MyURLRequest, filePath: url) { progress in
            progresses(progress)
        } completion: { response in
            DispatchQueue.main.async {
                completioned(response)
            }
        } fail: { error in
            DispatchQueue.main.async {
                let response = HSFResponse.init(sessionTask: nil, urlRequest: nil, httpURLResponse: nil)
                response.message = error
                completioned(response)
            }
        }
        
    }
//        let network = createNetworkTarget(networkTargetType, isHaveToken)
//        let request = HSDownloadRequest.init(method: .post, URLString: URLString, path: URLString, parameters: nil, parameterEncoding: URLEncoding.default, headers: nil)
//        // 设置为可以恢复下载
//        request.isResume = true
//        // 设置存储地址
//        let cachePath = FileManager.as.cacheDirectory as String
//        let URLStr = cachePath + "/\(fileName)"
//        if FileManager.default.fileExists(atPath:URLStr) {
//            FileManager.default.isDeletableFile(atPath:URLStr)
//        }
//        request.destinationURL = URL.init(string: URLStr)
//        cacheNetworkRequest(request)
//        network.download(request, progressClosure: { (progress) in
//            progresses(progress)
//        }) { [weak self] (response) in
//            // 处理请求结果
//            self?.dealResult(response:response,completioned:completioned)
//        }
//    }
}

/// 对外功能接口
extension HSNetworkManager{
    
    /// 以控制器为目标对象，控制请求
    /// - Parameter targetVC: 目标控制器
//    func cancelHttpRequsetWithVC(targetVC:UIViewController) {
//        let vcName = NSStringFromClass(type(of: targetVC))
//        let tempArry:[HSURLRequest] = HSURLRequestCacheDict[vcName] ?? [HSURLRequest]()
//        for element in tempArry {
//            element.cancel()
//        }
//        HSURLRequestCacheDict[vcName] = [HSURLRequest]()
//    }
    
    /// 网络监听
//    func netWorkReachability(reachabilityStatus: @escaping(_ status:HSNetworkStatus)->Void){
//        let manager = NetworkReachabilityManager.init()
//        manager!.startListening { (status) in
//
//            //wifi
//            if status == NetworkReachabilityManager.NetworkReachabilityStatus.reachable(.ethernetOrWiFi){
//                debugLog("------.wifi")
//                reachabilityStatus(.wifi)
//            }
//            //不可用
//            if status == NetworkReachabilityManager.NetworkReachabilityStatus.notReachable{
//                debugLog("------没网")
//                reachabilityStatus(.noReachable)
//            }
//            //未知
//            if status == NetworkReachabilityManager.NetworkReachabilityStatus.unknown{
//                debugLog("------未知")
//                reachabilityStatus(.unKown)
//            }
//            //蜂窝
//            if status == NetworkReachabilityManager.NetworkReachabilityStatus.reachable(.cellular){
//                debugLog("------蜂窝")
//                reachabilityStatus(.wWAN)
//            }
//        }
//    }
}
extension HSNetworkManager {
    
    // MARK: - Response
    private func dealResponseOfDataRequest(sessionTask: URLSessionTask?, urlRequest: HSURLRequest?, URLResponse: URLResponse?, originData:Data?, error:Error?, completionClosure: @escaping HSCompletionClosure) {
        
        let response = HSFResponse(sessionTask: sessionTask, urlRequest: urlRequest, httpURLResponse: nil)
        
        if originData != nil {
            response.originData = originData
        }
        toJsonObject(response: response)
        if error != nil {
            let error = NSError(domain: "网络错误", code: 500, userInfo: [NSLocalizedDescriptionKey : response.message ?? "no network"])
            response.error = error as NSError?
            response.message = "no network"
            response.code = 500
        }else{
            decode(request: urlRequest, response: response)
        }
                
        DispatchQueue.main.async {
            completionClosure(response)
            if response.code == 2007 || response.code == 300 {
                NotificationCenter.default.post(name: HSBaseNotificationName.networkDealResult, object: response.code)
            }
            #if huiSenSmart
            if response.data != nil {
                HSDebugLog("\n------------------------ HSFResponse -----------------------\n URL:\(response.urlRequest?.URLString ?? "") \nParameters:\(String(describing: response.urlRequest?.parameters))\n\n response.Data:\(String(describing: response.data))\n ----------------------------------------------------------")
            } else {
                HSDebugLog("\n------------------------ HSFResponse -----------------------\n URL:\(response.urlRequest?.URLString ?? "") \nParameters:\(String(describing: response.urlRequest?.parameters))\n\n response.error:\(String(describing: response.error))\n ----------------------------------------------------------")
            }
            #endif
            urlRequest?.myRequest = nil
        }
    }
    
    
    private func toJsonObject(response: HSFResponse) {
        guard let data = response.originData else { return }
        
        do {
            response.data = try JSONSerialization.jsonObject(with: data, options: .allowFragments)
        }
        catch {
            if let dataString = String(data: data, encoding: .utf8) {
                response.data = dataString
                return
            }
            response.error = error as NSError
        }
    }
    
    private func decode(request:HSURLRequest?, response: HSFResponse) {
        guard let tempDict = response.data as? [String: Any] else {
            let error = NSError(domain: "网络错误", code: 500, userInfo: [NSLocalizedDescriptionKey : response.message ?? "no network"])
            response.error = error
            response.message = "no network"
            response.code = 500
            return }
        response.message = "no network"
        response.code = 500

        if let message = tempDict["err_msg"] as? String {
            response.message = message
        }
        if let statusValue = tempDict["code"] as? Int {
            response.code = statusValue
        }
        if let dict = response.dataDictionary {
            if response.code == 200 {
                response.data = dict["data"]
            }
        }else {
            let error = NSError(domain: "网络错误", code: 500, userInfo: [NSLocalizedDescriptionKey : response.message ?? "no network"])
            response.error = error
            response.message = "no network"
            response.code = 500
        }
    }
}
