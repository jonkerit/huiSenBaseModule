//
//  HSQiLagMonitor.m
//  huiSenSmart
//
//  Created by jonkersun on 2021/10/22.
//

#import "HSQiLagMonitor.h"
#import "HSBacktraceLogger.h"

#define STUCKMONITORRATE 88
@interface HSQiLagMonitor (){
    dispatch_semaphore_t _dispatchSemaphore;
    CFRunLoopObserverRef _runLoopObserver;
    CFRunLoopActivity _runLoopActivity;
    int _timeoutCount;
}

@end
@implementation HSQiLagMonitor
static HSQiLagMonitor * instance = nil;
+ (void)load {
    [HSQiLagMonitor sharedInstance];
}
+ (HSQiLagMonitor *)sharedInstance {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[self alloc] init];
    });
    return instance;
}

+ (id)allocWithZone:(struct _NSZone *)zone {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [super allocWithZone:zone];
    });
    return instance;
}
static void runLoopObserverCallBack(CFRunLoopObserverRef observer, CFRunLoopActivity activity, void *info){
    HSQiLagMonitor *lagMonitor = (__bridge HSQiLagMonitor*)info;
    lagMonitor->_runLoopActivity = activity;
    dispatch_semaphore_t semaphore = lagMonitor->_dispatchSemaphore;
    dispatch_semaphore_signal(semaphore);
}

- (instancetype)init {
    self =[super init];
    if (self) {
        _dispatchSemaphore = dispatch_semaphore_create(0); //! Dispatch Semaphore保证同步
        CFRunLoopObserverContext context = {0,(__bridge void*)self,NULL,NULL};
        _runLoopObserver = CFRunLoopObserverCreate(kCFAllocatorDefault,
                                                  kCFRunLoopAllActivities,
                                                  YES,
                                                  0,
                                                  &runLoopObserverCallBack,
                                                  &context);
        CFRunLoopAddObserver(CFRunLoopGetMain(), _runLoopObserver, kCFRunLoopCommonModes);
        
        //! 创建子线程监控
         dispatch_async(dispatch_get_global_queue(0, 0), ^{
             //! 子线程开启一个持续的loop用来进行监控
             while (YES) {
                 long semaphoreWait = dispatch_semaphore_wait(self->_dispatchSemaphore, dispatch_time(DISPATCH_TIME_NOW, STUCKMONITORRATE * NSEC_PER_MSEC));
                 if (semaphoreWait != 0) {
                     if (!self->_runLoopObserver) {
                         self->_timeoutCount = 0;
                         self->_dispatchSemaphore = 0;
                         self->_runLoopActivity = 0;
                         return;
                     }
                     //! 两个runloop的状态，BeforeSources和AfterWaiting这两个状态区间时间能够检测到是否卡顿
                     if (self->_runLoopActivity == kCFRunLoopBeforeSources || self->_runLoopActivity == kCFRunLoopAfterWaiting) {
                         //! 出现三次出结果
                         if (++self->_timeoutCount < 3) {
                             continue;
                         }
                         NSLog(@"monitor trigger");
                         dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
                             [HSBacktraceLogger lxd_logMain];

                         });
                     } // end activity
                 }// end semaphore wait
                 self->_timeoutCount = 0;
             }// end while
         });
    }
    return self;
}
@end
