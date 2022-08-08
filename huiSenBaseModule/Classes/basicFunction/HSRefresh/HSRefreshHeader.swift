//
//  HSRefreshHeader.swift
//  huiSenSmart
//
//  Created by jonkersun on 2021/6/28.
//

import UIKit
import MJRefresh

enum HSRefreshStyle {
    case HSWhiteRefreshStyle      // 白色圆心
    case HSGoldeRefreshStyle      // 金色圆心
    case HSBlueRefreshStyle       // 蓝色圆心
}

class HSRefreshHeader: MJRefreshHeader {
    private var refreshStyle:HSRefreshStyle?
    var popActionBlock:(()->Void)?

    /// 创建自定义refreshheader
    /// - Parameters:
    ///   - refreshingTarget: Target
    ///   - action: Selector
    ///   - refreshStyle: 刷新的样式分类
    /// - Returns: 一个自定义header
    static func createHeader(With refreshingTarget: Any, action: Selector,refreshStyle:HSRefreshStyle)->HSRefreshHeader{
        let header = HSRefreshHeader.init(refreshingTarget: refreshingTarget, refreshingAction: action)
        header.refreshStyle = refreshStyle
        header.changeRefreshStyle()
        return header
    }
    
    // 根据不同style设置不同的样式
    private func changeRefreshStyle() {
        var imagName = ""
        _ = UIColor.init()
        switch refreshStyle {
        case .HSWhiteRefreshStyle:
            imagName = "HSRefresh_"
            break
        case .HSGoldeRefreshStyle:
            imagName = "HSRefresh_"
            break
        case .HSBlueRefreshStyle:
            imagName = "HSRefresh_"
            break
        default:
            imagName = "HSRefresh_"
        }
        var imagArr = [UIImage]()
        for i in 0..<20 {
            let tempImgae = UIImage.init(named: imagName+"\(i)")
            if tempImgae != nil {
                imagArr.append(tempImgae!)
            }
        }
        guard imagArr.count > 0 else {
            return
        }
        gifImageArray = imagArr
        gifImage.image = UIImage.as.imageNamed("HSRefresh_arrow")
        gifImage.animationImages = gifImageArray
        gifImage.animationDuration = TimeInterval(CGFloat(gifImageArray.count) * 0.03)
    }
    
    lazy private var stateLabel: UILabel = {
        let lab = UILabel.mj_()
        lab.textColor = UIColor.init(HSAppThemeModel.wordGay)
        lab.font = UIFont.font(name: .regular, size: 13)
        return lab
    }()
    
    lazy private var gifImage: UIImageView = UIImageView.init()
    lazy private var gifImageArray: [UIImage] = [UIImage]()
}

/// 重写父类的方法，属性
extension HSRefreshHeader {
    internal override func prepare() {
        super.prepare()
        self.mj_h = 80
        addSubview(stateLabel)
        addSubview(gifImage)
    }
    
    internal override func placeSubviews() {
        super.placeSubviews()
        self.stateLabel.sizeToFit()
        self.stateLabel.frame = CGRect(x: (self.as.width-self.stateLabel.as.width)/2, y: 20, width: self.stateLabel.as.width, height: self.stateLabel.as.height)
        self.gifImage.frame = CGRect(x: self.stateLabel.as.x-5-15, y: self.stateLabel.as.centerY-15/2, width: 15, height: 15)
    }
    
    internal override var state: MJRefreshState{
        didSet{
            var tempStr = ""
            switch state {
            case .idle:
                tempStr = ""
                self.gifImage.stopAnimating()
                break
            case .pulling:
                tempStr = "下拉刷新"
                self.gifImage.stopAnimating()
                break
            case .refreshing:
                tempStr = "加载中"
                self.gifImage.startAnimating()
                break
            default:
                tempStr = ""
                break
            }
            self.stateLabel.text = tempStr
        }
    }
    
    internal override var pullingPercent: CGFloat{
        didSet{
            if state != .idle || self.gifImageArray.count == 0 {
                return
            }
            // 停止动画
            self.gifImage.stopAnimating()
            self.gifImage.image = UIImage.as.imageNamed("HSRefresh_arrow")

//            // 设置当前需要显示的图片
//            var index = CGFloat(self.gifImageArray.count) * pullingPercent
//            if index >= CGFloat(self.gifImageArray.count) {
//                index = CGFloat(self.gifImageArray.count - 1)
//            }
//            self.gifImage.image = self.gifImageArray[Int(index)]
        }
        
    }
}
