//
//  UITableViewCell+AS.swift
//  huiSenSmart
//
//  Created by jonker.sun on 2022/3/29.
//

import UIKit

public extension AriSwift where Base : UITableViewCell {
    
    /// 给UITableViewCell画圆角（卡片化tableView的section）
    /// - Parameters:
    ///   - chioceTableView: cell所属tableView
    ///   - cornerRadius: 圆角
    ///   - indexPath: cell的index path
    func drawPathRefForCell(chioceTableView: UITableView, cornerRadius: CGFloat, indexPath: IndexPath, haveFooter: Bool = false, haveHeader: Bool = false) {
        base.backgroundColor = .clear
        let pathRef = CGMutablePath()
        let cellFrame = base.bounds
        let total = chioceTableView.numberOfRows(inSection: indexPath.section)-1
        
        if indexPath.row == 0 && indexPath.row == total && !haveFooter && !haveHeader{
            // 1.既是第一行又是最后一行
            // 1.1.底端中点 -> cell左下角
            pathRef.move(to: CGPoint(x: cellFrame.midX, y: cellFrame.maxY))
            // 1.2.左下角 -> 左端中点
            pathRef.addArc(tangent1End: CGPoint(x: cellFrame.minX, y: cellFrame.maxY), tangent2End: CGPoint(x: cellFrame.minX, y: cellFrame.midY), radius: cornerRadius)
            // 1.3.左上角 -> 顶端中点
            pathRef.addArc(tangent1End: CGPoint(x: cellFrame.minX, y: cellFrame.minY), tangent2End: CGPoint(x: cellFrame.midX, y: cellFrame.minY), radius: cornerRadius)
            // 1.4.cell右上角 -> 右端中点
            pathRef.addArc(tangent1End: CGPoint(x: cellFrame.maxX, y: cellFrame.minY), tangent2End: CGPoint(x: cellFrame.maxX, y: cellFrame.midY), radius: cornerRadius)
            // 1.5.cell右下角 -> 底端中点
            pathRef.addArc(tangent1End: CGPoint(x: cellFrame.maxX, y: cellFrame.maxY), tangent2End: CGPoint(x: cellFrame.midX, y: cellFrame.maxY), radius: cornerRadius)
        }else if indexPath.row == 0 && !haveHeader{
            // 2.每组第一行cell
            // 2.1.起点： 左下角
            pathRef.move(to: CGPoint(x: cellFrame.minX, y: cellFrame.maxY))
            // 2.2.cell左上角 -> 顶端中点
            pathRef.addArc(tangent1End: CGPoint(x: cellFrame.minX, y: cellFrame.minY), tangent2End: CGPoint(x: cellFrame.midX, y: cellFrame.minY), radius: cornerRadius)
            // 2.3.cell右上角 -> 右端中点
            pathRef.addArc(tangent1End: CGPoint(x: cellFrame.maxX, y: cellFrame.minY), tangent2End: CGPoint(x: cellFrame.maxX, y: cellFrame.midY), radius: cornerRadius)
            // 2.4.cell右下角
            pathRef.addLine(to: CGPoint(x: cellFrame.maxX, y: cellFrame.maxY))

        }else if indexPath.row == total && !haveFooter {
            // 3.每组最后一行cell
            // 3.1.初始起点为cell的左上角坐标
            pathRef.move(to: CGPoint(x: cellFrame.minX, y: cellFrame.minY))
            // 3.2.cell左下角 -> 底端中点
            pathRef.addArc(tangent1End: CGPoint(x: cellFrame.minX, y: cellFrame.maxY), tangent2End: CGPoint(x: cellFrame.midX, y: cellFrame.maxY), radius: cornerRadius)
            // 3.3.cell右下角 -> 右端中点
            pathRef.addArc(tangent1End: CGPoint(x: cellFrame.maxX, y: cellFrame.maxY), tangent2End: CGPoint(x: cellFrame.maxX, y: cellFrame.minY), radius: cornerRadius)
            // 3.4.cell右上角
            pathRef.addLine(to: CGPoint(x: cellFrame.maxX, y: cellFrame.minY))
        }else{
            // 4.每组的中间行
            pathRef.addRect(cellFrame)
        }
        
        // 画图
        let layer = CAShapeLayer()
        // 绘制完毕，路径信息赋值给layer
        layer.path = pathRef
        // 按照shape layer的path填充颜色，类似于渲染render
        layer.fillColor = UIColor.init(HSAppThemeModel.backGroundLight).cgColor
        // 创建和cell尺寸相同的view
        let backView = UIView.init(frame: cellFrame)
        // 添加layer给backView
        backView.layer.insertSublayer(layer, at: 0)
        // backView的颜色
        backView.backgroundColor = .clear
        // 把backView添加给cell
        base.backgroundView = backView
    }

}
