//
//  PLTimer.m
//  TimerDemo
//
//  Created by zpz on 2019/3/13.
//  Copyright © 2019 zpz. All rights reserved.
//

#import "PLTimer.h"

static NSMutableDictionary *timers_;
dispatch_semaphore_t semaphore_;
@implementation PLTimer

+ (void)initialize
{
    if (self == [PLTimer class]) {
        timers_ = [NSMutableDictionary dictionary];
        semaphore_ = dispatch_semaphore_create(1);
    }
}

+ (NSString *)executeTask:(void(^)(void))task
                    start:(NSTimeInterval)start
                 interval:(NSTimeInterval)interval
                  repeats:(BOOL)repeats
                    async:(BOOL)async
{
    if (!task || start < 0 || (interval <= 0 && repeats)) { return nil; }
    
    dispatch_queue_t queue = async ? dispatch_get_global_queue(0, 0) : dispatch_get_main_queue();
    
    dispatch_source_t timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
    
    dispatch_semaphore_wait(semaphore_, DISPATCH_TIME_FOREVER);
    // 定时器的唯一标识
    NSString *name = [NSString stringWithFormat:@"%zd", timers_.count];
    [timers_ setObject:timer forKey:name];
    dispatch_semaphore_signal(semaphore_);

    dispatch_source_set_timer(timer, dispatch_time(DISPATCH_WALLTIME_NOW, start * NSEC_PER_SEC), interval * NSEC_PER_SEC, 0);
    // 传入block作为定时任务
        dispatch_source_set_event_handler(timer, ^{
            task();
            if (!repeats) {
                [self cancelTask:name];
            }
        });
    dispatch_resume(timer);
    return name;
}



+ (NSString *)executeTask:(id)target
                 selector:(SEL)selector
                    start:(NSTimeInterval)start
                 interval:(NSTimeInterval)interval
                  repeats:(BOOL)repeats
                    async:(BOOL)async
{
    if (!target || !selector) { return nil; }
    
    return [self executeTask:^{
        if ([target respondsToSelector:selector]) {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
            [target performSelector:selector];
#pragma clang diagnostic pop
        }
    } start:start interval:interval repeats:repeats async:async];
}



+ (void)cancelTask:(NSString *)name
{
    if (name.length == 0) return;
    
    dispatch_semaphore_wait(semaphore_, DISPATCH_TIME_FOREVER);
    dispatch_source_t timer = timers_[name];
    if (timer) {
        dispatch_source_cancel(timer);
        [timers_ removeObjectForKey:name];
    }
    dispatch_semaphore_signal(semaphore_);
}


@end
