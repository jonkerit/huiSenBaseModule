//
//  NSNumber+Swizzling.m
//  coldlar
//
//  Created by jonker.sun on 2019/3/13.
//  Copyright © 2019年 BiChuang. All rights reserved.
//

#import "NSNumber+Swizzling.h"
#import "NSObject+Swizzling.h"
#import <objc/runtime.h>

@implementation NSNumber (Swizzling)
+ (void)load{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        @autoreleasepool {
            [objc_getClass("__NSCFNumber") swizzleMethod:@selector(length) swizzledSelector:@selector(replace_length)];
            [objc_getClass("__NSCFNumber") swizzleMethod:@selector(objectForKeyedSubscript:) swizzledSelector:@selector(replace_objectForKeyedSubscript:)];
        }
    });
}
// 当NSNumber对象调用length方法的时候会启用这个方法
- (id)replace_length{
    NSAssert(NO, @"====NSCFNumber不能当作String====");
    return 0;
}
// 当NSString对象调用objectForKeyedSubscript的时候会启用这个方法
- (id)replace_objectForKeyedSubscript:(NSString *)key {
    NSAssert(NO, @"====字符串没有这个（objectForKeyedSubscript）方法====");
    return @"";
}

@end
