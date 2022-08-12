//  huiSenSmart
//
//  Created by jonkersun on 2021/5/19.


import Foundation

public protocol HSTarget {
    
    /// The target's baseURLString.
    var baseURLString: String { get }
    
    var IPURLString: String? { get set }
    
    /// The target's HTTPMethod.
    var method: HTTPMethod { get }
    
    /// The target's HTTPHeaders.
    var headers: HTTPHeaders? { get }
    
    /// The target's ParameterEncoding.
    var parameterEncoding: ParameterEncoding { get }
 
    /// The target's URLSessionConfiguration.
    var configuration: URLSessionConfiguration { get }
    
    var allHostsMustBeEvaluated: Bool { get }
    
    /// The target's serverTrustPolicies
    var serverEvaluators: [String : ServerTrustEvaluating]? { get }
    
    /// The target's clentTrustPolicy
    var clientTrustPolicy: (secPKCS12Path: String, password: String)? { get }
    
    /// The target's ResponseQueue
    var responseQueue: DispatchQueue? { get }
    
    /// The target's Plugins
    var plugins: [HSPlugin]? { get }
    
    /// The target's Reachability
    var reachabilityListener: ReachabilityListener? { get }
    
    /// The target's Host.
    var host: String { get }
    
    /// The target's Response Status
    var status: (codeKey: String, successCode: Int, messageKey: String?, dataKeyPath: String?)? { get }
    
    /// The target's Response JSONDecoder
    var decoder: JSONDecoder { get }
    
    /// The target's debugPrint Switch, default is on.
    var enableLog: Bool { get }
    
}

public extension HSTarget {
    
    var baseURLString: String { return "" }
    
    var IPURLString: String? {
        get {
            return nil
        }
        set {
            
        }
    }
    
    var method: HTTPMethod { return .get }
    
    var headers: HTTPHeaders? {
        get {
            return nil
        }
    }
    
    var parameterEncoding: ParameterEncoding { return URLEncoding.default }
    
    var configuration: URLSessionConfiguration { return URLSessionConfiguration.af.default }
    
    var allHostsMustBeEvaluated: Bool { return true }
    
    /**
     how to use?
     First get the Certificates of Host:
     openssl s_client -connect test.example.com:443 </dev/null 2>/dev/null | openssl x509 -outform DER > example.cer
     
     then put the Certificates of Host in MainBundle.
     
     Example:
     ---------------------------------------------------------
     var serverEvaluators: [String : ServerTrustEvaluating]? {
     #if DEBUG
     let validateHost = false
     #else
     let validateHost = true
     #endif
     
     let evaluators: [String: ServerTrustEvaluating] = [
     host: PinnedCertificatesTrustEvaluator(validateHost: validateHost)
     ]
     
     return evaluators
     }
     ---------------------------------------------------------
     
     if Debug, advice set
     validateHost: false
     */
    var serverEvaluators: [String : ServerTrustEvaluating]? { return nil }
    
    /**
     how to use?
     First put the p12 of client in MainBundle.
     
     var clientTrustPolicy: (secPKCS12Path: String, password: String)? {
        return (secPKCS12Path: Bundle.main.path(forResource: "secPKCS12Name", ofType: "p12") ?? "", password: "password")
     }
     */
    var clientTrustPolicy: (secPKCS12Path: String, password: String)? { return nil }
        
    var responseQueue: DispatchQueue? { return nil }
    
    var plugins: [HSPlugin]? { return nil }

    var reachabilityListener: ReachabilityListener? { return nil }
    
    var host: String {
        if let URL = URL(string: baseURLString), let host = URL.host {
            return host
        }
        return ""
    }
    
    var status: (codeKey: String, successCode: Int, messageKey: String?, dataKeyPath: String?)? { return nil }

    var decoder: JSONDecoder {
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .secondsSince1970
        return decoder
    }
    
    var enableLog: Bool { return true }
}
