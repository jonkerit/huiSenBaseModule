//
//  UIView+AS.swift
//  huiSenSmart
//
//  Created by jonkersun on 2021/4/28.
//

import UIKit

public extension AriSwift where Base : UIView {    
    /// 获取目标view父控制器
    func superViewVC() -> UIViewController? {
        var vc:UIResponder = base
        while vc.isKind(of: UIViewController.self) != true {
            if vc.next == nil {
                return nil
            } else {
                vc = vc.next!
            }
        }
        return vc as? UIViewController
    }
    
    ///当前view截屏
    func obtainViewSnap() -> UIImage?{
        let renderer = UIGraphicsImageRenderer(bounds: base.bounds)
        return renderer.image { rendererContext in
            base.layer.render(in: rendererContext.cgContext)
        }
    }

    /// 在view上添加手势
    /// - Parameters:
    ///   - target: target目标
    ///   - action: action
    @discardableResult
    func addTarget(target: Any, action: Selector) -> UITapGestureRecognizer{
        let tap = UITapGestureRecognizer.init(target: target, action: action)
        base.isUserInteractionEnabled = true
        base.addGestureRecognizer(tap)
        return tap
    }
    
    /// 移除view上的手势
    /// - Parameters:
    ///   - target: target目标
    ///   - action: action
    func removeTarget(target: Any, action: Selector) {
        let tap = UITapGestureRecognizer.init(target: target, action: action)
        base.removeGestureRecognizer(tap)
    }
}
public extension UIView {
    /// 初始化view - 换肤模式
    /// - Parameter backGColorArr: 背景不同皮肤的颜色的的数组
    convenience init(backgroundColorArray:[String]){
        self.init()
        let order:Int = HSAppThemeManager.nowTheme().rawValue
        backgroundColor = UIColor.init(backgroundColorArray[order])
    }
    
    /// VC的换肤
    func APPThemeChange() {
        let colorArray = [UIColor.white,UIColor.init(HSAppThemeModel.backGroundLight)]
        let order:Int = HSAppThemeManager.nowTheme().rawValue
        self.backgroundColor = colorArray[order]
    }
}
