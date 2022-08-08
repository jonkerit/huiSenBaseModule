//  huiSenSmart
//
//  Created by jonkersun on 2021/5/19.


import Foundation

private let NSURLSessionResumeOriginalRequest = "NSURLSessionResumeOriginalRequest"
private let NSURLSessionResumeCurrentRequest = "NSURLSessionResumeCurrentRequest"


extension HSNamespace where Base == URLSessionTask {
    
    /// fix 10.0 - 10.1 resumeData bug: https://stackoverflow.com/questions/39346231/resume-nsurlsession-on-ios10/39347461#39347461
    ///
    /// - Parameter data:
    func fixiOS10Task(with data: Data) {
        guard #available(iOS 10.2, *) else {
            guard let resumeDictionary = HSResumeData.dictionary(of: data) else { return }
            if base.originalRequest == nil, let originalReqData = resumeDictionary[NSURLSessionResumeOriginalRequest] as? Data, let originalRequest = NSKeyedUnarchiver.unarchiveObject(with: originalReqData) as? NSURLRequest {
                base.setValue(originalRequest, forKey: "originalRequest")
            }
            if base.currentRequest == nil, let currentReqData = resumeDictionary[NSURLSessionResumeCurrentRequest] as? Data, let currentRequest = NSKeyedUnarchiver.unarchiveObject(with: currentReqData) as? NSURLRequest {
                base.setValue(currentRequest, forKey: "currentRequest")
            }
            return
        }
    }
    
}
