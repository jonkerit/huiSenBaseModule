//  huiSenSmart
//
//  Created by jonkersun on 2021/5/19.

import Foundation

/// A type that can inspect and optionally adapt a `URLRequest` in some manner if necessary.
open class HSRequest: HSReflection {
    
    public init(method: HTTPMethod = .get,
                URLString: String? = nil,
                path: String = "",
                parameters: Parameters? = nil,
                parameterEncoding: ParameterEncoding = URLEncoding.default,
                headers: HTTPHeaders? = nil) {
        self.storeMethod = method
        self.storeURLString = URLString
        self.path = path
        self.storeParameters = parameters
        self.headers = headers
        
        loadRequest()
    }
    
    open func loadRequest() {}
    
    public var originalRequest: Request?
    
    /// Base64 string of the request's URLString + method
    public var requestID: String {
        let string = URLString + method.rawValue
        return string.data(using: .utf8)?.base64EncodedString() ?? ""
    }
    
    public var method: HTTPMethod {
        get {
            return storeMethod ?? .get
        }
        set {
            storeMethod = newValue
        }
    }
    
    public var path: String = ""
    
    public var URLString: String {
        get {
            return storeURLString ?? ""
        }
        set {
            storeURLString = newValue
        }
    }
    
    public var parameters: Parameters? {
        get {
            if let parameters = storeParameters {
                return parameters
            }
            else if let parameters = jsonObject as? Parameters {
                storeParameters = parameters
                return parameters
            }
            return nil
        }
        set {
            storeParameters = newValue
        }
    }
    
    public var parameterEncoding: ParameterEncoding {
        get {
            return storeParameterEncoding ?? URLEncoding.default
        }
        set {
            storeParameterEncoding = newValue
        }
    }
        
    public var target: HSTarget? {
        get {
            return storeTarget
        }
        set {
            if storeMethod == nil {
                storeMethod = newValue?.method
            }
            if storeURLString == nil {
                if let IPURLString = newValue?.IPURLString {
                    storeURLString = IPURLString + HSNetworkQuery.addQueryParameters(path)
                    if let host = newValue?.host {
                        if headers == nil {
                            headers = [HSHostKey : host]
                        }
                        else {
                            headers![HSHostKey] = host
                        }
                    }
                }
                else if let baseURLString = newValue?.baseURLString {
                    storeURLString = baseURLString + HSNetworkQuery.addQueryParameters(path)
                }
            }
            if storeParameterEncoding == nil {
                storeParameterEncoding = newValue?.parameterEncoding
            }
            if let targetHeaders = newValue?.headers {
                if let reqHeaders = headers {
                    for (key, value) in targetHeaders.dictionary {
                        if reqHeaders.value(for: key) == nil {
                            headers?.update(name: key, value: value)
                        }
                    }
                }
                else {
                    headers = targetHeaders
                }
            }
            if dataKeyPath == nil {
                dataKeyPath = newValue?.status?.dataKeyPath
            }
            storeTarget = newValue
        }
    }
    
    public var headers: HTTPHeaders?
    
    public var credential: URLCredential?
    
    ///custom Request
    public var urlRequest: URLRequestConvertible?
    
    /// The response's dataKey of the request
    public var dataKeyPath: String?
    
    public var enableLog: Bool {
        get {
            return storeEnableLog ?? target?.enableLog ?? true
        }
        set {
            storeEnableLog = newValue
        }
    }
    
    public var userInfo: Parameters?
    /// 超时时间，默认10s
    public var timeoutInterval: TimeInterval = 10

    //MARK: - Private
    private var storeMethod: HTTPMethod?
    
    private var storeURLString: String?
    
    private var storeParameters: Parameters?
    
    private var storeParameterEncoding: ParameterEncoding?

    private var storeTarget: HSTarget?
    
    private var storeEnableLog: Bool?

    /// Pause the request.
    public func pause() {
        originalRequest?.suspend()
    }
    
    /// Cancel the request.
    public func cancel() {
        originalRequest?.cancel()
    }
    
    /// Resumes the request.
    public func resume() {
        originalRequest?.resume()
    }
}

extension HSRequest {
    @objc open var blackList: [String] {
        return []
    }
}

extension HSRequest: CustomDebugStringConvertible {
    
    public var debugDescription: String {
        
        var headersString: String? = "nil"
        var parametersString: String? = "nil"

        if let headers = headers?.dictionary {
            let headersData = try? JSONSerialization.data(withJSONObject: headers, options: [.prettyPrinted])
            if let data = headersData {
                headersString = String(data: data, encoding: .utf8)
            }
        }
        if let parameters = parameters {
            let parametersData = try? JSONSerialization.data(withJSONObject: parameters, options: [.prettyPrinted])
            parametersString = String(data: parametersData ?? Data(), encoding: .utf8)
        }
        
        return """
        ------------------------ HSRequest -----------------------
        URL:\(URLString)
        Headers:\(headersString!)
        Parameters:\(parametersString!)
        ----------------------------------------------------------
        
        """
    }
    
}

open class HSDownloadRequest: HSRequest {
    
    /// Specifies whether the download request is resume or not.
    public var isResume: Bool = false
    
    internal var hasResume: Bool = false
    
    /// Specify the destination URL to receive the file. default: "/Library/Caches/HSNetwork/Destination/\(requestID)"
    public var destinationURL: URL?
    
    public var options: Options = [.removePreviousFile, .createIntermediateDirectories]
    
    open override var blackList: [String] {
        return ["isResume", "hasResume"]
    }
        
    public override func cancel() {
        if isResume {
            if let downloadRequest = originalRequest as? DownloadRequest {
                downloadRequest.cancel(producingResumeData: true)
                return
            }
        }
        
        super.cancel()
    }
    
}

open class HSUploadRequest: HSRequest {
    
    public typealias MultipartFormDataClosure = (MultipartFormData) -> Void
    
    override open func loadRequest() {
        super.loadRequest()
        self.method = .post
    }
    
    
    /// uploading the `data`.
    public var data: Data?
    
    /// uploading the `file`.
    public var filePath: String?
    
    /// uploading the `inputStream`.
    public var inputStream: (intputStream: InputStream, length: Int)?
    
    /// uploading the `formData`.
    public var multipartFormData: MultipartFormDataClosure?
    
    public var encodingMemoryThreshold: UInt64 = MultipartFormData.encodingMemoryThreshold
    
}
