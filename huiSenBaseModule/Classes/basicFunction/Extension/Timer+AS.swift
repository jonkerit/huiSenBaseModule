//
//  Timer+AS.swift
//  huiSenSmart
//
//  Created by jonkersun on 2021/6/9.
//

import Foundation
import Foundation
import UIKit

public extension AriSwift where Base:Timer {

    /// 延迟执行timer
    /// - Parameters:
    ///   - delayTime: 延迟时间
    ///   - qosClass: 线程
    ///   - closure: 回调
    static func timerDelay(by delayTime: TimeInterval, qosClass: DispatchQoS.QoSClass? = nil,
        _ closure: @escaping () -> Void) {
        let dispatchQueue = qosClass != nil ? DispatchQueue.global(qos: qosClass!) : .main
        dispatchQueue.asyncAfter(deadline: DispatchTime.now() + delayTime, execute: closure)
    }
    
    /// GCD定时器倒计时
    ///   - timeInterval: 循环间隔时间
    ///   - repeatCount: 重复次数-小于等于0为无限次数
    ///   - handler: 循环事件, 闭包参数： 1. timer， 2. 剩余执行次数（小于0为无限次数）
    ///   - timerOutBlock:结束回调
    @discardableResult
    static func timerCreateByDispatch(timeInterval: Double, repeatCount:Int = -1, handler:@escaping (DispatchSourceTimer?, Int) -> Void) -> DispatchSourceTimer{
        let timer = DispatchSource.makeTimerSource(flags: [], queue: DispatchQueue.main)
        var count = repeatCount<=0 ? -1:repeatCount
        timer.schedule(wallDeadline: .now(), repeating: timeInterval)
        timer.setEventHandler(handler: {
            if repeatCount > 0{
                count -= 1
            }
            DispatchQueue.main.async {
                handler(timer, count)
            }
            if count == 0 {
                timer.cancel()
            }
        })
        timer.resume()
        return timer
    }
}
