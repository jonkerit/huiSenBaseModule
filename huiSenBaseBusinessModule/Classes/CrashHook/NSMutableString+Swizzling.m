//
//  NSMutableString+Swizzling.m
//  TestDemo
//
//  Created by Bruce on 16/12/22.
//  Copyright © 2016年 Bruce. All rights reserved.
//

#import "NSMutableString+Swizzling.h"
#import <objc/runtime.h>
#import "NSObject+Swizzling.h"

@implementation NSMutableString (Swizzling)

+ (void)load{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        @autoreleasepool {
            [objc_getClass("__NSCFString") swizzleMethod:@selector(replaceCharactersInRange:withString:) swizzledSelector:@selector(alert_replaceCharactersInRange:withString:)];
            [objc_getClass("__NSCFString") swizzleMethod:@selector(objectForKeyedSubscript:) swizzledSelector:@selector(replace_objectForKeyedSubscript:)];
            [objc_getClass("__NSCFString") swizzleMethod:@selector(attributedSubstringFromRange:) swizzledSelector:@selector(replaceAttributedSubstringFromRange:)];
            [objc_getClass("__NSCFString") swizzleMethod:@selector(attribute:atIndex:effectiveRange:) swizzledSelector:@selector(replaceAttribute:atIndex:effectiveRange:)];
            [objc_getClass("__NSCFString") swizzleMethod:@selector(enumerateAttribute:inRange:options:usingBlock:) swizzledSelector:@selector(replaceEnumerateAttribute:inRange:options:usingBlock:)];
            [objc_getClass("__NSCFString") swizzleMethod:@selector(enumerateAttributesInRange:options:usingBlock:) swizzledSelector:@selector(replaceEnumerateAttributesInRange:options:usingBlock:)];
            [objc_getClass("__NSCFString") swizzleMethod:@selector(rangeOfString:options:range:locale:) swizzledSelector:@selector(replaceRangeOfString:options:range:locale:)];
        }
    });
}
// 字符串替换范围越界的时候调用
- (void)alert_replaceCharactersInRange:(NSRange)range withString:(NSString *)aString {
    if ((range.location + range.length) > self.length) {
        NSAssert(NO, @"====range超越了字符串的范围====");
    }else {
        [self alert_replaceCharactersInRange:range withString:aString];
    }
}
// string调用objectForKeyedSubscript的时候调用
- (id)replace_objectForKeyedSubscript:(NSString *)key {
    NSAssert(NO, @"====字符串没有这个（objectForKeyedSubscript）方法====");
    return nil;
}
- (NSAttributedString *)replaceAttributedSubstringFromRange:(NSRange)range {
    @synchronized (self) {
        if (range.location + range.length <= self.length) {
            return [self replaceAttributedSubstringFromRange:range];
        }else if (range.location < self.length){
            return [self replaceAttributedSubstringFromRange:NSMakeRange(range.location, self.length-range.location)];
        }else{
            NSAssert(NO, @"====range越界====");
        }
        return nil;
    }
}

- (id)replaceAttribute:(NSAttributedStringKey)attrName atIndex:(NSUInteger)location effectiveRange:(nullable NSRangePointer)range
{
    @synchronized (self) {
        if (location < self.length){
            return [self replaceAttribute:attrName atIndex:location effectiveRange:range];
        }else{
            NSAssert(NO, @"====location越界====");
            return nil;
        }
    }
}

- (void)replaceEnumerateAttribute:(NSString *)attrName inRange:(NSRange)range options:(NSAttributedStringEnumerationOptions)opts usingBlock:(void (^)(id _Nullable, NSRange, BOOL * _Nonnull))block
{
    if (range.location + range.length <= self.length) {
        [self replaceEnumerateAttribute:attrName inRange:range options:opts usingBlock:block];
    }else if (range.location < self.length){
        [self replaceEnumerateAttribute:attrName inRange:NSMakeRange(range.location, self.length-range.location) options:opts usingBlock:block];
    }else{
        NSAssert(NO, @"====range越界====");
    }
}
- (void)replaceEnumerateAttributesInRange:(NSRange)range options:(NSAttributedStringEnumerationOptions)opts usingBlock:(void (^)(NSDictionary<NSString*,id> * _Nonnull, NSRange, BOOL * _Nonnull))block
{
    if (range.location + range.length <= self.length) {
        [self replaceEnumerateAttributesInRange:range options:opts usingBlock:block];
    }else if (range.location < self.length){
        [self replaceEnumerateAttributesInRange:NSMakeRange(range.location, self.length-range.location) options:opts usingBlock:block];
    }else{
        NSAssert(NO, @"====range越界====");
    }
}

- (NSRange)replaceRangeOfString:(NSString *)searchString options:(NSStringCompareOptions)mask range:(NSRange)range locale:(nullable NSLocale *)locale
{
    @synchronized (self) {
        if (searchString){
            if (range.location + range.length <= self.length) {
                return [self replaceRangeOfString:searchString options:mask range:range locale:locale];
            }else if (range.location < self.length){
                return [self replaceRangeOfString:searchString options:mask range:NSMakeRange(range.location, self.length-range.location) locale:locale];
            }else{
                NSAssert(NO, @"hookRangeOfString:options:range:locale: searchString is nil");
            }
            return NSMakeRange(NSNotFound, 0);
        }else{
            NSAssert(NO, @"hookRangeOfString:options:range:locale: searchString is nil");
            return NSMakeRange(NSNotFound, 0);
        }
    }
}
@end
