//
//  HSRedPointView.swift
//  huiSenSmart
//
//  Created by jonker.sun on 2022/5/11.
//

import UIKit

typealias CompletionRedPiontNotice = (HSRedPointModel) -> Void
class HSRedPointView: UIView {
    // MARK: - LifeCycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .clear
        setUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        
    }
    
    // MARK: - Publick
    
    /// 给自己添加一个小红点变化的监听
    /// - Parameters:
    ///   - redKey: 小红点的key
    ///   - isNow: 是否马上给小红点一个原始值
    ///   - completioned: 回调
    func addRedPoinNotificationObserver(redKey: String, isNow: Bool, completioned:@escaping CompletionRedPiontNotice) {
        if isNow, let model = HSRedPointBingMananger.standard.getModel(redKey) {
            completioned(model)
        }
        NotificationCenter.default.addObserver(forName: HSBaseNotificationName.redPointChange, object: nil, queue: OperationQueue.main) {notification in
            guard let model = notification.userInfo?["redPointModel"] as? HSRedPointModel, model.selfKey == redKey else { return }
            completioned(model)
        }
    }
    
    /// 给红点值
    /// - Parameter number: 数目（小于0为，展示红点，等于0为隐藏红点，大于0为展示红点数目）
    func giveLabelVaule(_ number: Int) {
        if number < 0 {
            self.isHidden = false
            redLabel.isHidden = false
            redLabel.text = ""
            redLabel.as.size = CGSize(width: 10, height: 10)
            redLabel.as.cornerRadius = 5
        }else if number == 0 {
            redLabel.isHidden = true
            self.isHidden = true
        }else{
            self.isHidden = false
            redLabel.isHidden = false
            redLabel.text = "\(number)"
            redLabel.sizeToFit()
            redLabel.as.cornerRadius = redLabel.as.height/2
        }
        self.bounds = redLabel.bounds
    }
    
    
    // MARK: - Action

    // MARK: - Private
    private func setUI(){
        addSubview(redLabel)
        self.bounds = redLabel.bounds
    }
    
    // MARK: - setter & getter
    lazy var redLabel: UILabel = {
        var lab = UILabel.init(title: " ", fontColor: UIColor.init(HSAppThemeModel.backGroundLight), fonts: UIFont.font(name: .regular, size: 10), alignment: .center)
        lab.backgroundColor = UIColor.init(HSAppThemeModel.backGroundMain)
        lab.sizeToFit()
        lab.as.size = CGSize(width: 10, height: 10)
        lab.as.cornerRadius = 5
        lab.isHidden = true
        return lab
    }()
}

    // MARK: - Other Delegate
//extension HSRedPointView : {
//
//}

