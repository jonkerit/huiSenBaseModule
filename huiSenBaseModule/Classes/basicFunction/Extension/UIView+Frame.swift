//
//  UIView+Frame.swift
//  huiSenSmart
//
//  Created by jonkersun on 2021/4/14.
//  Copyright © 2021 Grand. All rights reserved.
//


import UIKit
public extension AriSwift where Base: UIView {
    var x: CGFloat {
        get{
            return self.base.frame.origin.x
        }
        set{
            var rect = self.base.frame
            rect.origin.x = newValue
            self.base.frame = rect
        }
    }
    
    var y: CGFloat {
        get{
            return self.base.frame.origin.y
        }
        set{
            var rect = self.base.frame
            rect.origin.y = newValue
            self.base.frame = rect
        }
    }
    
    var width: CGFloat {
        get{
            return self.base.frame.size.width
        }
        set{
            var rect = self.base.frame
            rect.size.width = newValue
            self.base.frame = rect
        }
    }
    
    var height: CGFloat {
        get{
            return self.base.frame.size.height
        }
        set{
            var rect = self.base.frame
            rect.size.height = newValue
            self.base.frame = rect
        }
    }
    
    var size: CGSize {
        get{
            return self.base.frame.size
        }
        set{
            var rect = self.base.frame
            rect.size = newValue
            self.base.frame = rect
        }
    }
    
    var origin: CGPoint {
        get{
            return self.base.frame.origin
        }
        set{
            var rect = self.base.frame
            rect.origin = newValue
            self.base.frame = rect
        }
    }
    
    var centerX: CGFloat {
        get{
            return self.base.center.x
        }
        set{
            var point = self.base.center
            point.x = newValue
            self.base.center = point
        }
    }
    
    var centerY: CGFloat {
        get{
            return self.base.center.y
        }
        set{
            var point = self.base.center
            point.y = newValue
            self.base.center = point
        }
    }
    
    var bottom: CGFloat {
        return self.y + self.height
    }
    var right: CGFloat {
        return self.x + self.width
    }
    
}
