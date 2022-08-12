//
//  NSOrderedSet+Swizzling.m
//  huiSenSmart
//
//  Created by jonkersun on 2021/6/3.
//

#import "NSOrderedSet+Swizzling.h"
#import "NSObject+Swizzling.h"
#import <objc/runtime.h>

@implementation NSOrderedSet (Swizzling)

+ (void)load{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        @autoreleasepool {
            [objc_getClass("__NSOrderedSetI") swizzleMethod:@selector(objectAtIndex:) swizzledSelector:@selector(replaceObjectAtIndex:)];
        }
    });
}

- (id)replaceObjectAtIndex:(NSUInteger)idx
{
    @synchronized (self) {
        if (idx < self.count){
            return [self replaceObjectAtIndex:idx];
        }else{
            NSAssert(NO, @"idx越界");
        }
        return nil;
    }
}
@end
