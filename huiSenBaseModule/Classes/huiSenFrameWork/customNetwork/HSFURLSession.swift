//
//  HSFURLSession.swift
//  JonkerItDemoAPP
//
//  Created by jonker.sun on 2022/2/15.
//

import UIKit
import Foundation
public typealias HSURLSessionTaskCompletionHandler = (Data?,URLResponse?,Error?) -> Void

class HSFURLSession: NSObject {
    static var sharedInstance = HSFURLSession()
    
    func dataTask(request:URLRequest, completionHandler:@escaping HSURLSessionTaskCompletionHandler) -> URLSessionDataTask{
       return URLSession.shared.dataTask(with: request, completionHandler: completionHandler)
    }
    
    
    lazy var queue:OperationQueue = {
        let queue = OperationQueue()
        queue.maxConcurrentOperationCount = 4
        return queue
    }()
}
