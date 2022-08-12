//
//  UIViewController+Swizzling.m
//  Login
//
//  Created by jonker.sun on 2018/7/30.
//  Copyright © 2018年 jonker.sun. All rights reserved.
//

#import "UIViewController+Swizzling.h"
#import <objc/runtime.h>
#import "NSObject+Swizzling.h"

@implementation UIViewController (Swizzling)

+ (void)load{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        @autoreleasepool {
            [objc_getClass("UIViewController") swizzleMethod:@selector(willMoveToParentViewController:) swizzledSelector:@selector(replacedWillMoveToParentViewController:)];
        }
    });
}

/// 当控制器切换的时候调用
/// @param parent 有值说明是进入下一个页面，nil说明是回退
- (void)replacedWillMoveToParentViewController:(UIViewController*)parent{
//    if ([NSStringFromClass([self class]) hasPrefix:@"KS"]) {
//
//    }
//    if (parent) {
//    }
    [self replacedWillMoveToParentViewController:parent];
}
@end
