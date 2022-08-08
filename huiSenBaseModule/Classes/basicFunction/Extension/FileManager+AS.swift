//
//  FileManager+AS.swift
//  huiSenSmart
//
//  Created by jonkersun on 2021/4/14.
//  Copyright © 2021 Grand. All rights reserved.
//

import Foundation
public extension AriSwift where Base: FileManager {
    /// 沙盒目录路径
    static var homeDirectory: String {
        return NSHomeDirectory()
    }
    
    /// 沙盒temp路径
    static var tempDirectory: String {
        return NSTemporaryDirectory()
    }
    
    /// 沙盒documents路径
    static var documentsDirectory: String {
        return NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0]
    }
    
    /// 沙盒library路径
    static var libraryDirectory: String {
        return NSSearchPathForDirectoriesInDomains(.libraryDirectory, .userDomainMask, true)[0]
    }
    
    /// 沙盒cache路径
    static var cacheDirectory: String {
        return NSSearchPathForDirectoriesInDomains(.cachesDirectory, .userDomainMask, true)[0]
    }
}
