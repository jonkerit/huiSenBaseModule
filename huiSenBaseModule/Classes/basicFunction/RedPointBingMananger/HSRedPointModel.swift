//
//  HSRedPointModel.swift
//  huiSenSmart
//
//  Created by jonker.sun on 2022/5/10.
//

import UIKit

public class HSRedPointModel: NSObject {
    /// 父节点的key的数组
    public var superKeyArray: [String] = []
    /// 子节点的key的数组
    public var childKeyArray: [String] = []
    /// 本节点的key
    public var selfKey: String = ""
    /// 本节点的数目
    public var redPointNumber: Int = 0
    /// 本节点是否显示数目
//    var isShowNumber: Bool = false
    
}
// MARK: - Other Delegate
//extension HSRedPointModel : {
//
//}
