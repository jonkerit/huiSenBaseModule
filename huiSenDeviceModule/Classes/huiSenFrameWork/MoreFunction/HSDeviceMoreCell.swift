//
//  HSDeviceMoreCell.swift
//  huiSenSmart
//
//  Created by jonker.sun on 2022/3/29.
//

import UIKit

protocol HSDeviceMoreCellDelegate: NSObject{
    func delegateDevice()
    func changeDeviceName(_ name: String?)
}
class HSDeviceMoreCell: UITableViewCell {
    weak var delagate: HSDeviceMoreCellDelegate?
    // MARK: - LifeCycle
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none
        setUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        titleLabel.sizeToFit()
        nameTextF.sizeToFit()
        orderTitleLabel.sizeToFit()
        orderNumberLabel.sizeToFit()
        delegateButton.sizeToFit()
        warmLabel.sizeToFit()
        
        titleLabel.frame = CGRect(x: 15, y: 15, width: contentView.as.width/2, height: titleLabel.as.height)
        switchImgV.frame = CGRect(x: contentView.as.width-15-40, y: titleLabel.as.centerY-25/2, width: 40, height: 25)
        gayView.frame = CGRect(x: 15, y: 15, width: contentView.as.width-2*titleLabel.as.x, height: 40)
        nameTextF.frame = CGRect(x: titleLabel.as.x, y: 0, width: gayView.as.width-2*titleLabel.as.x, height: gayView.as.height)
        orderTitleLabel.frame = CGRect(x: titleLabel.as.x, y: gayView.as.bottom+20, width: 80, height: orderTitleLabel.as.height)
        orderNumberLabel.frame = CGRect(x: orderTitleLabel.as.right+10, y: orderTitleLabel.as.centerY-orderNumberLabel.as.height/2, width: contentView.as.width-15-(orderTitleLabel.as.right+10), height: orderNumberLabel.as.height)
        delegateButton.frame = CGRect(x: 0, y: orderTitleLabel.as.bottom+5, width: contentView.as.width, height: 50)
        warmLabel.frame = CGRect(x: titleLabel.as.x*2, y: gayView.as.bottom+3, width: gayView.as.width-titleLabel.as.x*2, height: warmLabel.as.height)
        numberLabel.frame = CGRect(x: nameTextF.as.width-50, y: 0, width: 50, height: 40)

    }
    // MARK: - Public
    func giveVauleForCell(_ model:HSDeviceMoreModel) {
        switchImgV.setOn(model.isUsed, animated: true)
        nameTextF.text = model.deviceName
        orderNumberLabel.text = model.devicenumber
        numberLabel.text = "\(model.deviceName.count)/15"
    }
    // MARK: - Request

    // MARK: - Action
    @objc func delegateAction() {
        delagate?.delegateDevice()
    }
    @objc func textFieldDidChange(_ textF: UITextField) {
        if (textF.markedTextRange == nil) {
            //点击完选中的字之后
            let tempStr = (textF.text ?? "")
            if tempStr.count > 15{
                warmLabel.text = "设备名称默认不超过15个字符"
                nameTextF.text = tempStr.as[0..<15]
            }else{
                warmLabel.text = ""
            }
            numberLabel.text = "\((nameTextF.text ?? "").count)/15"
        }
    }
    // MARK: - Private
    private func setUI(){
//        contentView.addSubview(titleLabel)
//        contentView.addSubview(switchImgV)
        contentView.addSubview(gayView)
        gayView.addSubview(nameTextF)
        nameTextF.addSubview(numberLabel)
        contentView.addSubview(warmLabel)
        contentView.addSubview(orderTitleLabel)
        contentView.addSubview(orderNumberLabel)
        contentView.addSubview(delegateButton)
    }
    // MARK: - setter & getter
    lazy var titleLabel: UILabel = {
        let lab = UILabel.init(title: "在常用列表中显示", fontColor: UIColor.init(HSAppThemeModel.wordBlack), fonts: UIFont.font(name: .medium, size: 14), alignment: .left)
        return lab
    }()
    lazy var switchImgV: UISwitch = {
        let sw = UISwitch()
        sw.onTintColor = UIColor.init(HSAppThemeModel.backGroundMain)
//        sw.thumbTintColor = UIColor.init(HSAppThemeModel.backGroundGay)
        return sw
    }()
    lazy var nameTextF: UITextField = {
        let lab = UITextField.init(placeholders: nil, title: "", textColors: UIColor.init(HSAppThemeModel.wordGay), textFont: UIFont.font(name: .regular, size: 15))
        lab.returnKeyType = .done
        lab.delegate = self
        lab.addTarget(self, action: #selector(textFieldDidChange(_ :)), for: .editingChanged)
        lab.rightView = UIView.init(frame:CGRect(x: 0, y: 0, width: 50, height: 0))
        lab.rightView?.isUserInteractionEnabled = true
        lab.rightViewMode = .always
        lab.isUserInteractionEnabled = !HSWebOpenFunction.shared.isMemberRole
        return lab
    }()
    lazy var warmLabel: UILabel = {
        let lab = UILabel.init(title: " ", fontColor: UIColor.init(HSAppThemeModel.wordMain), fonts: UIFont.font(name: .regular, size: 11), alignment: .left)
        return lab
    }()
    lazy var gayView: UIView = {
        var view = UIView()
        view.backgroundColor = UIColor.init(HSAppThemeModel.backGroundGay)
        view.as.cornerRadius = 5
        return view
    }()
    lazy var orderTitleLabel: UILabel = {
        let lab = UILabel.init(title: "序列号", fontColor: UIColor.init(HSAppThemeModel.wordBlack), fonts: UIFont.font(name: .regular, size: 14), alignment: .left)
        return lab
    }()
    lazy var orderNumberLabel: UILabel = {
        let lab = UILabel.init(title: "", fontColor: UIColor.init(HSAppThemeModel.wordGay), fonts: UIFont.font(name: .regular, size: 14), alignment: .right)
        return lab
    }()
    lazy var delegateButton: UIButton = {
        let btn = UIButton.init(title: "删除设备", titleColor: UIColor.init(HSAppThemeModel.wordGay), titleFont: UIFont.font(name: .regular, size: 15), imageName: nil, backGroudImgName: nil, target: self, action: #selector(delegateAction))
        btn.isHidden = HSWebOpenFunction.shared.isMemberRole
        return btn
    }()
    lazy var numberLabel: UILabel = {
        let lab = UILabel.init(title: "0/15", fontColor: UIColor.init(HSAppThemeModel.wordBlack), fonts: UIFont.font(name: .regular, size: 13), alignment: .right)
        lab.isHidden = true
        return lab
    }()
}
// MARK: - Other Delegate
extension HSDeviceMoreCell : UITextFieldDelegate {
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
    func textFieldDidEndEditing(_ textField: UITextField) {
        numberLabel.isHidden = true
        warmLabel.text = ""
        delagate?.changeDeviceName(textField.text)
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.endEditing(true)
        return true
    }
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        numberLabel.isHidden = false
        return true
    }
}

