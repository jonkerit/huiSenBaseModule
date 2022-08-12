//
//  HSFResponse.swift
//  JonkerItDemoAPP
//
//  Created by jonker.sun on 2022/2/15.
//

import Foundation

public class HSFResponse {
    
    public weak var sessionTask: URLSessionTask?
    
    public let urlRequest: HSURLRequest?
    
    public let httpURLResponse: HTTPURLResponse?
    
    public var originData: Data?
    
    public var data: Any?
    
    public var error: NSError?
    
    public var message: String?
    
    public var fileURL: URL?
    
    public var code: Int = 500

    
    init(sessionTask: URLSessionTask?, urlRequest: HSURLRequest?, httpURLResponse: HTTPURLResponse?) {
        self.sessionTask = sessionTask
        self.urlRequest = urlRequest
        self.httpURLResponse = httpURLResponse
    }
    
}

extension HSFResponse {
    
    public var statusCode: Int {
        return httpURLResponse?.statusCode ?? Int.min
    }
    
    public var header: [AnyHashable : Any] {
        return httpURLResponse?.allHeaderFields ?? [:]
    }
    
}

extension HSFResponse {
    
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
            let decoder = JSONDecoder()
            decoder.dateDecodingStrategy = .secondsSince1970
            let data: T = try decoder.decode(Model.self, from: decodeData)
            return data
        } catch {
            self.error = error as NSError
        }
        return nil
    }
}
