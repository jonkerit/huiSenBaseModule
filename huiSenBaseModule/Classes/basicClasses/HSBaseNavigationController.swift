//
//  HSBaseNavigationController.swift
//  huiSenSmart
//
//  Created by jonkersun on 2021/6/9.
//

import UIKit

class HSBaseNavigationController: UINavigationController {

    /// 设置navbar的灰线是否显示(默认显示)
    var isShowline:Bool = true{
        didSet{
            navigationBar.shadowImage = UIImage.as.image(with: isShowline ? UIColor.init("0xE4E4E4"):.white)
        }
    }
    /// 设置手势代理，设置后可以拦截手势
    var gestureRecognizerDelegate: UIGestureRecognizerDelegate?
    private var popDelegate: Any?
    private var shouldIgnorePushingViewControllers:Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let navBar = UINavigationBar.appearance()
        navBar.titleTextAttributes = [NSAttributedString.Key.font:UIFont.font(name: .medium, size: 16), NSAttributedString.Key.foregroundColor : UIColor.black]
        navBar.isTranslucent = false
        let item = UIBarButtonItem.appearance()
        item.setTitleTextAttributes([NSAttributedString.Key.font:UIFont.font(name: .medium, size: 15), NSAttributedString.Key.foregroundColor : UIColor.black], for: .normal)
        
        popDelegate = interactivePopGestureRecognizer?.delegate
        self.delegate = self
        self.modalPresentationStyle = .none
        self.setNeedsStatusBarAppearanceUpdate()
        if #available(iOS 13.0, *) {
            let apparance = UINavigationBarAppearance()
            apparance.configureWithOpaqueBackground()
            apparance.backgroundColor = .white
            apparance.shadowImage = UIImage.as.image(with: .white)
            navigationBar.standardAppearance = apparance
            navigationBar.scrollEdgeAppearance = navigationBar.standardAppearance
        } else {
            navigationBar.shadowImage = UIImage.as.image(with: .white)
            navigationBar.setBackgroundImage(UIImage.as.image(with: .white), for: .default)
        }
        
        if #available(iOS 15.0, *) {
            UITableView.appearance().sectionHeaderTopPadding = 0
        }
    }
    
    @objc private func backBtnActin(){
        self.popViewController(animated: true)
    }
    
    //重写导航控制器的push方法,在push之前,设置目标控制器的自定义后退按钮 隐藏tabBAr
    override func pushViewController(_ viewController: UIViewController, animated: Bool) {
        //如果覆盖了系统提供的后退按钮,手势返回上一个控制器
        self.interactivePopGestureRecognizer?.delegate = self
        if shouldIgnorePushingViewControllers {
            return
        }
        if self.viewControllers.count>0 {
            viewController.navigationItem.leftBarButtonItem = barButtonItem
            viewController.hidesBottomBarWhenPushed = true
        }
        super.pushViewController(viewController, animated: animated)
        shouldIgnorePushingViewControllers = true
    }

    private lazy var barButtonItem:UIBarButtonItem = {
        let btn = UIButton.init(title: "", titleColor: nil, titleFont: nil, imageName: "white_arrow", backGroudImgName: nil, target: self, action: #selector(backBtnActin))
        btn.imageEdgeInsets = UIEdgeInsets(top: 0, left: -20, bottom: 0, right: 0)
        btn.frame = CGRect(x: 0, y: 0, width: 50, height: 20)
        return UIBarButtonItem.init(customView: btn)
    }()
}

extension HSBaseNavigationController:UINavigationControllerDelegate{
    func navigationController(_ navigationController: UINavigationController, didShow viewController: UIViewController, animated: Bool) {
        if viewController == self.viewControllers[0] {
            self.interactivePopGestureRecognizer?.delegate = popDelegate as? UIGestureRecognizerDelegate
        }else{
            self.interactivePopGestureRecognizer?.delegate = gestureRecognizerDelegate
            gestureRecognizerDelegate = nil
        }
        shouldIgnorePushingViewControllers = false
    }
}

extension HSBaseNavigationController: UIGestureRecognizerDelegate {
    func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        
        return true
    }
}
