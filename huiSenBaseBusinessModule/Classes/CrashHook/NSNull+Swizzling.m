//
//  NSNull+Swizzling.m
//  TestDemo
//
//  Created by Bruce on 16/12/27.
//  Copyright © 2016年 Bruce. All rights reserved.
//

#import "NSNull+Swizzling.h"
#import "NSObject+Swizzling.h"
#import <objc/runtime.h>

@implementation NSNull (Swizzling)

+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        @autoreleasepool {
            [objc_getClass("NSNull") swizzleMethod:@selector(length) swizzledSelector:@selector(replace_length)];
        }
    });
}
// 当NSNull调用length方法的时候会启用这个方法
- (NSInteger)replace_length {
    NSAssert(NO, @"====NSNull没有length====");
    return 0;
}

@end
