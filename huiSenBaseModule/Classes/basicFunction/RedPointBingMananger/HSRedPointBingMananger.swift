//
//  HSRedPointBingMananger.swift
//  huiSenSmart
//
//  Created by jonker.sun on 2022/5/10.
//

import UIKit

public class HSRedPointBingMananger: NSObject {
    public static var standard = HSRedPointBingMananger()
    public var redPiontModelArray: [HSRedPointModel] = [HSRedPointModel]()
    // MARK: - LifeCycle
    override init() {
        super.init()
        bingAllRedpointKeys()
        initAllRedpointNumber()
    }
    // MARK: - Public
    /// 给节点设置总的数字
    public func giveKeyVaule(key: String, vaule: Int) {
        guard let tempModel = getModel(key) else {
            HSDebugLog("注意：没有\(key)这个key的model")
            return }
        tempModel.redPointNumber = vaule
        NotificationCenter.default.post(name: HSBaseNotificationName.redPointChange, object: nil, userInfo: ["redPointModel":tempModel])
        if tempModel.superKeyArray.count > 0 {
            getSuperModelRedPointNumber(tempModel)
        }
    }
    
    // 获取某个key对应的红点数量
    public func getAllRedPointNumber(_ key: String) -> Int {
        guard let tempModel = getModel(key) else {
            HSDebugLog("注意：没有\(key)这个key的model")
            return 0}
        return tempModel.redPointNumber
    }
    
    // 根据key获取其红点model
    public func getModel(_ key: String) -> HSRedPointModel? {
        var tempModel: HSRedPointModel?
        for model in redPiontModelArray {
            if model.selfKey == key {
                tempModel = model
                break
            }
        }
        guard let tempModel = tempModel else {
            HSDebugLog("注意：没有\(key)这个key")
            return nil }
        return tempModel
    }
    
    /// 双向绑定节点
    public func bingKeyEachother(oneKey: String, twoKey: String) {
        bingKey(childKey: oneKey, superKey: twoKey)
        bingKey(childKey: twoKey, superKey: oneKey)
    }
    
    /// 双向绑定节点
    public func unBingKeyEachother(oneKey: String, twoKey: String) {
        unBingKey(childKey: oneKey, superKey: twoKey)
        unBingKey(childKey: twoKey, superKey: oneKey)
    }
    
    /// 绑定节点关系
    
    /// - Parameters:
    ///   - childKey: 作为子节点
    ///   - superKey: 作为父节点
    public func bingKey(childKey: String, superKey: String) {
        var childModel:HSRedPointModel?
        var superModel:HSRedPointModel?

        if redPiontModelArray.count == 0 {
            childModel = HSRedPointModel()
            childModel!.selfKey = childKey
            childModel!.superKeyArray = [superKey]
            
            superModel = HSRedPointModel()
            superModel!.selfKey = superKey
            superModel!.childKeyArray = [childKey]
            redPiontModelArray.append(childModel!)
            redPiontModelArray.append(superModel!)

        }else{
            for (i, model) in redPiontModelArray.enumerated() {
                if model.selfKey == childKey {
                    childModel = model
                }
                if model.selfKey == superKey {
                    superModel = model
                }
                if i == redPiontModelArray.count-1 {
                    if childModel == nil {
                        childModel = HSRedPointModel()
                        childModel!.selfKey = childKey
                        childModel!.superKeyArray = [superKey]
                        redPiontModelArray.append(childModel!)
                    } else {
                        var tempArray = childModel?.superKeyArray ?? [String]()
                        if !tempArray.contains(superKey) {
                            tempArray.append(superKey)
                            childModel!.superKeyArray = tempArray
                        }
                    }
                    
                    if superModel == nil {
                        superModel = HSRedPointModel()
                        superModel!.selfKey = superKey
                        superModel!.childKeyArray = [childKey]
                        redPiontModelArray.append(superModel!)
                    } else {
                        var tempArray = superModel?.childKeyArray ?? [String]()
                        if !tempArray.contains(childKey) {
                            tempArray.append(childKey)
                            superModel!.childKeyArray = tempArray
                        }
                    }
                }
            }
        }
    }
    
    /// 解绑节点关系
    
    /// - Parameters:
    ///   - childKey: 作为子节点
    ///   - superKey: 作为父节点
    public func unBingKey(childKey: String, superKey: String) {
        var childModel:HSRedPointModel?
        var superModel:HSRedPointModel?

        if redPiontModelArray.count > 0 {
           for (i, model) in redPiontModelArray.enumerated() {
                if model.selfKey == childKey {
                    childModel = model
                }
                if model.selfKey == superKey {
                    superModel = model
                }
                if i == redPiontModelArray.count-1 {
                    if childModel != nil {
                        var tempArray = childModel?.superKeyArray ?? [String]()
                        if tempArray.contains(superKey) {
                            guard let index = tempArray.firstIndex(of: superKey) else {
                                return
                            }
                            tempArray.remove(at: index)
                            childModel!.superKeyArray = tempArray
                        }
                    }
                    
                    if superModel != nil {
                        var tempArray = superModel?.childKeyArray ?? [String]()
                        if tempArray.contains(childKey) {
                            guard let index = tempArray.firstIndex(of: superKey) else {
                                return
                            }
                            tempArray.remove(at: index)
                            superModel!.childKeyArray = tempArray
                        }
                    }
                }
            }
        }
    }

    // MARK: - Request

    // MARK: - Action

    // MARK: - Private
    // 初始化绑定关系,需要提前加入
    private func bingAllRedpointKeys() {
        // 首页消息小红点关系绑定
        bingKey(childKey: HSRedPointKeyType.noticeCenterDevice, superKey: HSRedPointKeyType.homePageNotice)
        bingKey(childKey: HSRedPointKeyType.noticeCenterSystem, superKey: HSRedPointKeyType.homePageNotice)
        
    }
    
    // 初始化小红点数据
    private func initAllRedpointNumber() {
        
    }
    
    // 递归计算其父节点数量
    private func getSuperModelRedPointNumber(_ tempModel: HSRedPointModel) {
        for superKey in tempModel.superKeyArray {
            guard let tempModel = getModel(superKey) else {
                HSDebugLog("注意：没有\(superKey)这个key的model")
                return }

            var tempVaule = 0
            for childKey in tempModel.childKeyArray {
                guard let childModel = getModel(childKey) else {
                    HSDebugLog("注意：没有\(childKey)这个key的model")
                    return }
                tempVaule += childModel.redPointNumber
            }
            tempModel.redPointNumber = tempVaule
            NotificationCenter.default.post(name: HSBaseNotificationName.redPointChange, object: tempModel.selfKey, userInfo: ["redPointModel":tempModel])
            if tempModel.superKeyArray.count > 0 {
                getSuperModelRedPointNumber(tempModel)
            }
        }
    }
    // MARK: - setter & getter
}
// MARK: - Other Delegate
//extension HSRedPointBingMananger : {
//
//}
