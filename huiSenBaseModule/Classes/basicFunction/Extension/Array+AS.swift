//
//  Array+AS.swift
//  huiSenSmart
//
//  Created by jonker.sun on 2022/3/30.
//

import Foundation
extension Array: AriSwiftCompatible {}
public extension AriSwift where Base == Array<Any> {
    
    /// 交换集合的两个位置的元素
   static func changeArray<T>(_ nums:inout[T],_ a:Int,_ b:Int) {
        let count = nums.count
        if a == b || a < 0 || a > count - 1 || b < 0 || b > count - 1 {
            return
        }
        (nums[a],nums[b]) = (nums[b],nums[a])
    }
}

