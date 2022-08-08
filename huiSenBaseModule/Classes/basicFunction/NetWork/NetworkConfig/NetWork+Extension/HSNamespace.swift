//  huiSenSmart
//
//  Created by jonkersun on 2021/5/19.


public struct HSNamespace<Base> {
    /// Base object to extend.
    public let base: Base
    
    /// Creates extensions with base object.
    ///
    /// - parameter base: Base object.
    public init(_ base: Base) {
        self.base = base
    }
}

/// A type that has reactive extensions.
public protocol HSNamespaceProtocol {
    /// Extended type
    associatedtype HSCompatibleType
    
    /// Reactive extensions.
    static var sl: HSNamespace<HSCompatibleType>.Type { get set }
    
    /// Reactive extensions.
    var sl: HSNamespace<HSCompatibleType> { get set }
}

extension HSNamespaceProtocol {
    /// Reactive extensions.
    public static var sl: HSNamespace<Self>.Type {
        get {
            return HSNamespace<Self>.self
        }
        set {
            // this enables using Reactive to "mutate" base type
        }
    }
    
    /// Reactive extensions.
    public var sl: HSNamespace<Self> {
        get {
            return HSNamespace(self)
        }
        set {
            // this enables using Reactive to "mutate" base object
        }
    }
}

import class Foundation.NSObject

extension NSObject: HSNamespaceProtocol { }
