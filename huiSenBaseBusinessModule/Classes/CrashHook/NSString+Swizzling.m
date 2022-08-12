//
//  NSString+Swizzling.m
//  TestDemo
//
//  Created by Bruce on 16/12/22.
//  Copyright © 2016年 Bruce. All rights reserved.
//

#import "NSString+Swizzling.h"
#import "NSObject+Swizzling.h"
#import <objc/runtime.h>

@implementation NSString (Swizzling)

+ (void)load{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        @autoreleasepool {
            [objc_getClass("__NSCFConstantString") swizzleMethod:@selector(substringToIndex:) swizzledSelector:@selector(replace_substringToIndex:)];
            [objc_getClass("__NSCFConstantString") swizzleMethod:@selector(objectForKeyedSubscript:) swizzledSelector:@selector(replace_objectForKeyedSubscript:)];
            [objc_getClass("__NSCFConstantString") swizzleMethod:@selector(substringFromIndex:) swizzledSelector:@selector(replace_substringFromIndex:)];
            [objc_getClass("__NSCFConstantString") swizzleMethod:@selector(substringWithRange:) swizzledSelector:@selector(replace_substringWithRange:)];
            [objc_getClass("__NSCFConstantString") swizzleMethod:@selector(rangeOfString:options:range:locale:) swizzledSelector:@selector(replace_rangeOfString:options:range:locale:)];
        }
    });
}

// 当NSString的index越界的时候会启用这个方法
- (NSString *)replace_substringToIndex:(NSUInteger)to {
    if (to > self.length) {
        NSAssert(NO, @"====to超越了字符串的范围====");
        return nil;
    }
    
    return [self replace_substringToIndex:to];
}

// 当NSString的index越界的时候会启用这个方法
- (NSString *)replace_substringFromIndex:(NSUInteger)to {
    if (to > self.length) {
        NSAssert(NO, @"====to超越了字符串的范围====");
        return nil;
    }
    
    return [self replace_substringFromIndex:to];
}

// 当NSString对象调用objectForKeyedSubscript的时候会启用这个方法
- (id)replace_objectForKeyedSubscript:(NSString *)key {
    NSAssert(NO, @"====字符串没有这个（objectForKeyedSubscript）方法====");
    return nil;
}

- (NSString *)replace_substringWithRange:(NSRange)range
{
    if (range.location + range.length <= self.length) {
        return [self replace_substringWithRange:range];
    }else if (range.location < self.length){
        return [self replace_substringWithRange:NSMakeRange(range.location, self.length-range.location)];
    }else{
        NSAssert(NO, @"range越界");
    }
    return nil;
}

- (NSRange)replace_rangeOfString:(NSString *)searchString options:(NSStringCompareOptions)mask range:(NSRange)range locale:(nullable NSLocale *)locale
{
    if (searchString){
        if (range.location + range.length <= self.length) {
            return [self replace_rangeOfString:searchString options:mask range:range locale:locale];
        }else if (range.location < self.length){
            return [self replace_rangeOfString:searchString options:mask range:NSMakeRange(range.location, self.length-range.location) locale:locale];
        }else{
            NSAssert(NO, @"hookRangeOfString:options:range:locale: searchString is nil");
        }
        return NSMakeRange(NSNotFound, 0);
    }else{
        NSAssert(NO, @"hookRangeOfString:options:range:locale: searchString is nil");
        return NSMakeRange(NSNotFound, 0);
    }
}
@end
