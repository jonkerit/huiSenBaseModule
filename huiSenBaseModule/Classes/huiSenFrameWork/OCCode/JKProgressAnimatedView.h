//
//  JKProgressAnimatedView.h
//  JKProgressHUD, https://github.com/JKProgressHUD/JKProgressHUD
//
//  Copyright (c) 2017-2018 Tobias Tiemerding. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JKProgressAnimatedView : UIView

@property (nonatomic, assign) CGFloat radius;
@property (nonatomic, assign) CGFloat strokeThickness;
@property (nonatomic, strong) UIColor *strokeColor;
@property (nonatomic, assign) CGFloat strokeEnd;

@end
