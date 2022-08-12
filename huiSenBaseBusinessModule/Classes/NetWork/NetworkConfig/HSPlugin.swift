//  huiSenSmart
//
//  Created by jonkersun on 2021/5/19.


public protocol HSPlugin {
    
    
    /// Modify the HSRequest before sending
    ///
    /// - Parameter request: HSRequest
    func willSend(request: HSRequest)
    
    
    /// Modify the HSResponse after response
    ///
    /// - Parameter response: HSResponse
    func didReceive(response: HSResponse)
    
}

public extension HSPlugin {
    
    func willSend(request: HSRequest) {}
    
    func didReceive(response: HSResponse) {}
    
}
