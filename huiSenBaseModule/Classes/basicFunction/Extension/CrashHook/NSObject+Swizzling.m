//
//  NSObject+Swizzling.m
//  TestDemo
//
//  Created by Bruce on 16/12/22.
//  Copyright © 2016年 Bruce. All rights reserved.
//

#import "NSObject+Swizzling.h"
#import <objc/runtime.h>

NSString *const NSSafeNotification = @"_NSSafeNotification_";
@interface NSSafeProxy : NSObject
@end
@implementation NSSafeProxy
- (void)dealException:(NSString*)info
{
    NSString* msg = [NSString stringWithFormat:@"NSSafeProxy: %@", info];
    NSAssert(0, msg);
}
@end

@implementation NSObject (Swizzling)

+ (void)swizzleMethod:(SEL)originalSelector swizzledSelector:(SEL)swizzledSelector {
    Class class = [self class];
    //原有方法
    Method originalMethod = class_getInstanceMethod(class, originalSelector);
    //替换原有方法的新方法
    Method swizzledMethod = class_getInstanceMethod(class, swizzledSelector);
    if (!originalMethod) {
        // 如果原方法没有实现，就需要用新的方法替换实现
        class_addMethod(class, originalSelector, method_getImplementation(swizzledMethod),
                        method_getTypeEncoding(swizzledMethod));
        method_setImplementation(swizzledMethod, imp_implementationWithBlock(^(id self, SEL _cmd) {
            NSLog(@"%@方法未实现",NSStringFromSelector(originalSelector));
        }));
        return;
    }
    //先尝试給源SEL添加IMP，这里是为了避免源SEL没有实现IMP的情况
    BOOL didAddMethod = class_addMethod(class,originalSelector,
                                        method_getImplementation(swizzledMethod),
                                        method_getTypeEncoding(swizzledMethod));
    if (didAddMethod) {//添加成功：说明源SEL没有实现IMP，将源SEL的IMP替换到交换SEL的IMP
        class_replaceMethod(class,swizzledSelector,   
                            method_getImplementation(originalMethod),
                            method_getTypeEncoding(originalMethod));
    } else {//添加失败：说明源SEL已经有IMP，直接将两个SEL的IMP交换即可
        method_exchangeImplementations(originalMethod, swizzledMethod);
    }
}

+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        @autoreleasepool {
            [self swizzleMethod:@selector(addObserver:forKeyPath:options:context:) swizzledSelector:@selector(replaceAddObserver:forKeyPath:options:context:)];
            [self swizzleMethod:@selector(removeObserver:forKeyPath:) swizzledSelector: @selector(replaceRemoveObserver:forKeyPath:)];
            [self swizzleMethod:@selector(forwardInvocation:) swizzledSelector: @selector(replaceForwardInvocation:)];
            dispatch_async(dispatch_get_main_queue(), ^{
                [self swizzleMethod:@selector(methodSignatureForSelector:) swizzledSelector: @selector(replaceMethodSignatureForSelector:)];
            });
        }
    });
}
- (void)observeValueForKeyPath:(nullable NSString *)keyPath ofObject:(nullable id)object change:(nullable NSDictionary<NSKeyValueChangeKey, id> *)change context:(nullable void *)context {
    NSAssert(NO, @"%@没实现监听 keyPath: %@", self, keyPath);
}

- (void)replaceAddObserver:(NSObject *)observer forKeyPath:(NSString *)keyPath options:(NSKeyValueObservingOptions)options context:(void *)context {
    if (!observer || !keyPath.length) {
        NSAssert(NO, @"hookAddObserver invalid args: %@", self);
        return;
    }
    @try {
        [self replaceAddObserver:observer forKeyPath:keyPath options:options context:context];
    }
    @catch (NSException *exception) {
        NSLog(@"hookAddObserver ex: %@", [exception callStackSymbols]);
    }
}
- (void)replaceRemoveObserver:(NSObject *)observer forKeyPath:(NSString *)keyPath {
    if (!observer || !keyPath.length) {
        NSAssert(NO, @"hookRemoveObserver invalid args: %@", self);
        return;
    }
    @try {
        [self replaceRemoveObserver:observer forKeyPath:keyPath];
    }
    @catch (NSException *exception) {
        NSLog(@"hookRemoveObserver ex: %@", [exception callStackSymbols]);
    }
}

- (NSMethodSignature*)replaceMethodSignatureForSelector:(SEL)aSelector {
    /* 如果 当前类有methodSignatureForSelector实现，NSObject的实现直接返回nil
     * 子类实现如下：
     *          NSMethodSignature* sig = [super methodSignatureForSelector:aSelector];
     *          if (!sig) {
     *              //当前类的methodSignatureForSelector实现
     *              //如果当前类的methodSignatureForSelector也返回nil
     *          }
     *          return sig;
     */
    NSMethodSignature* sig = [self replaceMethodSignatureForSelector:aSelector];
    if (!sig){
        if (class_getMethodImplementation([NSObject class], @selector(methodSignatureForSelector:))
            != class_getMethodImplementation(self.class, @selector(methodSignatureForSelector:)) ){
            return nil;
        }
        return [NSMethodSignature signatureWithObjCTypes:"v@:@"];
    }
    return sig;
}

- (void)replaceForwardInvocation:(NSInvocation*)invocation {
    NSString* info = [NSString stringWithFormat:@"unrecognized selector [%@] sent to %@", NSStringFromSelector(invocation.selector), NSStringFromClass(self.class)];
    [[NSNotificationCenter defaultCenter] postNotificationName:NSSafeNotification object:self userInfo:@{@"invocation":invocation}];
    @autoreleasepool {
        [[NSSafeProxy new] dealException:info];
    }
}
@end



