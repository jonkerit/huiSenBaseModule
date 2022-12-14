//
//  HSAlertViewBaseController.swift
//  huiSenSmart
//
//  Created by jonker.sun on 2022/1/18.
//

import UIKit
 
public typealias clickBackgroundViewEnableClose = () -> Bool
public typealias clickBackgroundViewDidClose = () -> Void
/// 弹窗的相对屏幕底部安全区的位置
public var HSAlertViewBaseY: CGFloat = 18.0

open class HSAlertViewBaseController: UIViewController {
    /// 点击背景是否能关闭弹窗
    public var clickEnableClose :Bool = true
    /// 关闭弹窗后的回调
    public var clickDidClose: clickBackgroundViewDidClose?
    /// 弹窗的圆角
    public var cornerRadius: CGFloat = 20.0
    /// action的点击回调
    public var clickBlock: ((Int, String?)->Void)?
    
    // MARK: - LifeCycle
    open override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.setNavigationBarHidden(true, animated: true)
        view.backgroundColor = UIColor.init("000000", alpha: 0.2)
        let tap = view.as.addTarget(target: self, action: #selector(tapBackgroundView(_:)))
        tap.delegate = self
        setUI()
    }

    // MARK: - Public

    /// 展示
    /// - Parameter isForce: 是否强制展示（不管是否有弹窗都再次弹一个，否则就是有弹窗压栈一个一个弹）
    public func show(_ isForce: Bool? = false) {
        HSAlertViewMananger.shared.saveAlertView(self)
        if HSAlertViewMananger.shared.cacheAlterViewArray.count <= 1 || isForce! {
            alterView(self)
        }
    }
    /// 取消弹框
    public func dismiss() {
        view.endEditing(true)
        HSAlertViewMananger.shared.delegateAlertView(self)
        dismiss(animated: false) {[weak self] in
            guard let strongSelf = self else { return }
            if strongSelf.clickDidClose != nil {
                strongSelf.clickDidClose!()
            }
            // 如果还有未弹出的弹窗、且当前没有弹出框 继续弹出
            if HSAlertViewMananger.shared.cacheAlterViewArray.count > 0 && UIApplication.as.lastPresentedViewController != nil && !(UIApplication.as.lastPresentedViewController is HSAlertViewBaseController)  {
                Timer.as.timerDelay(by: 0.25, qosClass: nil) {
                    strongSelf.alterView(HSAlertViewMananger.shared.cacheAlterViewArray.first!)
                }
            }
        }
    }
    // MARK: - Request

    // MARK: - Action
    @objc func tapBackgroundView(_ ges:UIGestureRecognizer) {
        if clickEnableClose {
            dismiss()
        }
    }
    // MARK: - Private
    private func setUI() {
        view.addSubview(contentView)
    }
    
    private func alterView(_ vc: HSAlertViewBaseController) {
        let nav = vc
        nav.modalPresentationStyle = .custom
        nav.view.backgroundColor = UIApplication.as.lastPresentedViewController != nil && (UIApplication.as.lastPresentedViewController is HSAlertViewBaseController) ? UIColor.clear:UIColor.init("000000", alpha: 0.2)
        UIApplication.as.lastPresentedViewController?.present(nav, animated: false, completion: nil)
    }
    
    // MARK: - setter & getter
    public lazy var contentView: UIView = {
        var view = UIView()
        view.APPThemeChange()
        view.as.cornerRadius = cornerRadius
        return view
    }()
}
// MARK: - Other Delegate
extension HSAlertViewBaseController : UIGestureRecognizerDelegate{
    public func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        // 只有点击到vc的view上才生效gestureRecognizer手势
        return gestureRecognizer.view == touch.view
    }
}
