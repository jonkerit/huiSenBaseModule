//
//  HSAlertViewMananger.swift
//  huiSenSmart
//
//  Created by jonker.sun on 2022/4/27.
//

import UIKit

public class HSAlertViewMananger: NSObject {
    public static var shared = HSAlertViewMananger()
    public var cacheAlterViewArray = [HSAlertViewBaseController]()
    // MARK: - LifeCycle

    // MARK: - Public
    public func saveAlertView(_ alterView: HSAlertViewBaseController) {
        cacheAlterViewArray.append(alterView)
    }
    
    public func delegateAlertView(_ alterView: HSAlertViewBaseController) {
        if cacheAlterViewArray.contains(alterView) {
            cacheAlterViewArray.remove(at: cacheAlterViewArray.firstIndex(of: alterView)!)
        }
    }
    
    // MARK: - Request

    // MARK: - Action

    // MARK: - Private

    // MARK: - setter & getter
    
}
// MARK: - Other Delegate
//extension HSAlertViewMananger : {
//
//}
