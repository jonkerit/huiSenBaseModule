//
//  UIView+Layer.swift
//  huiSenSmart
//
//  Created by jonkersun on 2021/4/14.
//  Copyright © 2021 Grand. All rights reserved.
//


import UIKit
public extension AriSwift where Base: UIView {
    
    /// 添加渐变色图层
    /// locations：0-1,确定变色的结束位置（总的*a）,一个locations的元素对应一个colors的一个元素的起点
    /// colors : [UIColor]

    /// startPoint|endPoint:
    /// (x: 0, y: 0.5)-(x: 1, y: 0.5) 是从左到右边颜色（colors的0-n号位置颜色），
    /// (x: 1, y: 0.5)-(x: 0, y: 0.5) 是从右到左边颜色（colors的0-n号位置颜色），
    /// (x: 0.5, y: 0)-(x: 0.5, y: 1) 是从上到下边颜色（colors的0-n号位置颜色），
    /// (x: 0.5, y: 1)-(x: 0.5, y: 0) 是从下到上边颜色（colors的0-n号位置颜色），
    /// (x: 0, y: 0)-(x: 1, y: 1) 是从左上角到右下角颜色（colors的0-n号位置颜色），
    /// (x: 1, y: 1)-(x: 0, y: 0) 是从右下角到左上角颜色（colors的0-n号位置颜色），
    /// (x: 1, y: 1)-(x: 0.5, y: 0.5) 是从右下角到左上角(中部)颜色（colors的0-n号位置颜色），
    /// (x: 0.5, y: 0.5)-(x: 1, y: 1) 是从左上角到右下角(中部)颜色（colors的0-n号位置颜色），
    /// (x: 0, y: 0)-(x: 0.5, y: 0.5) 是从左上角到右下角(中部)颜色（colors的0-n号位置颜色），

    func addGradientColor(by startPoint: CGPoint, endPoint: CGPoint, locations: [NSNumber]? , colors: [UIColor], rect: CGRect = .zero) {
        
        guard startPoint.x >= 0, startPoint.x <= 1, startPoint.y >= 0, startPoint.y <= 1, endPoint.x >= 0, endPoint.x <= 1, endPoint.y >= 0, endPoint.y <= 1 else {
            return
        }
        // 外界如果改变了self的大小，需要先刷新
        base.layoutIfNeeded()
        var gradientLayer: CAGradientLayer!
        removeGradientLayer()
        gradientLayer = CAGradientLayer()
        if rect == .zero {
            gradientLayer.frame = base.layer.bounds
        } else {
            gradientLayer.frame = rect
        }
        if locations != nil && locations!.count != 0 {
            gradientLayer.locations = locations
        }
        gradientLayer.startPoint = startPoint
        gradientLayer.endPoint = endPoint
        var tempArr = [CGColor]()
        for color in colors {
            tempArr.append(color.cgColor)
        }
        gradientLayer.colors = tempArr
        gradientLayer.cornerRadius = base.layer.cornerRadius
        gradientLayer.masksToBounds = true
        // 渐变图层插入到最底层，避免在uibutton上遮盖文字图片
        base.layer.insertSublayer(gradientLayer, at: 0)
        base.backgroundColor = UIColor.clear
        // self如果是UILabel，masksToBounds设为true会导致文字消失 ? to do：还是消失为啥
        base.layer.masksToBounds = false
    }
    
