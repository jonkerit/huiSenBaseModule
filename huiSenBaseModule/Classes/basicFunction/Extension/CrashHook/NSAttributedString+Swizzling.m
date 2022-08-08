//
//  NSAttributedString+Swizzling.m
//  huiSenSmart
//
//  Created by jonkersun on 2021/6/3.
//

#import "NSAttributedString+Swizzling.h"
#import <objc/runtime.h>
#import "NSObject+Swizzling.h"

@implementation NSAttributedString (Swizzling)

+ (void)load{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        @autoreleasepool {
            [objc_getClass("NSConcreteMutableAttributedString") swizzleMethod:@selector(attributedSubstringFromRange:) swizzledSelector:@selector(replaceAttributedSubstringFromRange:)];
            [objc_getClass("NSConcreteMutableAttributedString") swizzleMethod:@selector(attribute:atIndex:effectiveRange:) swizzledSelector:@selector(replaceAttribute:atIndex:effectiveRange:)];
            [objc_getClass("NSConcreteMutableAttributedString") swizzleMethod:@selector(enumerateAttribute:inRange:options:usingBlock:) swizzledSelector:@selector(replaceEnumerateAttribute:inRange:options:usingBlock:)];
            [objc_getClass("NSConcreteMutableAttributedString") swizzleMethod:@selector(enumerateAttributesInRange:options:usingBlock:) swizzledSelector:@selector(replaceEnumerateAttributesInRange:options:usingBlock:)];
        }
    });
}

- (id)replaceAttribute:(NSAttributedStringKey)attrName atIndex:(NSUInteger)location effectiveRange:(nullable NSRangePointer)range
{
    if (location < self.length){
        return [self replaceAttribute:attrName atIndex:location effectiveRange:range];
    }else{
        NSAssert(NO, @"====range越界====");
        return nil;
    }
}
- (NSAttributedString *)replaceAttributedSubstringFromRange:(NSRange)range {
    if (range.location + range.length <= self.length) {
        return [self replaceAttributedSubstringFromRange:range];
    }else if (range.location < self.length){
        return [self replaceAttributedSubstringFromRange:NSMakeRange(range.location, self.length-range.location)];
    }else{
        NSAssert(NO, @"====range越界====");
        return nil;
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

@end
