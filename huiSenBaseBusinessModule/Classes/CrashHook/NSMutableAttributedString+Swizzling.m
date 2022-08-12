//
//  NSMutableAttributedString+Swizzling.m
//  TestDemo
//
//  Created by Bruce on 16/12/22.
//  Copyright © 2016年 Bruce. All rights reserved.
//

#import "NSMutableAttributedString+Swizzling.h"
#import <objc/runtime.h>
#import "NSObject+Swizzling.h"

@implementation NSMutableAttributedString (Swizzling)

+ (void)load{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        @autoreleasepool {
            [objc_getClass("NSConcreteMutableAttributedString") swizzleMethod:@selector(attributedSubstringFromRange:) swizzledSelector:@selector(replaceAttributedSubstringFromRange:)];
            [objc_getClass("NSConcreteMutableAttributedString") swizzleMethod:@selector(attribute:atIndex:effectiveRange:) swizzledSelector:@selector(replaceAttribute:atIndex:effectiveRange:)];
            [objc_getClass("NSConcreteMutableAttributedString") swizzleMethod:@selector(addAttribute:value:range:) swizzledSelector:@selector(replaceAddAttribute:value:range:)];
            [objc_getClass("NSConcreteMutableAttributedString") swizzleMethod:@selector(addAttributes:range:) swizzledSelector:@selector(replaceAddAttributes:range:)];
            [objc_getClass("NSConcreteMutableAttributedString") swizzleMethod:@selector(setAttributes:range:) swizzledSelector:@selector(replaceSetAttributes:range:)];
            [objc_getClass("NSConcreteMutableAttributedString") swizzleMethod:@selector(removeAttribute:range:) swizzledSelector:@selector(replaceRemoveAttribute:range:)];
            [objc_getClass("NSConcreteMutableAttributedString") swizzleMethod:@selector(deleteCharactersInRange:) swizzledSelector:@selector(replaceDeleteCharactersInRange:)];
            [objc_getClass("NSConcreteMutableAttributedString") swizzleMethod:@selector(replaceCharactersInRange:withString:) swizzledSelector:@selector(alert_replaceCharactersInRange:withString:)];
            [objc_getClass("NSConcreteMutableAttributedString") swizzleMethod:@selector(replaceCharactersInRange:withAttributedString:) swizzledSelector:@selector(alert_replaceCharactersInRange:withAttributedString:)];
            [objc_getClass("NSConcreteMutableAttributedString") swizzleMethod:@selector(enumerateAttribute:inRange:options:usingBlock:) swizzledSelector:@selector(replaceEnumerateAttribute:inRange:options:usingBlock:)];
            [objc_getClass("NSConcreteMutableAttributedString") swizzleMethod:@selector(enumerateAttributesInRange:options:usingBlock:) swizzledSelector:@selector(replaceEnumerateAttributesInRange:options:usingBlock:)];

        }
    });
}
// 当NSMutableAttributedString调用replaceCharactersInRange:withString:越界的时候会启用这个方法
- (void)alert_replaceCharactersInRange:(NSRange)range withString:(NSString *)aString {
    if ((range.location + range.length) > self.length) {
        NSAssert(NO, @"====字符串越界====");
    }else {
        [self alert_replaceCharactersInRange:range withString:aString];
    }
}
// 当NSMutableAttributedString调用replaceCharactersInRange:withString:越界的时候会启用这个方法
- (void)alert_replaceCharactersInRange:(NSRange)range withAttributedString:(NSString *)aString {
    if ((range.location + range.length) > self.length) {
        NSAssert(NO, @"====字符串越界====");
    }else {
        [self alert_replaceCharactersInRange:range withAttributedString:aString];
    }
}
// 当range越界会调用
- (NSAttributedString *)replaceAttributedSubstringFromRange:(NSRange)range {
    @synchronized (self) {
        if (range.location + range.length <= self.length) {
            return [self replaceAttributedSubstringFromRange:range];
        }else if (range.location < self.length){
            return [self replaceAttributedSubstringFromRange:NSMakeRange(range.location, self.length-range.location)];
        }else{
            NSAssert(NO, @"====字符串越界====");
        }
        return nil;
    }
}
// 当location越界会调用
- (id)replaceAttribute:(NSAttributedStringKey)attrName atIndex:(NSUInteger)location effectiveRange:(nullable NSRangePointer)range
{
    if (location < self.length){
        return [self replaceAttribute:attrName atIndex:location effectiveRange:range];
    }else{
        NSAssert(NO, @"====location越界====");
        return nil;
    }
}

