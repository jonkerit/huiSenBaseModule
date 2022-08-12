//
//  NSDictionary+Swizzling.m
//  TestDemo
//
//  Created by Bruce on 16/12/22.
//  Copyright © 2016年 Bruce. All rights reserved.
//

#import "NSDictionary+Swizzling.h"
#import "NSObject+Swizzling.h"
#import <objc/runtime.h>

@implementation NSDictionary (Swizzling)

+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        @autoreleasepool {
            [objc_getClass("__NSDictionaryI") swizzleMethod:@selector(objectForKey:) swizzledSelector:@selector(replace_objectForKey:)];
            [objc_getClass("__NSDictionaryI") swizzleMethod:@selector(length) swizzledSelector:@selector(replace_length)];
            
            [objc_getClass("__NSDictionaryM") swizzleMethod:@selector(setObject:forKey:) swizzledSelector:@selector(replace_setObject:forKey:)];
            [objc_getClass("__NSDictionaryM") swizzleMethod:@selector(setObject:forKeyedSubscript:) swizzledSelector:@selector(replace_setObject:forKeyedSubscript:)];
            [objc_getClass("__NSPlaceholderDictionary") swizzleMethod:@selector(initWithObjects:forKeys:count:) swizzledSelector:@selector(replace_initWithObjects:forKeys:count:)];
            [objc_getClass("__NSSingleEntryDictionaryI") swizzleMethod:@selector(length) swizzledSelector:@selector(replaceAgain_length)];

        }
    });
}
// 该的对象不是字典而调用objectForKey方法时调用
- (id)replace_objectForKey:(NSString *)key {
    if ([self isKindOfClass:[NSDictionary class]]) {
        return [self replace_objectForKey:key];
    }else{
        NSAssert(NO, @"====该的对象不是字典，请查证====");
        return nil;
    }
}
// NSDictionary 调用length方法时调用
- (NSUInteger)replace_length {
    NSAssert(NO, @"====字典没有length的方法，有count方法====");
    return 0;
}
// 当字典存入的元素为空的以后调用
- (void)replace_setObject:(nonnull id)anObject forKey:(nonnull id<NSCopying>)aKey{
    if (anObject == nil || aKey == nil) {
        NSAssert(NO, @"====字典存入的对象和key不能为空，但可以为空对象（NSNull）====");
    } else {
        [self replace_setObject:anObject forKey:aKey];
    }
}
// 当字典存入的元素为空的以后调用(tempDict[] =)
- (void)replace_setObject:(nonnull id)anObject forKeyedSubscript:(nonnull id<NSCopying>)aKey{
    if (aKey == nil) {
        NSAssert(NO, @"====字典存入的对象和key不能为空，但可以为空对象（NSNull）====");
    } else {
        [self replace_setObject:anObject forKeyedSubscript:aKey];
    }
}
// 创建字典的时候，原始元素为空的时候调用
-(instancetype)replace_initWithObjects:(id *)objects forKeys:(id<NSCopying> *)keys count:(NSUInteger)count {
    NSUInteger rightCount = 0;
    for (NSUInteger i = 0; i < count; i++) {
        // 这里只做value 为nil的处理 对key为nil不做处理
        if (objects[i] == nil) {
            NSString *errorStr = [NSString stringWithFormat:@"====字典存入key为%@的值为null====",keys[i]];
            NSAssert(NO,errorStr);
            objects[i] = @"";
        }
        rightCount++;
    }
    return  [self replace_initWithObjects:objects forKeys:keys count:rightCount];
}
// NSMutableDictionary 调用length方法时调用
- (NSInteger)replaceAgain_length{
    NSAssert(NO, @"====字典不能当作string====");
    return 0;
}
@end

