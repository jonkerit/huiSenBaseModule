//
//  HSWebAlterController.swift
//  huiSenSmart
//
//  Created by jonker.sun on 2022/1/18.
//

import UIKit

//typealias HSAlerttCostomContentViewBlock =

class HSWebAlterController: HSAlertViewBaseController {
    /// 自定义view
    var customViewBlock:((_ alertViewController:HSWebAlterController, _ maxWidth:CGFloat, _ maxHeight:CGFloat)->UIView)?
    
    private var customeView:UIView?
    private var isTextfield:Bool = false
    // MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        registerNotification()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        createCustomView()
    }
    // MARK: - Public
    
    /// 创建默认样式的弹窗
    /// - Parameters:
    ///   - title: 标题
    ///   - otherTitle: 副标题
    ///   - contentString: 内容
    ///   - actionButtonTitleArray: 点击按钮的文字
    ///   - clickBlock: 点击回调，int对应actionButtonTitleArray的位置
    @discardableResult
    static func alertDefaultView(title:String? = nil, otherTitle: String? = nil, contentString:String, actionButtonTitleArray:[String]?, clickBlock:((Int, String?)->Void)? = nil) -> HSWebAlterController{
        let vc = HSWebAlterController.init()
        vc.alertTitle.text = title ?? nil
        vc.titleOtherLabel.text = otherTitle ?? nil
        vc.contentLabel.text = contentString
        vc.buttonArray.removeAll()
        vc.clickBlock = clickBlock
        vc.isTextfield = false
        vc.createBtn(actionButtonTitleArray)
        vc.setUI()
        vc.resetContentViewSize()
        return vc
    }
    
    /// 创建默认样式的可以书写弹窗（TextField）
    /// - Parameters:
    ///   - title: 标题
    ///   - contentString: 内容
    ///   - actionButtonTitleArray: 点击按钮的文字
    ///   - clickBlock: 点击回调，int对应actionButtonTitleArray的位置
    @discardableResult
    static func alertDefaultTextFieldView(title:String?, otherTitle: String? = nil, contentString:String, placeholder: String?, actionButtonTitleArray:[String]?, clickBlock:((Int, String?)->Void)? = nil) -> HSWebAlterController{
        let vc = HSWebAlterController.init()
        vc.alertTitle.text = title ?? nil
        vc.titleOtherLabel.text = otherTitle ?? nil
        vc.alertTextField.text = contentString
        vc.alertTextField.placeholder = placeholder
        vc.buttonArray.removeAll()
        vc.clickBlock = clickBlock
        vc.isTextfield = true
        vc.createBtn(actionButtonTitleArray)
        vc.setUI()
        vc.resetContentViewSize()
        return vc
    }
    // MARK: - Request
    
    // MARK: - Action
    @objc public  func alertAction(_ btn:UIButton){
        if isTextfield {
            if alertTextField.text != nil && alertTextField.text!.isEmpty && btn.tag == 101{
                warmLabel.text = "请输入内容"
                return
            }
            alertTextField.endEditing(true)
        }
        clickBlock?(btn.tag-100, alertTextField.text)
        dismiss()
    }
    @objc public  func delegateDaction(){
        alertTextField.text = ""
    }
    
    //MARK:键盘通知相关操作
    @objc func keyBoardWillShow(_ notification:Notification){
        DispatchQueue.main.async {
            let user_info = notification.userInfo
            let keyboardRect = (user_info?["UIKeyboardFrameEndUserInfoKey"] as! NSValue).cgRectValue
            let y = keyboardRect.origin.y
            let y2 = y - self.contentView.as.height - 50
            UIView.animate(withDuration: 0.25, animations: {
                self.contentView.as.y = y2
            })
        }
    }

     @objc func keyBoardWillHide(_ notification:Notification){
        DispatchQueue.main.async {
            self.contentView.as.y = self.view.as.bottom-self.contentView.as.height-18-UIScreen.as.tabBarSafeHeight
        }
     }
    
    @objc func closeAction() {
        dismiss()
    }
    // MARK: - Private
    // UI
    private func setUI() {
        if !(alertTitle.text == nil || alertTitle.text!.isEmpty) {
            contentView.addSubview(alertTitle)
        }
        if !(titleOtherLabel.text == nil || titleOtherLabel.text!.isEmpty) {
            contentView.addSubview(titleOtherLabel)
        }
        contentView.addSubview(closeButton)
        if isTextfield {
            contentView.addSubview(alertTextField)
            alertTextField.addSubview(delegateButton)
            contentView.addSubview(warmLabel)
        } else {
            contentView.addSubview(contentLabel)
        }
    }
    
    // 布局
    func resetContentViewSize(){
        contentView.frame = CGRect(x: 0, y: 0, width: view.as.width-18*2, height: CGFloat.greatestFiniteMagnitude)

        let haveTitle = !(alertTitle.text == nil || alertTitle.text!.isEmpty)
        let haveOtherTitle = !(titleOtherLabel.text == nil || titleOtherLabel.text!.isEmpty)
        let titleSize = (alertTitle.text ?? "").as.size(font: UIFont.font(name: .medium, size: 16), maxSize: CGSize(width: contentView.as.width-30*2, height: CGFloat.greatestFiniteMagnitude), lineMargin: 6)

        let tempV = isTextfield ? alertTextField:contentLabel
        let tempVString = (isTextfield ? alertTextField.text:contentLabel.text) ?? ""
        let tempVWidth: CGFloat = isTextfield ? 15:25
        let textSize = tempVString.as.size(font: UIFont.font(name: .regular, size: 14), maxSize: CGSize(width: contentView.as.width-tempVWidth*2, height: CGFloat.greatestFiniteMagnitude), lineMargin: 1)
        let titleOtherSize = (titleOtherLabel.text ?? "").as.size(font: UIFont.font(name: .regular, size: 16), maxSize: CGSize(width: contentView.as.width-tempVWidth*2, height: CGFloat.greatestFiniteMagnitude), lineMargin: 1)

        let alertTextFieldH = max(tempV.as.height, textSize.height)

        var tempY = 15.0
        if haveTitle {
            alertTitle.frame = CGRect(x: 30, y: tempY, width: contentView.as.width-30*2, height: titleSize.height)
            tempY = alertTitle.as.bottom
        }
        if haveOtherTitle {
            tempY = tempY + (haveTitle ? 10:0)
            titleOtherLabel.frame = CGRect(x: tempVWidth, y: tempY, width: contentView.as.width-25*2, height: titleOtherSize.height)
            tempY = titleOtherLabel.as.bottom
        }
        
        tempY = !haveTitle && !haveOtherTitle ? 15:tempY
        closeButton.frame = CGRect(x: contentView.as.width-50, y: 0, width: 50, height: 50)

        if isTextfield {
            tempV.frame = CGRect(x: tempVWidth, y: tempY+5, width: contentView.as.width-15*2, height: alertTextFieldH)
            delegateButton.frame = CGRect(x: tempV.as.width-13-delegateButton.as.width, y: tempV.as.height/2-delegateButton.as.height/2, width: delegateButton.as.width, height: delegateButton.as.height)
            warmLabel.frame = CGRect(x: 15, y: tempV.as.bottom, width: contentView.as.width-30*2, height: 26)
        }else{
            tempV.frame = CGRect(x: tempVWidth, y: tempY+3, width: contentView.as.width-25*2, height: alertTextFieldH)
        }
        var tempView:UIView = tempV
        switch buttonArray.count {
        case 0:
            tempView = tempV
            break
        case 1:
            do {
                tempView = self.buttonArray.first!
                tempView.frame = CGRect(x: 15, y: tempV.as.bottom+15, width: contentView.as.width-30, height: 40)
            }
            break
        case 2:
            do {
                tempView = self.buttonArray.first!
                tempView.frame = CGRect(x: 15, y: tempV.as.bottom+15, width: (contentView.as.width-40)/2, height: 40)
                self.buttonArray.last!.frame = CGRect(x: tempView.as.right+10, y: tempV.as.bottom+15, width: (contentView.as.width-40)/2, height: 40)
            }
            break
        default:
            break
        }
        
        contentView.as.height = tempView.as.bottom+(buttonArray.count > 0 ? 18:40)
        contentView.as.centerX = view.as.centerX
        contentView.as.y = view.as.bottom-contentView.as.height-18-UIScreen.as.tabBarSafeHeight

    }
    
    private func createCustomView() {
        customeView = customViewBlock?(self, view.as.width-40*2, CGFloat.greatestFiniteMagnitude)
        guard customeView != nil else {
            return
        }
        contentView.addSubview(customeView!)
        contentView.as.size = customeView!.as.size
        if contentView.as.x == 0 && contentView.as.y == 0{
            contentView.as.centerX = view.as.centerX
            contentView.as.centerY = view.as.centerY-60
        }
    }
    
    // 创建button
    func createBtn(_ titleArray: [String]?) {
        guard let titleArray = titleArray else { return }
        for (i,title) in titleArray.enumerated() {
            var btn = UIButton.init(title: title, titleColor: UIColor.init(HSAppThemeModel.wordGay), titleFont: UIFont.font(name: .regular, size: 16), imageName: nil, backGroudImgName: nil, target: self, action: #selector(alertAction(_:)))
            if titleArray.count>1 {
                btn.as.cornerRadius = 20
                btn.as.borderWidth = 0.5
                btn.as.borderColor = UIColor.init(HSAppThemeModel.lineBordGay)
                if i == titleArray.count-1 {
                    btn.backgroundColor = UIColor.init(HSAppThemeModel.backGroundMain)
                    btn.setTitleColor(UIColor.init(HSAppThemeModel.backGroundLight), for: .normal)
                    btn.as.borderColor = UIColor.init(HSAppThemeModel.backGroundMain)
                }
            }else{
                btn.setTitleColor(UIColor.init(HSAppThemeModel.wordMain), for: .normal)
            }
            self.contentView.addSubview(btn)
            btn.tag = i+100
            self.buttonArray.append(btn)
        }
    }
    
    // 注册键盘通知
    func registerNotification(){
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyBoardWillShow(_ :)),
                                               name: UIResponder.keyboardWillShowNotification,
                                               object: nil)

        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyBoardWillHide(_ :)),
                                               name: UIResponder.keyboardWillHideNotification,
                                               object: nil)
     }

    // MARK: - setter & getter
    /// 标题
    lazy var alertTitle: UILabel = {
        let label = UILabel.init(title: "", fontColor: UIColor.init(HSAppThemeModel.wordBlack), fonts: UIFont.font(name: .medium, size: 16), alignment: .center)
        label.sizeToFit()
        return label
    }()
    
    /// 内容
    lazy var alertTextField: UITextField = {
        var text = UITextField.init(textColors: UIColor.init(HSAppThemeModel.wordBlack), textFont: UIFont.font(name: .regular, size: 16), placeholders: nil, placeholdersFont: UIFont.font(name: .regular, size: 16), placeholdersColor: UIColor.init(HSAppThemeModel.wordGay), cornerRadius: 20, layColor: UIColor.init(HSAppThemeModel.lineBordGay), boardStyle: UITextField.BorderStyle.none, keyBoardStyles: .default, rightWidth:50)
        text.as.height = 40
        text.becomeFirstResponder()
        text.returnKeyType = .done
        text.delegate = self
        return text
    }()
    
    /// 内容
    lazy var contentLabel: UILabel = {
        let lab = UILabel.init(title: " ", fontColor: UIColor.init(HSAppThemeModel.wordGay), fonts: UIFont.font(name: .regular, size: 14), alignment: .left)
        lab.numberOfLines = 0
        lab.sizeToFit()
        return lab
    }()
    /// 提示内容
    lazy var warmLabel: UILabel = {
        let lab = UILabel.init(title: " ", fontColor: UIColor.init(HSAppThemeModel.wordMain), fonts: UIFont.font(name: .regular, size: 11), alignment: .left)
        lab.numberOfLines = 0
        lab.sizeToFit()
        return lab
    }()
    
    lazy var delegateButton: UIButton = {
        let btn = UIButton.init(title: nil, titleColor: nil, titleFont: nil, imageName: "Room_delegate", backGroudImgName: nil, target: self, action: #selector(delegateDaction), tintColor: HSAppThemeModel.imageGayLight)
        btn.sizeToFit()
        return btn
    }()
    lazy var closeButton: UIButton = {
        var btn = UIButton.init(title: nil, titleColor: UIColor.init(HSAppThemeModel.wordMain), titleFont: UIFont.font(name: .regular, size: 16), imageName: "Room_delegate", backGroudImgName: nil, target: self, action: #selector(closeAction), tintColor: HSAppThemeModel.imageGayLight)
        btn.isHidden = true
        return btn
    }()
    lazy var titleOtherLabel: UILabel = {
        let lab = UILabel.init(title: "", fontColor: UIColor.init(HSAppThemeModel.wordBlack), fonts: UIFont.font(name: .regular, size: 16), alignment: .left)
        lab.numberOfLines = 0
        lab.sizeToFit()
        return lab
    }()
    /// 按钮数组
    lazy var buttonArray = [UIButton]()
}
// MARK: - Other Delegate
extension HSWebAlterController: UITextFieldDelegate{
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.endEditing(true)
        return true
    }
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if string.isEmpty {
            warmLabel.text = ""
            return true
        }
        if HSJudgefunction.inputRule(input: string) {
            return true
        } else {
            warmLabel.text = "只能输入数字、字母、汉字"
            return false
        }
    }
}
