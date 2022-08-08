//
//  HSSheetViewController.swift
//  huiSenSmart
//
//  Created by jonker.sun on 2022/1/18.
//

import UIKit
import SwiftUI

//typealias HSAlerttCostomContentViewBlock =

class HSSheetViewController: HSAlertViewBaseController {
    /// 自定义view
    var customViewBlock:((_ alertViewController:HSSheetViewController, _ maxWidth:CGFloat, _ maxHeight:CGFloat)->UIView)?
    
    private var customeView:UIView?
    // MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        resetContentViewSize()

        createCustomView()
    }
    // MARK: - Public
    
    /// 创建默认样式的弹窗
    /// - Parameters:
    ///   - title: 标题
    ///   - contentString: 内容
    ///   - actionButtonTitleArray: 点击按钮的文字
    ///   - clickBlock: 点击回调，int对应actionButtonTitleArray的位置
    @discardableResult
    static func sheetDefaultView(title:String, contentString:String?, actionButtonTitleArray:[String]?, clickBlock:((Int, String?)->Void)? = nil) -> HSSheetViewController{
        let vc = HSSheetViewController.init()
        vc.alertTitle.text = title
        vc.alertTextField.text = contentString
        vc.buttonArray.removeAll()
        vc.lineArray.removeAll()
        vc.clickBlock = clickBlock
        
        let tempArray = actionButtonTitleArray ?? [String]()

        for (i,title) in tempArray.enumerated() {
            let btn = UIButton.init(title: title, titleColor: .black, titleFont: UIFont.font(name: .regular, size: 14), imageName: nil, backGroudImgName: nil, target: vc, action: #selector(alertAction(_:)))
            btn.tag = i+100
            vc.buttonArray.append(btn)
            
            let line = UIView()
            line.backgroundColor = UIColor.init("666666")
            vc.lineArray.append(line)
            if tempArray.count-1 == i {
                vc.contentView.addSubview(btn)
            }else{
                vc.contentView.addSubview(line)
                vc.contentView.addSubview(btn)
            }
        }
        vc.setUI()
        return vc
    }
    // MARK: - Request
    
    // MARK: - Action
    @objc public  func alertAction(_ btn:UIButton){
       clickBlock?(btn.tag-100,nil)
       dismiss()
    }
    // MARK: - Private
    // UI
    private func setUI() {
        contentView.addSubview(alertTitle)
        contentView.addSubview(alertTextField)
    }
    
    // 布局
    private func resetContentViewSize(){
        alertTextField.sizeToFit()
        contentView.frame = CGRect(x: 0, y: 0, width: view.as.width-18*2, height: 0)

        let titleSize = alertTitle.text!.as.size(font: UIFont.font(name: .regular, size: 14), maxSize: contentView.as.size, lineMargin: 6)
        let textSize = (alertTextField.text?.isEmpty ?? true) ?
        CGSize.zero: alertTextField.text!.as.size(font: UIFont.font(name: .regular, size: 14), maxSize: contentView.as.size, lineMargin: 6)

        alertTitle.frame = CGRect(x: 30, y: 20, width: contentView.as.width-30*2, height: titleSize.height)
        alertTextField.frame = CGRect(x: 20, y: alertTitle.as.bottom+10, width: contentView.as.width-20*2, height: textSize.height)
        
        var tempF:CGFloat = (textSize.height == 0 ? alertTitle.as.bottom:alertTextField.as.bottom)+20
        for (i,btn) in buttonArray.enumerated() {
            
            if i<buttonArray.count-1 {
                lineArray[i].frame = CGRect(x: 0, y: tempF, width: contentView.as.width, height: 0.7)
                btn.frame = CGRect(x: 0, y: lineArray[i].as.bottom, width: contentView.as.width, height: 40)
                tempF = btn.as.bottom
            }
        }
        
        contentView.as.height = tempF

//        actionsView.frame = CGRect(x: contentView.as.x, y: contentView.as.bottom+10, width: contentView.as.width, height: 40)
//        buttonArray.last?.frame = actionsView.bounds
//        tapView.as.height = actionsView.as.bottom+10+UIScreen.as.tabBarSafeHeight
//        tapView.as.y = view.as.height
//        tapView.as.centerX = view.as.centerX
//        UIView.animate(withDuration: 0.3) {
//            self.tapView.as.y = self.view.as.height-self.tapView.as.height
//        }


    }
    
    private func createCustomView() {
        customeView = customViewBlock?(self, view.as.width-40*2, CGFloat.greatestFiniteMagnitude)
        guard customeView != nil else {
            return
        }
        contentView.addSubview(customeView!)
        contentView.as.size = customeView!.as.size
        contentView.as.centerX = view.as.centerX
        contentView.as.centerY = view.as.centerY-60
        
        contentView.as.origin = CGPoint.zero
        customeView!.as.origin = CGPoint.zero
    }
    
    // MARK: - setter & getter
    /// 标题
    lazy var alertTitle: UILabel = {
        let label = UILabel.init(title: "标题", fontColor: .black, fonts: UIFont.font(name: .regular, size: 14), alignment: .center)
        label.sizeToFit()
        return label
    }()
    
    /// 内容
    lazy var alertTextField: UITextField = {
        let text = UITextField.init(textColors: .black, textFont: UIFont.font(name: .regular, size: 14), placeholders: "", placeholdersFont: nil, placeholdersColor: .gray, cornerRadius: 0, layColor: .white, boardStyle: UITextField.BorderStyle.none, keyBoardStyles: .default)
        text.isUserInteractionEnabled = false
        return text
    }()
    
    /// 按钮数组
    lazy var buttonArray = [UIButton]()
    private lazy var lineArray = [UIView]()

}
// MARK: - Other Delegate
//extension HSAlertViewController : {
//
//}
