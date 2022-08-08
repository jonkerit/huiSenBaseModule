//
//  HSSafelyKVOCenter.swift
//  huiSenSmart
//
//  Created by jonkersun on 2021/6/4.
//

import UIKit


public typealias HSKVOCenterObserverBlock = ([NSKeyValueChangeKey : Any]?) -> Void

class HSSafelyKVOCenter: NSObject {
    lazy private var observerArray = [HSSafelyKVOBrigde]()
    
    func addSafelyObserverForObject(target:NSObject, keyPath:String, options: NSKeyValueObservingOptions,changeAction:@escaping HSKVOCenterObserverBlock) {
        let safelyKVOCenter = HSSafelyKVOBrigde(obj: target, keyPath: keyPath, observerBlock: changeAction)
        observerArray.append(safelyKVOCenter)
        target.addObserver(safelyKVOCenter, forKeyPath: keyPath, options: options, context: nil)
    }
    
    deinit {
        for temp in observerArray {
            temp.obj.removeObserver(temp, forKeyPath: temp.keyPath ?? "", context: nil)
        }
   }
    
}

fileprivate class HSSafelyKVOBrigde: NSObject {

    var obj:NSObject!
    var keyPath:String!
    var observerBlock:HSKVOCenterObserverBlock!

    init(obj:NSObject,keyPath:String,observerBlock:@escaping HSKVOCenterObserverBlock) {
        self.obj = obj
        self.keyPath = keyPath
        self.observerBlock = observerBlock
    }
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        self.observerBlock!(change)
    }
}
