//
//  HSLogPrintTool.swift
//  huiSenSmart
//
//  Created by jonkersun on 2021/6/3.
//

import Foundation

public func HSDebugLog<T> (_ message: T,
              file: String = #file,
              method: String = #function,
              line: Int = #line) {
    #if DEBUG
        print("\((file as NSString).lastPathComponent)[\(line)],\(method):\(message)")
    #endif
    
}
