//
//  HSAppFluecyMonitor.h
//  huiSenSmart
//
//  Created by jonkersun on 2021/10/25.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

#define SHAREDMONITOR [HSAppFluecyMonitor sharedMonitor]

/*!
 *  @brief  监听UI线程卡顿
 */
@interface HSAppFluecyMonitor : NSObject

+ (instancetype)sharedMonitor;

- (void)startMonitoring;
- (void)stopMonitoring;

@end
NS_ASSUME_NONNULL_END
