//
//  HSNetwworkPlugin.swift
//  huiSenSmart
//
//  Created by jonker.sun on 2022/2/25.
//

import UIKit

class HSNetwworkPlugin: HSPlugin {
    
    func willSend(request: HSRequest) {
        debugPrint("willSend request: \(request.URLString)")
        
        //Do whatever you want before request.
    }
    
    func didReceive(response: HSResponse) {
        debugPrint("didReceive response: \(response.request?.URLString ?? "")")

        //Do whatever you want after response.
    }
    
}
