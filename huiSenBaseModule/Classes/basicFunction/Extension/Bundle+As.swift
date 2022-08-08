//
//  Bundle+As.swift
//  huiSenSmart
//
//  Created by jonker.sun on 2022/1/26.
//

import Foundation
public extension AriSwift where Base: Bundle {
    static func bundlePath(swiftClass:  Swift.AnyClass, resource:String?, ofType: String?) -> Bundle{
        guard let podBundle = Bundle(for: swiftClass.self).path(forResource: resource, ofType: ofType) else {
            return Bundle(for: swiftClass.self)
        }
        return Bundle(path: podBundle)!
    }
}
