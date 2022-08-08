//
//  AriSwift.swift
//  huiSenSmart
//
//  Created by jonkersun on 2021/4/14.
//  Copyright © 2021 Grand. All rights reserved.
//

import Foundation
import UIKit

/**
 这里给所有需要拓展的对象或者类加一个'as'以区分它们自己的默认方法
 */
public struct AriSwift<Base> {
    public var base: Base
    public init(_ base: Base) {self.base = base}
}

public protocol AriSwiftCompatible {
    associatedtype CompatibleType
    static var `as`: AriSwift<CompatibleType>.Type { get set }
    var `as`: AriSwift<CompatibleType> { get set }
}

public extension AriSwiftCompatible {
    static var `as`: AriSwift<Self>.Type {
        get {return AriSwift<Self>.self}
        set {}
    }
    var `as`: AriSwift<Self> {
        get {return AriSwift(self)}
        set {}
    }
}
extension NSObject: AriSwiftCompatible {}
