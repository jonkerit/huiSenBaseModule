//
//  NSUserDefaults+Swizzling.m
//  huiSenSmart
//
//  Created by jonkersun on 2021/6/3.
//

#import "NSUserDefaults+Swizzling.h"
#import "NSObject+Swizzling.h"
#import <objc/runtime.h>

@implementation NSUserDefaults (Swizzling)

+ (void)load{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        @autoreleasepool {
            [objc_getClass("NSUserDefaults") swizzleMethod:@selector(objectForKey:) swizzledSelector:@selector(replaceObjectForKey:)];
            [objc_getClass("NSUserDefaults") swizzleMethod:@selector(setObject:forKey:) swizzledSelector:@selector(replaceSetObject:forKey:)];
            [objc_getClass("NSUserDefaults") swizzleMethod:@selector(removeObjectForKey:) swizzledSelector:@selector(replaceRemoveObjectForKey:)];
        }
    });
}

- (id)replaceObjectForKey:(NSString *)defaultName
{
    if (defaultName) {
        return [self replaceObjectForKey:defaultName];
    }
    return nil;
}

- (void)replaceSetObject:(id)value forKey:(NSString*)aKey
{
    if (aKey) {
        [self replaceSetObject:value forKey:aKey];
    } else {
        NSAssert(NO, @"NSUserDefaults invalid args hookSetObject:[%@] forKey:[%@]", value, aKey);
    }
}

- (void)replaceRemoveObjectForKey:(NSString*)aKey
{
    if (aKey) {
        [self replaceRemoveObjectForKey:aKey];
    } else {
        NSAssert(NO, @"NSUserDefaults invalid args hookRemoveObjectForKey:[%@]", aKey);
    }
}
@end
