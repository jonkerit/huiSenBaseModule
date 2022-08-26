//  huiSenSmart
//
//  Created by jonkersun on 2021/5/19.


import Foundation

public class HSResponse {
    
    public weak var request: HSRequest?
    
    public let urlRequest: URLRequest?
    
    public let httpURLResponse: HTTPURLResponse?
    
    public var originData: Data?
    
    // 如果转换了model就是model，没有model就是originData的data,
    public var data: Any?
    
    public var error: NSError?
    
    public var message: String?
    
    public var fileURL: URL?
    
    public var code: Int = 400

    init(request: HSRequest, urlRequest: URLRequest?, httpURLResponse: HTTPURLResponse?) {
        self.request = request
        self.urlRequest = urlRequest
        self.httpURLResponse = httpURLResponse
    }
    
}

extension HSResponse {
    /// 网络连接服务器状态，不是请求数据是否正确（200为是连接服务器成功）
    public var statusCode: Int {
        return httpURLResponse?.statusCode ?? Int.min
    }
    
    public var header: [AnyHashable : Any] {
        return httpURLResponse?.allHeaderFields ?? [:]
    }
    
}

extension HSResponse {
    
    public var dataDictionary: [String: Any]? {
        if let dataDictionary = data as? [String: Any] {
            return dataDictionary
        }
        return nil
    }
    
    public var dataArray: [[String: Any]]? {
        if let dataArray = data as? [[String: Any]] {
            return dataArray
        }
        return nil
    }
    
    public var dataString: String? {
        if let data = originData, let dataString = String(data: data, encoding: .utf8) {
            return dataString
        }
        return nil
    }
    
    
    /// JsonObject to Model
    ///
    /// - Parameter Model: Model: Decodable
    /// - Returns: Model
    public func decode<T: Decodable>(to Model: T.Type) -> T? {
        var decodeData: Data = Data()
        do {
            if let data = self.data as? Data {
                decodeData = data;
            }
            else {
                if let data = self.data {
                    decodeData = try JSONSerialization.data(withJSONObject: data)
                }
            }
            if let target = self.request?.target {
                let data: T = try target.decoder.decode(Model.self, from: decodeData)
                return data
            }
        } catch {
            self.error = error as NSError
            debugPrint(error)
        }
        return nil
    }
    
}

extension HSResponse: CustomDebugStringConvertible {
    
    public var debugDescription: String {
        
        var dataString: String? = "nil"
        
        if let url = fileURL {
            dataString = url.absoluteString
        }
        else {
            dataString = (originData == nil) ? "nil" : String(data: originData!, encoding: .utf8)
        }
        
        return """
        
        ------------------------ HSResponse ----------------------
        URL:\(request?.URLString ?? "")
        \(dataString!)
        error:\(String(describing: error))
        ----------------------------------------------------------
        
        """
    }
    
}