// 当range越界会调用
- (void)replaceAddAttribute:(id)name value:(id)value range:(NSRange)range {
    if (!range.length) {
        [self replaceAddAttribute:name value:value range:range];
    }else if (value){
        if (range.location + range.length <= self.length) {
            [self replaceAddAttribute:name value:value range:range];
        }else if (range.location < self.length){
            [self replaceAddAttribute:name value:value range:NSMakeRange(range.location, self.length-range.location)];
        }else{
            NSAssert(NO, @"====range越界====");
        }
    }else {
        NSAssert(NO, @"====range越界====");
    }
}

// 当range越界会调用
- (void)replaceAddAttributes:(NSDictionary<NSString *,id> *)attrs range:(NSRange)range {
    if (!range.length) {
        [self replaceAddAttributes:attrs range:range];
    }else if (attrs){
        if (range.location + range.length <= self.length) {
            [self replaceAddAttributes:attrs range:range];
        }else if (range.location < self.length){
            [self replaceAddAttributes:attrs range:NSMakeRange(range.location, self.length-range.location)];
        }else{
            NSAssert(NO, @"====range越界====");
        }
    }else{
        NSAssert(NO, @"====range越界====");
    }
}

// 当range越界会调用
- (void)replaceSetAttributes:(NSDictionary<NSString *,id> *)attrs range:(NSRange)range {
    if (!range.length) {
        [self replaceSetAttributes:attrs range:range];
    }else if (attrs){
        if (range.location + range.length <= self.length) {
            [self replaceSetAttributes:attrs range:range];
        }else if (range.location < self.length){
            [self replaceSetAttributes:attrs range:NSMakeRange(range.location, self.length-range.location)];
        }else{
            NSAssert(NO, @"====range越界====");
        }
    }else{
        NSAssert(NO, @"====range越界====");
    }
}

// 当range越界会调用
- (void)replaceRemoveAttribute:(id)name range:(NSRange)range {
    @synchronized (self) {
        if (!range.length) {
            [self replaceRemoveAttribute:name range:range];
        }else if (name){
            if (range.location + range.length <= self.length) {
                [self replaceRemoveAttribute:name range:range];
            }else if (range.location < self.length) {
                [self replaceRemoveAttribute:name range:NSMakeRange(range.location, self.length-range.location)];
            }else{
                NSAssert(NO, @"====range越界====");
            }
        }else{
            NSAssert(NO, @"====range越界====");
        }
    }
}

// 当range越界会调用
- (void)replaceDeleteCharactersInRange:(NSRange)range {
    if (range.location + range.length <= self.length) {
        [self replaceDeleteCharactersInRange:range];
    }else if (range.location < self.length) {
        [self replaceDeleteCharactersInRange:NSMakeRange(range.location, self.length-range.location)];
    }else{
        NSAssert(NO, @"====range越界====");
    }
}

// 当range越界会调用
- (void)replaceEnumerateAttribute:(NSString*)attrName inRange:(NSRange)range options:(NSAttributedStringEnumerationOptions)opts usingBlock:(void (^)(id _Nullable, NSRange, BOOL * _Nonnull))block
{
    if (range.location + range.length <= self.length) {
        [self replaceEnumerateAttribute:attrName inRange:range options:opts usingBlock:block];
    }else if (range.location < self.length){
        [self replaceEnumerateAttribute:attrName inRange:NSMakeRange(range.location, self.length-range.location) options:opts usingBlock:block];
    }else{
        NSAssert(NO, @"====range越界====");
    }
}

// 当range越界会调用
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
@end
