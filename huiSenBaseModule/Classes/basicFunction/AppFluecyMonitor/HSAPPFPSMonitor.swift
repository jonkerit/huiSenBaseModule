//
//  HSAPPFPSMonitor.swift
//  huiSenSmart
//
//  Created by jonkersun on 2021/10/25.
//

import UIKit

class HSAPPFPSMonitor: NSObject {
    static var shareMonitor = HSAPPFPSMonitor()
    private var lastime:Double = 0
    private var count:Int = 0
    
    func startMonitoring() {
           linkMonitor.add(to: RunLoop.main, forMode: .common)
           setUI()
    }
    private func setUI() {
        guard let keyWindow = UIApplication.as.keyWindow else { return  }
        keyWindow.addSubview(backView)
        keyWindow.addSubview(showLab)
        keyWindow.addSubview(showColorView)
        
        backView.frame = CGRect(x: 0, y: 0, width: UIScreen.as.screenWidth, height: UIScreen.as.statusBarHeight)
        showLab.frame = CGRect(x: 20, y: 0, width: UIScreen.as.screenWidth/2, height: backView.as.height)
        showColorView.frame = CGRect(x: UIScreen.as.screenWidth-100, y: backView.as.centerY-5, width: 80, height: 10)

    }
    deinit {
        linkMonitor.remove(from: RunLoop.main, forMode: .common)
    }
    
    private lazy var linkMonitor: CADisplayLink = {
        let link = CADisplayLink.init(target: self, selector: #selector(tick(_:)))
        return link
    }()
    
    private lazy var showLab = UILabel.init(title: "当前FPS值：60", fontColor: UIColor.init(red: 48, green: 192, blue: 28), fonts: UIFont.font(name: .medium, size: 14), alignment: .left)
    private lazy var showColorView:UIView = {
        var view = UIView()
        view.as.cornerRadius = 5
        return view
    }()
    private lazy var backView:UIView = {
        let backV = UIView()
        backV.backgroundColor = UIColor.white
        backV.alpha = 0.7
        return backV
    }()

}

extension HSAPPFPSMonitor {
    @objc private func tick(_ displayLink:CADisplayLink) {
        if lastime == 0 {
            lastime = displayLink.timestamp
            return
        }
        count = count+1
        
        let delta:Double = displayLink.timestamp-lastime
        if delta<1.0 {
            return
        }
        lastime = displayLink.timestamp
        let fps:Int = Int(Double(count) / delta)
        count = 0
        if fps>60 {
            return
        }
        showLab.text = "当前FPS值：\(fps) FPS"
        let red = min(Int(48 + Int((255-48)*(60-fps) / 60)), 255)
        let green = max(Int(192 - (192-28)*(60-fps) / 60), 0)

        let color = UIColor.init(red: UInt8(red), green: UInt8(green), blue: 28)
        showColorView.backgroundColor = color
        showLab.textColor = color
    }
}
