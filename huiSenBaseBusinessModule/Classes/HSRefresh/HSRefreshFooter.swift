//
//  HSRefreshFooter.swift
//  huiSenSmart
//
//  Created by jonkersun on 2021/6/28.
//

import UIKit
import MJRefresh

public class HSRefreshFooter: MJRefreshAutoFooter {
    private var refreshStyle:HSRefreshStyle?

    /// 创建自定义refreshFooter
    /// - Parameters:
    ///   - refreshingTarget: Target
    ///   - action: Selector
    ///   - refreshStyle: 刷新的样式分类
    /// - Returns: 一个自定义header
    public static func createFooter(With refreshingTarget: Any, action: Selector,refreshStyle:HSRefreshStyle)->HSRefreshFooter{
        let header = HSRefreshFooter.init(refreshingTarget: refreshingTarget, refreshingAction: action)
        header.refreshStyle = refreshStyle
        header.changeRefreshStyle()
        return header
    }
    
    // 根据不同style设置不同的样式
    private func changeRefreshStyle() {
        var imagName = ""
//        var color = UIColor.init()
        switch refreshStyle {
        case .HSWhiteRefreshStyle:
            imagName = "HSRefresh_"
//            color = UIColor.init("0x282C34")
            break
        case .HSGoldeRefreshStyle:
            imagName = "HSRefresh_"
//            color = UIColor.init("0x282C34")
            break
        case .HSBlueRefreshStyle:
            imagName = "HSRefresh_"
//            color = UIColor.init("0xF2F4F9")
            break
        default:
            imagName = "HSRefresh_"
//            color = UIColor.init("0x282C34")
        }
        var imagArr = [UIImage]()
        for i in 0..<21 {
            let tempImgae = UIImage.init(named: imagName+"\(i)")
            if tempImgae != nil {
                imagArr.append(tempImgae!)
            }
        }
        guard imagArr.count > 0 else {
            return
        }
        
        gifImageArray = imagArr
        gifImage.image = gifImageArray.first
        gifImage.animationImages = gifImageArray
        gifImage.animationDuration = TimeInterval(CGFloat(gifImageArray.count) * 0.03)
    }
    
    public lazy var stateLabel: UILabel = {
        let lab = UILabel.mj_()
        lab.textColor = UIColor.init(HSAppThemeModel.wordGay)
        lab.font = UIFont.font(name: .regular, size: 13)
        return lab
    }()
    
    lazy private var gifImage: UIImageView = UIImageView.init()
    lazy private var gifImageArray: [UIImage] = [UIImage]()
}

/// 重写父类的方法，属性
public extension HSRefreshFooter {
    public override func prepare() {
        super.prepare()
        self.mj_h = 80
        addSubview(stateLabel)
        addSubview(gifImage)
    }
    
    public override func placeSubviews() {
        super.placeSubviews()
        self.stateLabel.sizeToFit()

        self.stateLabel.frame = CGRect(x: (self.as.width-self.stateLabel.as.width)/2, y: 20, width: self.stateLabel.as.width, height: self.stateLabel.as.height)
        self.gifImage.frame = CGRect(x: self.stateLabel.as.x-5-15, y: self.stateLabel.as.centerY-15/2, width: 15, height: 15)
    }
    
    public override var state: MJRefreshState{
        didSet{
            var tempStr = ""
            gifImage.isHidden = false;
            switch state {
            case .idle:
                tempStr = ""
                self.gifImage.stopAnimating()
                gifImage.isHidden = true;
                break
            case .pulling:
                tempStr = "上拉刷新"
                self.gifImage.stopAnimating()
                gifImage.isHidden = true;
                break
            case .refreshing:
                tempStr = "加载中"
                self.gifImage.startAnimating()
                break
            case .noMoreData:
                tempStr = "到底啦"
                self.gifImage.stopAnimating()
                gifImage.isHidden = true;
                break
            default:
                tempStr = ""
                break
            }
            self.stateLabel.text = tempStr
        }
    }
   
    public override var pullingPercent: CGFloat{
        didSet{
            if state != .idle || self.gifImageArray.count == 0 {
                return
            }
            // 停止动画
            self.gifImage.stopAnimating()
            // 设置当前需要显示的图片
            var index = CGFloat(self.gifImageArray.count) * pullingPercent
            if index >= CGFloat(self.gifImageArray.count) {
                index = CGFloat(self.gifImageArray.count - 1)
            }
            self.gifImage.image = self.gifImageArray[Int(index)]
        }
        
    }
}