    /// 给view设置边框，可以是虚线---根据view的frame画线
    /// - Parameters:
    ///   - lineWidth: 边框宽度
    ///   - lineColor: 边框颜色
    ///   - cornerRadius: 边框圆角
    ///   - lineDashPattern: 虚线设置【实线长度，虚线长度】--- 不传则为实线
    func addBorderLine(lineWidth: CGFloat, lineColor: UIColor, cornerRadius:CGFloat, lineDashPattern: [NSNumber]?, fillColor:UIColor = UIColor.clear) {
        let shapeLayer:CAShapeLayer = CAShapeLayer()
        let frameSize = base.frame.size
        let shapeRect = CGRect(x: 0, y: 0, width: frameSize.width, height: frameSize.height)

        shapeLayer.bounds = shapeRect
        shapeLayer.name = "DashBorder"
        shapeLayer.position = CGPoint(x: frameSize.width/2, y: frameSize.height/2)
        shapeLayer.fillColor = UIColor.clear.cgColor
        shapeLayer.strokeColor = lineColor.cgColor
        shapeLayer.lineWidth = lineWidth
        shapeLayer.lineJoin = .round
        // 设置是否是虚线【实线长度，虚线长度】
        shapeLayer.lineDashPattern = lineDashPattern
        shapeLayer.path = UIBezierPath(roundedRect: shapeRect, cornerRadius: cornerRadius).cgPath
        if cornerRadius>0.0 {
            base.layer.masksToBounds = true
            base.layer.cornerRadius = cornerRadius            
        }
        base.layer.addSublayer(shapeLayer)
    }
    
    
    /// 给view设置边框，可以是虚线 --- 根据传入的BezierPath画线
    /// - Parameters:
    ///   - BezierPath: 边框的图形路径
    ///   - lineWidth: 边框宽度
    ///   - lineColor: 边框颜色
    ///   - cornerRadius: 边框圆角
    ///   - lineDashPattern: 虚线设置【实线长度，虚线长度】--- 不传则为实线
    func addBorderLine(with BezierPath:UIBezierPath,lineWidth: CGFloat, lineColor: UIColor, cornerRadius:CGFloat, lineDashPattern: [NSNumber]?) {
        let shapeLayer:CAShapeLayer = CAShapeLayer()
        let frameSize = base.frame.size
        let shapeRect = CGRect(x: 0, y: 0, width: frameSize.width, height: frameSize.height)

        shapeLayer.bounds = shapeRect
        shapeLayer.name = "DashBorder"
        shapeLayer.position = CGPoint(x: frameSize.width/2, y: frameSize.height/2)
        shapeLayer.fillColor = UIColor.clear.cgColor
        shapeLayer.strokeColor = lineColor.cgColor
        shapeLayer.lineWidth = lineWidth
        shapeLayer.lineJoin = .round
        // 设置是否是虚线【实线长度，虚线长度】
        shapeLayer.lineDashPattern = lineDashPattern

        shapeLayer.path = BezierPath.cgPath
        base.layer.masksToBounds = false
        base.layer.cornerRadius = cornerRadius
        base.layer.addSublayer(shapeLayer)
    }
    
    
    /// 会话包装成气泡图的BezierPath
    func createGasBezierPath(shapeRect:CGRect, cornerRadius:CGFloat) -> UIBezierPath{
        let BezierPath = UIBezierPath()
        let frameSize = shapeRect.size
        BezierPath.addArc(withCenter: CGPoint(x:cornerRadius*2, y: cornerRadius), radius: cornerRadius, startAngle: -.pi, endAngle: -.pi/2, clockwise: true)
        BezierPath.addLine(to: CGPoint(x: frameSize.width-cornerRadius, y: 0))
        BezierPath.addArc(withCenter: CGPoint(x:frameSize.width-cornerRadius, y: cornerRadius), radius: cornerRadius, startAngle: -.pi/2, endAngle: CGFloat(0), clockwise: true)
        BezierPath.addLine(to: CGPoint(x: frameSize.width, y: frameSize.height-cornerRadius))
        BezierPath.addArc(withCenter: CGPoint(x:frameSize.width-cornerRadius, y: frameSize.height-cornerRadius), radius: cornerRadius, startAngle: CGFloat(0), endAngle: .pi/2, clockwise: true)
        BezierPath.addLine(to: CGPoint(x: cornerRadius*2, y: frameSize.height))
        BezierPath.addArc(withCenter: CGPoint(x:cornerRadius*2, y: frameSize.height-cornerRadius), radius: cornerRadius, startAngle: .pi/2, endAngle: .pi, clockwise: true)
        BezierPath.addLine(to: CGPoint(x: cornerRadius, y: cornerRadius*3))
        BezierPath.addQuadCurve(to: CGPoint(x: 0, y: cornerRadius), controlPoint: CGPoint(x: cornerRadius, y: cornerRadius*2))
        BezierPath.close()
        return BezierPath
    }
    
    
    /// 给view添加圆角的阴影
    /// - Parameters:
    ///   - radius: 圆角半径
    ///   - shadowOpacity: 阴影的透明度
    ///   - shadowOffset: 阴影的偏移尺寸
    func addCornerRadiusShadow(radius: CGFloat, shadowOpacity: CGFloat = 0.1, shadowOffset: CGSize = CGSize(width: 0, height: 3)){
        let layerShadow = base.layer
        layerShadow.frame = base.bounds
        layerShadow.backgroundColor = UIColor.white.cgColor
        layerShadow.shadowColor = UIColor.black.cgColor
        layerShadow.shadowOpacity = Float(shadowOpacity)
        layerShadow.shadowOffset = shadowOffset
        layerShadow.shadowRadius = radius
        layerShadow.cornerRadius = radius
        base.layer.cornerRadius = layerShadow.cornerRadius
        base.layer.masksToBounds = false
    }
    
    // MARK: 移除渐变图层
    // （当希望只使用backgroundColor的颜色时，需要先移除之前加过的渐变图层）
    private func removeGradientLayer() {
        if let sl = base.layer.sublayers {
            for layer in sl {
                if layer.isKind(of: CAGradientLayer.self) {
                    layer.removeFromSuperlayer()
                }
            }
        }
    }
    
    var cornerRadius: CGFloat {
        get {
            return base.layer.cornerRadius
        }
        set {
            base.layer.cornerRadius = newValue
            base.layer.masksToBounds = newValue > 0
        }
    }
    
     var borderWidth: CGFloat {
        get {
            return base.layer.borderWidth
        }
        set {
            base.layer.borderWidth = newValue
        }
    }
    
    var borderColor: UIColor? {
        get {
            return UIColor(cgColor: base.layer.borderColor!)
        }
        set {
            base.layer.borderColor = newValue?.cgColor
        }
    }
}


public extension UIView {
    
    @IBInspectable var cornerRadius: CGFloat {
        get {
            return layer.cornerRadius
        }
        set {
            layer.cornerRadius = newValue
            layer.masksToBounds = newValue > 0
        }
    }
    
    @IBInspectable var borderWidth: CGFloat {
        get {
            return layer.borderWidth
        }
        set {
            layer.borderWidth = newValue
        }
    }
    
    @IBInspectable var borderColor: UIColor? {
        get {
            return UIColor(cgColor: layer.borderColor!)
        }
        set {
            layer.borderColor = newValue?.cgColor
        }
    }
    
    var corner: Bool {
        get {
            return cornerRadius > 0
        }
        set {
            if newValue {
                cornerRadius = 5
            } else {
                cornerRadius = 0
            }
        }
    }
}
