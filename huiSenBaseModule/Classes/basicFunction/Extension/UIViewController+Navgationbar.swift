//
//  UIViewController+Navgationbar.swift
//  huiSenSmart
//
//  Created by jonkersun on 2021/4/28.
//

import UIKit
public extension AriSwift where Base : UIViewController {
    @discardableResult
    /// 添加导航栏 --- 默认灰色返回键 ( 只包含返回尖头和标题，要添加其他控件，可在返回的View上添加)
    public func addNormalNavigationBar(_ titleString:String) -> HSNavigationBarView {
        // 设置系统的nav隐藏
        base.navigationController?.setNavigationBarHidden(true, animated: false)
       closeAdjustsScrollViewInsets()
        return addNormalNavigationBar(titleString) {
            [weak base] in
            guard let `self` = base else {
                return
            }
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    @discardableResult
    public func addNormalNavigationBar(_ titleString:String, _ popBackBlock: @escaping ()->Void) -> HSNavigationBarView {
        // 设置系统的nav隐藏
        base.navigationController?.setNavigationBarHidden(true, animated: false)
        closeAdjustsScrollViewInsets()
        let navigationBar = HSNavigationBarView(frame: CGRect(x: 0, y: 0, width: UIScreen.as.screenWidth, height: UIScreen.as.navBarHeight))
        navigationBar.setupNavigationBar(UIImage.as.imageNamed("Navbar_back").as.imageWithTintColor(HSAppThemeModel.imageBlack), titleString: titleString)
        base.view.addSubview(navigationBar)
        navigationBar.popActionBlock = {
            popBackBlock()
        }
        return navigationBar
    }
    
    
    /// 添加导航栏 --- 默认灰色返回键 ( 只包含返回尖头和标题，要添加其他控件，可在返回的View上添加)
    /// - Parameters:
    ///   - backImage: 给定图片
    ///   - titleString: 标题
    /// - Returns: navbar
    @discardableResult
    
    public func addNormalNavigationBar(_ backImage:UIImage?, titleString:String) -> HSNavigationBarView {
        closeAdjustsScrollViewInsets()
        let navigationBar = HSNavigationBarView(frame: CGRect(x: 0, y: 0, width: UIScreen.as.screenWidth, height: UIScreen.as.navBarHeight))
        navigationBar.setupNavigationBar(backImage ?? UIImage.as.imageNamed("Navbar_back"), titleString: titleString)
        base.view.addSubview(navigationBar)
        navigationBar.popActionBlock = {[weak base] in
            guard let `self` = base else {
                return
            }
            self.navigationController?.popViewController(animated: true)
        }
        return navigationBar
    }
    
    /// 关闭ScrollView自适应
    func closeAdjustsScrollViewInsets(){
        base.view.backgroundColor = UIColor.white
        if #available(iOS 11.0, *) {
        } else {
            base.automaticallyAdjustsScrollViewInsets = false
        }
    }

    /// 关闭ScrollView自适应
    func closeAdjustsScrollViewInsets(scrollView:UIScrollView?){
        if #available(iOS 11.0, *) {
            scrollView?.contentInsetAdjustmentBehavior = .never
        } else {
            base.automaticallyAdjustsScrollViewInsets = false
        }
    }
    
}

//MARK: - Custom NavigationBar
public class HSNavigationBarView: UIView {
    public var popActionBlock:(()->Void)?
    public var titleView: UILabel!
    public var line = UIView()
    public var backButton: UIButton!
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = UIColor.white
        backButton = UIButton.init(title: nil, titleColor: nil, titleFont: nil, imageName: "Navbar_back", backGroudImgName: nil, target: self, action:  #selector(popBack),tintColor: HSAppThemeModel.wordBlack)
        backButton.frame = CGRect(x: 0, y: self.as.height-44, width: 44, height: 44)
        addSubview(backButton)
        
        titleView = UILabel.init(title: " ", fontColor: UIColor.init(HSAppThemeModel.wordBlack), fonts: UIFont.init(name: "PingFangSC-Medium", size: 18), alignment: .center)
        titleView.frame = CGRect(x: 60, y: self.as.height-44, width: UIScreen.as.screenWidth-120, height: 44)
        addSubview(titleView)

        line.backgroundColor = UIColor.init(HSAppThemeModel.lineGay)
        line.frame = CGRect(x: 0, y: self.as.height-1, width: UIScreen.as.screenWidth, height: 1)
//        addSubview(line)
    }
    
    /// 设置右边bar:从左到右排列
    /// - Parameters:
    ///   - customViewArr: 自定义View的数组
    ///   - spaceWidth: view的间隙
    public func createRightViewBar(_ customViewArr:[UIView], _ spaceWidth:CGFloat = 10) {
        var tempSpace:CGFloat = 0.0
        for (i,customView) in customViewArr.enumerated() {
            addSubview(customView)
            customView.sizeToFit()
            tempSpace = tempSpace + customView.as.width
            customView.frame = CGRect(x: UIScreen.as.screenWidth-tempSpace-spaceWidth*CGFloat(i)-15, y: UIScreen.as.statusBarHeight+(44 - customView.as.height)/2, width: customView.as.width, height: customView.as.height)
        }
    }
    public required convenience init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    //MARK: - set
    public func setupNavigationBar(_ backImage:UIImage, titleString:String) {
        backButton.setImage(backImage, for: UIControl.State.normal)
        titleView.text = titleString
    }
    //MARK: - actions
    @objc private func popBack(){
        if let block = self.popActionBlock {
            block()
        }
    }
}
