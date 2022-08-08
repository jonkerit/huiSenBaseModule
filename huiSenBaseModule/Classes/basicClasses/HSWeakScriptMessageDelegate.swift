//
//  HSWeakScriptMessageDelegate.swift
//  huiSenSmart
//
//  Created by jonker.sun on 2022/1/25.
//

import UIKit
import WebKit

class HSWeakScriptMessageDelegate: NSObject,WKScriptMessageHandler {
    weak var target:WKScriptMessageHandler?
    
    init(scriptTarget:WKScriptMessageHandler) {
        super.init()
        self.target = scriptTarget
    }
    
    func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
        if self.target != nil && self.target!.responds(to: #selector(userContentController(_:didReceive:))) {
            self.target?.userContentController(userContentController, didReceive: message)
        }
    }
    
}

