//
//  HSTestWebFunctionView.swift
//  huiSenSmart
//
//  Created by jonker.sun on 2022/3/16.
//

import UIKit

class HSTestWebFunctionView: UIView {
    private var h5InfoDict: [String: Any]?
    // MARK: - Public
    static func createCustomView(_ productID: String){
        let view = HSTestWebFunctionView.init(frame: CGRect(x: UIScreen.as.screenWidth-220, y: UIScreen.as.statusBarHeight, width: 200, height: 230))
        view.h5InfoDict = HSWebOpenReady.shared.getManifestInfo(productID: productID)
        view.setUI()
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        visionLabel.frame = CGRect(x: 10, y: 10, width: self.as.width-20, height: 20)
        dateLabel.frame = CGRect(x: 10, y: visionLabel.as.bottom+10, width: self.as.width-20, height: 20)
        textV.frame = CGRect(x: 10, y: dateLabel.as.bottom+10, width: self.as.width-20, height: 100)
        realseBtn.frame = CGRect(x: 10, y: self.as.height-30, width: self.as.width-20, height: 20)
        
    }
    // MARK: - LifeCycle
    
    // MARK: - Request

    // MARK: - Action
    @objc func realseBtnAction() {
        self.removeFromSuperview()
    }
    // MARK: - Private
    private func setUI(){
        self.backgroundColor = UIColor.init("BBBBBB")
        let keyWindow = UIApplication.shared.keyWindow
        keyWindow?.addSubview(self)
        addSubview(visionLabel)
        addSubview(dateLabel)
        addSubview(textV)
        addSubview(realseBtn)
    }
    // MARK: - setter & getter
    lazy var visionLabel: UILabel = {
        let title = h5InfoDict?["version"] ?? "0.0.0"
        let lab = UILabel.init(title: "版本号：\(title)", fontColor:  UIColor.init(HSAppThemeModel.wordBlack), fonts: UIFont.font(name: .medium, size: 16), alignment: .left)
        lab.sizeToFit()
        return lab
    }()
    lazy var dateLabel: UILabel = {
        let str = "\(Int(Date.as.currentTimeStamp()))"
        let lab = UILabel.init(title: str.as.dateChangeToFormatDate(format: "yyyy-MM-dd HH:mm:ss", isZeroTime: false), fontColor:  UIColor.init(HSAppThemeModel.wordBlack), fonts: UIFont.font(name: .medium, size: 16), alignment: .left)
        lab.sizeToFit()
        return lab
    }()
    
    lazy var textV: UITextView = {
        let t = UITextView.init()
        t.textColor = .black
        t.font = UIFont.font(name: .regular, size: 12)
        t.text = String.as.dictionaryToJSONString(h5InfoDict ?? [:])
        return t
    }()
    
    lazy var realseBtn: UIButton = {
        let btn = UIButton.init(title: "收起", titleColor: .red, titleFont: UIFont.font(name: .medium, size: 16), imageName: nil, backGroudImgName: nil, target: self, action: #selector(realseBtnAction))
        return btn
    }()
}


