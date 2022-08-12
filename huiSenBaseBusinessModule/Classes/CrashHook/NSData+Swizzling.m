//
//  NSData+Swizzling.m
//  huiSenSmart
//
//  Created by jonkersun on 2021/6/3.
//

#import "NSData+Swizzling.h"
#import "NSObject+Swizzling.h"
#import <objc/runtime.h>

@implementation NSData (Swizzling)

+ (void)load{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        @autoreleasepool {
            [objc_getClass("NSConcreteData") swizzleMethod:@selector(subdataWithRange:) swizzledSelector:@selector(replaceSubdataWithRange:)];
            [objc_getClass("NSConcreteData") swizzleMethod:@selector(rangeOfData:options:range:) swizzledSelector:@selector(replaceRangeOfData:options:range:)];
            [objc_getClass("NSConcreteMutableData") swizzleMethod:@selector(subdataWithRange:) swizzledSelector:@selector(replaceSubdataWithRange:)];
            [objc_getClass("NSConcreteMutableData") swizzleMethod:@selector(rangeOfData:options:range:) swizzledSelector:@selector(replaceRangeOfData:options:range:)];
            [objc_getClass("_NSZeroData") swizzleMethod:@selector(subdataWithRange:) swizzledSelector:@selector(replaceSubdataWithRange:)];
            [objc_getClass("_NSZeroData") swizzleMethod:@selector(rangeOfData:options:range:) swizzledSelector:@selector(replaceRangeOfData:options:range:)];
            [objc_getClass("_NSInlineData") swizzleMethod:@selector(subdataWithRange:) swizzledSelector:@selector(replaceSubdataWithRange:)];
            [objc_getClass("_NSInlineData") swizzleMethod:@selector(rangeOfData:options:range:) swizzledSelector:@selector(replaceRangeOfData:options:range:)];
            [objc_getClass("__NSCFData") swizzleMethod:@selector(subdataWithRange:) swizzledSelector:@selector(replaceSubdataWithRange:)];
            [objc_getClass("__NSCFData") swizzleMethod:@selector(rangeOfData:options:range:) swizzledSelector:@selector(replaceRangeOfData:options:range:)];
        }
    });
}

- (NSData*)replaceSubdataWithRange:(NSRange)range
{
    if (range.location + range.length <= self.length){
        return [self replaceSubdataWithRange:range];
    }else if (range.location < self.length){
        return [self replaceSubdataWithRange:NSMakeRange(range.location, self.length-range.location)];
    }else{
        NSAssert(NO, @"====range越界====");
    }
    return nil;
}

- (NSRange)replaceRangeOfData:(NSData *)dataToFind options:(NSDataSearchOptions)mask range:(NSRange)searchRange
{
    if (dataToFind){
        if (searchRange.location + searchRange.length <= self.length) {
            return [self replaceRangeOfData:dataToFind options:mask range:searchRange];
        }else if (searchRange.location < self.length){
            return [self replaceRangeOfData:dataToFind options:mask range:NSMakeRange(searchRange.location, self.length - searchRange.location) ];
        }else{
            NSAssert(NO, @"====dataToFind未找到====");
        }
        return NSMakeRange(NSNotFound, 0);
    }else{
        NSAssert(NO, @"====dataToFind未找到====");
        return NSMakeRange(NSNotFound, 0);
    }
}
@end
