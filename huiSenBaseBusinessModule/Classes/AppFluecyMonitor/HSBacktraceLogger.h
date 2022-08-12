//
//  HSBacktraceLogger.h
//  huiSenSmart
//
//  Created by jonkersun on 2021/10/25.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

/*!
 *  @brief  线程堆栈上下文输出
 */
@interface HSBacktraceLogger : NSObject

+ (NSString *)lxd_backtraceOfAllThread;
+ (NSString *)lxd_backtraceOfMainThread;
+ (NSString *)lxd_backtraceOfCurrentThread;
+ (NSString *)lxd_backtraceOfNSThread:(NSThread *)thread;

+ (void)lxd_logMain;
+ (void)lxd_logCurrent;
+ (void)lxd_logAllThread;

@end
NS_ASSUME_NONNULL_END
