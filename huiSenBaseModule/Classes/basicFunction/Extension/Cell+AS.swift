//
//  Cell+AS.swift
//  huiSenSmart
//
//  Created by jonkersun on 2021/4/14.
//  Copyright © 2021 Grand. All rights reserved.
//


import Foundation
import UIKit
public extension AriSwift where Base: UITableView {
    func register(_ cellClass: AnyClass){
        base.register(cellClass, forCellReuseIdentifier: "\(cellClass.hash())")
    }
    
    /// 使用nib注册时 不要使用privite或者fileprivite修饰的类
    /// 如果使用的话cellClass就不单纯了,不能正确的获取nibName
    func registerNib(_ cellClass: AnyClass) {
        let clzName = cellClass.description()
        var nibName = ""
        if clzName.contains(".") {
            nibName = String(cellClass.description().split(separator: ".").last!)
        }else {
            nibName = cellClass.description()
        }
        base.register(UINib(nibName: nibName, bundle: Bundle(for: cellClass)), forCellReuseIdentifier: "\(cellClass.hash())")
    }
    func dequeueReusableCell<T>(_ cellClass: T.Type,for indexPath: IndexPath) -> T where T: UITableViewCell{
        return base.dequeueReusableCell(withIdentifier: "\(cellClass.hash())", for: indexPath) as! T
    }
}
public extension AriSwift where Base: UICollectionView{
    func register(_ cellClass: AnyClass){
        base.register(cellClass, forCellWithReuseIdentifier: "\(cellClass.hash())")
    }
    
    /// 使用nib注册时 不要使用privite或者fileprivite修饰的类
    /// 如果使用的话cellClass就不单纯了,不能正确的获取nibName
    func registerNib(_ cellClass: AnyClass){
        let clzName = cellClass.description()
        var nibName = ""
        if clzName.contains(".") {
            nibName = String(cellClass.description().split(separator: ".").last!)
        }else {
            nibName = cellClass.description()
        }
        base.register(UINib(nibName: nibName, bundle: Bundle(for: cellClass)), forCellWithReuseIdentifier: "\(cellClass.hash())")
    }
    
    func dequeueReusableCell<T>(_ cellClass: T.Type,for indexPath: IndexPath) -> T where T: UICollectionViewCell{
        
        let reuseIdentifier = "\(cellClass.hash())"
        return base.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! T
    }
}

