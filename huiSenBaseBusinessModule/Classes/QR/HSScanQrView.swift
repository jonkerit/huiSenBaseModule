//
//  HSScanQrView.swift
//  huiSenSmart
//
//  Created by jonker.sun on 2022/1/20.
//

import UIKit
import CoreMedia

class HSScanQrView: UIView {
    
    private var baseLayer:CALayer?
    private var GCDtimer:DispatchSourceTimer?
    private var scanContentY = UIScreen.as.screenHeight*0.24
    private var scanContentX = UIScreen.as.screenWidth*0.15
    private var myFlag = true

    // MARK: - Public
    static func createCustomView(frame:CGRect, superLayer: CALayer)->HSScanQrView{
        let view = HSScanQrView.init(frame: frame)
        view.baseLayer = superLayer
        view.setUI()
        return view
    }
    
    func startTimer() {
        GCDtimer?.cancel()
        GCDtimer = Timer.as.timerCreateByDispatch(timeInterval: HSScanQrstaticNumber.timerAnimationDuration, repeatCount: -1) { [weak self] timers, times in
            self?.animationLineAction()
        }
    }
    
    func removeTimer() {
        GCDtimer?.cancel()
    }
    // MARK: - LifeCycle
    
    // MARK: - Request
    
    // MARK: - Action

    // MARK: - Private
    private func setUI(){
        let scanContentView = UIView()
        scanContentView.frame = CGRect(x: scanContentX, y: scanContentY, width: UIScreen.as.screenWidth-2*scanContentX, height: UIScreen.as.screenWidth-2*scanContentX)
        scanContentView.layer.borderWidth = 0.7
        scanContentView.layer.borderColor = UIColor.white.withAlphaComponent(0.6).cgColor
        scanContentView.backgroundColor = .clear
        baseLayer?.addSublayer(scanContentView.layer)
        
        let topLineView = UIView()
        topLineView.frame = CGRect(x: 0, y: 0, width: self.as.width, height: scanContentY)
        topLineView.backgroundColor = .black.withAlphaComponent(HSScanQrstaticNumber.scanBorderOutsideViewAlpha)
        self.addSubview(topLineView)
        
        let letfLineView = UIView()
        letfLineView.frame = CGRect(x: 0, y: scanContentY, width: scanContentX, height: scanContentView.as.width)
        letfLineView.backgroundColor = .black.withAlphaComponent(HSScanQrstaticNumber.scanBorderOutsideViewAlpha)
        self.addSubview(letfLineView)
        
        let bottomLineView = UIView()
        bottomLineView.frame = CGRect(x: 0, y: letfLineView.as.bottom, width: self.as.width, height: self.as.height-letfLineView.as.bottom)
        bottomLineView.backgroundColor = .black.withAlphaComponent(HSScanQrstaticNumber.scanBorderOutsideViewAlpha)
        self.addSubview(bottomLineView)
        
        let rightLineView = UIView()
        rightLineView.frame = CGRect(x: scanContentView.as.right, y: scanContentY, width: self.as.width-scanContentView.as.right, height: scanContentView.as.width)
        rightLineView.backgroundColor = .black.withAlphaComponent(HSScanQrstaticNumber.scanBorderOutsideViewAlpha)
        self.addSubview(rightLineView)
        
        let margin = 7.0
        
        let leftImageView = UIImageView.init(imageName: "ks_scan_top_left")
        leftImageView.sizeToFit()
        leftImageView.frame = CGRect(x: scanContentView.as.x-leftImageView.as.width*0.5+margin, y: scanContentView.as.y-leftImageView.as.width*0.5+margin, width: leftImageView.as.width, height: leftImageView.as.height)
        baseLayer?.addSublayer(leftImageView.layer)
        
        let rightImageView = UIImageView.init(imageName: "ks_scan_top_right")
        rightImageView.sizeToFit()
        rightImageView.frame = CGRect(x: scanContentView.as.right-rightImageView.as.width*0.5-margin, y: leftImageView.as.y, width: rightImageView.as.width, height: rightImageView.as.height)
        baseLayer?.addSublayer(rightImageView.layer)
        
        let bottomLeftImageView = UIImageView.init(imageName: "ks_scan_bottom_left")
        bottomLeftImageView.sizeToFit()
        bottomLeftImageView.frame = CGRect(x: leftImageView.as.x, y: scanContentView.as.bottom-bottomLeftImageView.as.width*0.5-margin, width: bottomLeftImageView.as.width, height: bottomLeftImageView.as.height)
        baseLayer?.addSublayer(bottomLeftImageView.layer)
        
        let bottomRightImageView = UIImageView.init(imageName: "ks_scan_bottom_right")
        bottomRightImageView.sizeToFit()
        bottomRightImageView.frame = CGRect(x: rightImageView.as.x, y: bottomLeftImageView.as.y, width: bottomRightImageView.as.width, height: bottomRightImageView.as.height)
        baseLayer?.addSublayer(bottomRightImageView.layer)
        
        // line
        animationLine.frame = CGRect(x: scanContentX*0.5, y: scanContentY, width: self.as.width-scanContentX, height: HSScanQrstaticNumber.animationLineH)
        baseLayer?.addSublayer(animationLine.layer)
    }
    
    private func animationLineAction() {
        if myFlag {
            myFlag = false
            UIView.animate(withDuration: HSScanQrstaticNumber.timerAnimationDuration) {
                self.animationLine.as.y = self.animationLine.as.y + 5
            }
        }else{
            if animationLine.as.y >= scanContentY {
                let scanContentMAXY = scanContentY+self.as.width - 2*scanContentX
                if animationLine.as.y >= scanContentMAXY - 5 {
                    animationLine.as.y = scanContentY
                    myFlag = true
                }else{
                    UIView.animate(withDuration: HSScanQrstaticNumber.timerAnimationDuration) {
                        self.animationLine.as.y = self.animationLine.as.y + 5
                    }
                }
            }else{
                myFlag = !myFlag
            }
        }
    }
    // MARK: - setter & getter
    /// 移动line
    private lazy var animationLine = UIImageView.init(imageName: "ks_scan_scanning_line")
}

    // MARK: - Other Delegate
//extension HSScanQrView : {
//
//}

