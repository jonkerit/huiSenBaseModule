//
//  HSScanQrViewProtocol.swift
//  huiSenSmart
//
//  Created by jonker.sun on 2022/1/20.
//

import UIKit

protocol HSScanQrViewProtocol:NSObject {
    func scanQrResultData(data:AnyObject)
}


struct HSScanQrstaticNumber {
    static let timerAnimationDuration = 0.05
    static let scanBorderOutsideViewAlpha = 0.6
    static let animationLineH = 12.0

    
    
}
