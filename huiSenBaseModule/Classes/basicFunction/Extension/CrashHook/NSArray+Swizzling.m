//
//  NSArray+Swizzling.m
//  TestDemo
//
//  Created by Bruce on 16/12/22.
//  Copyright © 2016年 Bruce. All rights reserved.
//

#import "NSArray+Swizzling.h"
#import <objc/runtime.h>
#import "NSObject+Swizzling.h"

@implementation NSArray (Swizzling)

+ (void)load{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        @autoreleasepool {
            [objc_getClass("__NSArray0") swizzleMethod:@selector(objectAtIndex:) swizzledSelector:@selector(emptyObjectIndex:)];
            [objc_getClass("__NSArray0") swizzleMethod:@selector(objectAtIndexedSubscript:) swizzledSelector:@selector(emptyObjectAtIndexedSubscript:)];
            [objc_getClass("__NSArray0") swizzleMethod:@selector(subarrayWithRange:) swizzledSelector:@selector(replace_SubarrayWithRange:)];

            [objc_getClass("__NSArrayI") swizzleMethod:@selector(objectAtIndex:) swizzledSelector:@selector(arrObjectIndex:)];
            [objc_getClass("__NSArrayI") swizzleMethod:@selector(objectAtIndexedSubscript:) swizzledSelector:@selector(emptyObjectAtIndexedSubscript:)];
            [objc_getClass("__NSArrayI") swizzleMethod:@selector(subarrayWithRange:) swizzledSelector:@selector(replace_SubarrayWithRange:)];

            [objc_getClass("__NSArrayM") swizzleMethod:@selector(objectAtIndex:) swizzledSelector:@selector(mutableObjectIndex:)];
            [objc_getClass("__NSArrayM") swizzleMethod:@selector(insertObject:atIndex:) swizzledSelector:@selector(mutableInsertObject:atIndex:)];
            [objc_getClass("__NSArrayM") swizzleMethod:@selector(objectAtIndexedSubscript:) swizzledSelector:@selector(mutableObjectAtIndexedSubscript:)];
            [objc_getClass("__NSArrayM") swizzleMethod:@selector(subarrayWithRange:) swizzledSelector:@selector(replace_SubarrayWithRange:)];
            [objc_getClass("__NSArrayM") swizzleMethod:@selector(integerValue) swizzledSelector:@selector(replace_integerValue)];
            [objc_getClass("__NSArrayM") swizzleMethod:@selector(replaceObjectAtIndex:withObject:) swizzledSelector:@selector(mutableReplaceObjectAtIndex:withObject:)];

            [objc_getClass("__NSPlaceholderArray") swizzleMethod:@selector(initWithObjects:count:) swizzledSelector:@selector(replace_initWithObjects:count:)];
            [objc_getClass("__NSSingleObjectArrayI") swizzleMethod:@selector(length) swizzledSelector:@selector(replace_length)];

        }
    });
}
// 当NSArray调用为空取index的时候会启用这个方法
- (id)emptyObjectIndex:(NSInteger)index{
    NSAssert(NO, @"====数组为空，请检测====");
    return nil;
}
// 当NSArray调用index越界的时候会启用这个方法
- (id)arrObjectIndex:(NSInteger)index{
    if (index >= self.count || index < 0) {
        NSAssert(NO, @"====数组越界，请检测====");
        return nil;
    }
    return [self arrObjectIndex:index];
}
// 当NSArray调用range越界的时候会启用这个方法
- (NSArray *)replace_SubarrayWithRange:(NSRange)range
{
    @synchronized (self) {
        if (range.location + range.length <= self.count){
            return [self replace_SubarrayWithRange:range];
        }else if (range.location < self.count){
            NSAssert(NO, @"====数组的range越界，请检测====");
            return [self replace_SubarrayWithRange:NSMakeRange(range.location, self.count-range.location)];
        }else{
            NSAssert(NO, @"====数组的range越界，请检测====");
        }
        return nil;
    }
}
// 当NSmutableArray调用index越界的时候会启用这个方法
- (id)mutableObjectIndex:(NSInteger)index{
    if (index >= self.count || index < 0) {
        NSAssert(NO, @"====数组越界，请检测====");
        return nil;
    }
    return [self mutableObjectIndex:index];
}
// 当NSmutableArray插入元素为空的时候会启用这个方法
- (void)mutableInsertObject:(id)object atIndex:(NSUInteger)index{
    if (object) {
        [self mutableInsertObject:object atIndex:index];
    }else{
        NSAssert(NO, @"====插入元素不能为nil====");
    }
}
// 当NSArray调用integerValue的时候会启用这个方法
- (NSInteger)replace_integerValue {
    NSAssert(NO, @"====数组没有integerValue方法====");
    return 0;
}
// 当NSArray调用【i】取值越界的时候会启用这个方法
- (id)emptyObjectAtIndexedSubscript:(NSInteger)index{
    if (index >= self.count || index < 0) {
        NSAssert(NO, @"====数组越界，请检测====");
        return nil;
    }
    return [self emptyObjectAtIndexedSubscript:index];
}
// 当NSmutableArray调用【i】取值越界的时候会启用这个方法
- (id)mutableObjectAtIndexedSubscript:(NSInteger)index{
    if (index >= self.count || index < 0) {
        NSAssert(NO, @"====数组越界，请检测====");
        return nil;
    }
    return [self mutableObjectAtIndexedSubscript:index];
}
// 当NSmutableArray调用mutableReplaceObjectAtIndex替换值、或者替换的对象为空值越界的时候会启用这个方法
- (void)mutableReplaceObjectAtIndex:(NSUInteger)indexs withObject:(id)object{
    if (object != nil && indexs < self.count) {
        [self mutableReplaceObjectAtIndex:indexs withObject:object];
    }
    if (object == nil) {
        NSAssert(NO, @"====替换对象为空，请检测====");
    }
    if (indexs >= self.count) {
        NSAssert(NO, @"====输入位置越界，请检测====");
    }
}
// init 方法创建a数组，原始的元素为空的时候调用
- (instancetype)replace_initWithObjects:(id *)objects count:(NSUInteger)count {
    NSUInteger rightCount = 0;
    for (NSUInteger i = 0; i < count; i++) {
        if (objects[i] == nil) {
            NSString *errorStr = [NSString stringWithFormat:@"====数组存入位置为%ld的值为null====",i];
            NSAssert(NO,errorStr);
            objects[i] = @"";
        }
        rightCount++;
    }
    return  [self replace_initWithObjects:objects count:rightCount];
}
// array调用length方法时调用
- (NSInteger)replace_length{
    NSAssert(NO, @"====NSArray不能当作String====");
    return 0;
}
@end

