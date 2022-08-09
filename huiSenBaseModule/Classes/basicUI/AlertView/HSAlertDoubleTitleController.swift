//
//  HSAlertSingleButtonController.swift
//  huiSenSmart
//
//  Created by jonker.sun on 2022/4/7.
//

import UIKit

public class HSAlertDoubleTitleController: HSAlertViewBaseController {
    // MARK: - Public
    
    /// 创建默认样式的弹窗
    /// - Parameters:
    ///   - title: 标题
    ///   - contentString: 内容
    ///   - actionButtonTitleArray: 点击按钮的文字
    ///   - clickBlock: 点击回调，int对应actionButtonTitleArray的位置
    @discardableResult
    public static func alertDefaultView(title:String?, nextTitle:String?, contentString:String, actionButtonTitleArray:[String]?, clickBlock:((Int, String?)->Void)? = nil) -> HSAlertDoubleTitleController{
        let vc = HSAlertDoubleTitleController.init()
        vc.titleLabel.text = title ?? ""
        vc.titleOtherLabel.text = nextTitle
        vc.clickBlock = clickBlock
        vc.detailLabel.text = contentString
        vc.setUI()
        guard let array = actionButtonTitleArray else {
            vc.nextButton.isHidden = true
        return vc }
        vc.nextButton.setTitle(array.first, for: .normal)
        return vc
    }
    
    public override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        titleLabel.sizeToFit()
        closeButton.sizeToFit()
        detailLabel.sizeToFit()
        titleOtherLabel.sizeToFit()
        
        let size = (detailLabel.text ?? "").as.size(font: UIFont.font(name: .regular, size: 14), maxSize: CGSize(width: view.as.width-36-50, height: CGFloat.greatestFiniteMagnitude), lineMargin: 5)
        let contentHeight = size.height
        backView.frame = CGRect(x: 18, y: view.as.height-18-(125+contentHeight)-UIScreen.as.tabBarSafeHeight, width: view.as.width-36, height: 125+contentHeight)
        titleLabel.frame = CGRect(x: 30, y: 15, width: backView.as.width-60, height: titleLabel.as.height)
        closeButton.frame = CGRect(x: backView.as.width-50, y: titleLabel.as.centerY-50/2, width: 50, height: 50)
        titleOtherLabel.frame = CGRect(x: 25, y: titleLabel.as.bottom+10, width: backView.as.width-50, height: titleOtherLabel.as.height)
        detailLabel.frame = CGRect(x: 25, y: titleOtherLabel.as.bottom+2, width: backView.as.width-50, height: contentHeight)
        nextButton.frame = CGRect(x: 23, y:backView.as.height - 50, width: backView.as.width-46, height: 40)
    }
    // MARK: - Public
    
    // MARK: - Request

    // MARK: - Action
    @objc func nextAction() {
        clickBlock?(0,nil)
        dismiss()
    }
    @objc func closeAction() {
        dismiss()
    }
    
    // MARK: - Private
    private func setUI() {
        
        view.addSubview(backView)
        backView.addSubview(titleLabel)
        backView.addSubview(detailLabel)
        backView.addSubview(titleOtherLabel)
        backView.addSubview(closeButton)
        backView.addSubview(nextButton)
    }

    // MARK: - setter & getter
    public lazy var backView: UIView = {
        var back = UIView.init()
        back.backgroundColor = UIColor.init(HSAppThemeModel.backGroundLight)
        back.as.cornerRadius = 20
        return back
    }()
    public lazy var titleLabel: UILabel = {
        let lab = UILabel.init(title: "设备离线", fontColor: UIColor.init(HSAppThemeModel.wordBlack), fonts: UIFont.font(name: .medium, size: 16), alignment: .center)
        return lab
    }()
    public lazy var titleOtherLabel: UILabel = {
        let lab = UILabel.init(title: "请检查", fontColor: UIColor.init(HSAppThemeModel.wordBlack), fonts: UIFont.font(name: .regular, size: 16), alignment: .left)
        return lab
    }()
    public lazy var detailLabel: UILabel = {
        let lab = UILabel.init(title: "", fontColor: UIColor.init(HSAppThemeModel.wordGayLight), fonts: UIFont.font(name: .regular, size: 14), alignment: .left)
        lab.numberOfLines = 0
        return lab
    }()
    
    public lazy var closeButton: UIButton = {
        var btn = UIButton.init(title: nil, titleColor: UIColor.init(HSAppThemeModel.wordMain), titleFont: UIFont.font(name: .regular, size: 16), imageName: "Room_delegate", backGroudImgName: nil, target: self, action: #selector(closeAction), tintColor: HSAppThemeModel.imageGayLight)
        btn.isHidden = clickEnableClose
        return btn
    }()
    
    public lazy var nextButton: UIButton = {
        var btn = UIButton.init(title: "返回首页", titleColor: UIColor.init(HSAppThemeModel.wordMain), titleFont: UIFont.font(name: .regular, size: 16), imageName: nil, backGroudImgName: nil, target: self, action: #selector(nextAction))
        return btn
    }()
}
// MARK: - Other Delegate
//extension HSDeviceAddGuideController : {
//
//}

