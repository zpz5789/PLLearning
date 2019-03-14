//
//  NSTimer+PL.m
//  TimerDemo
//
//  Created by zpz on 2019/3/14.
//  Copyright © 2019 zpz. All rights reserved.
//

#import "NSTimer+PL.h"

@interface PLTimerProxy : NSObject
@property (nonatomic, weak) id target;
@property (nonatomic, assign) SEL selector;
@property (nonatomic, weak) NSTimer *timer;
@end

@implementation PLTimerProxy

- (void)plTimerTargetAction:(NSTimer *)timer
{
    // 通过判断有没有target来释放定时器
    if (self.target) {
        [self.target performSelector:self.selector withObject:timer afterDelay:0.0];
    } else {
        [self.timer invalidate];
        self.timer = nil;
    }
}

@end

@implementation NSTimer (PL)
+ (instancetype)plScheduledTimerWithTimeInterval:(NSTimeInterval)ti target:(id)aTarget selector:(SEL)aSelector userInfo:(id)userInfo repeats:(BOOL)repeats
{
    PLTimerProxy *proxy = [[PLTimerProxy alloc] init];
    proxy.target = aTarget;
    proxy.selector = aSelector;
    
    NSTimer *timer = [NSTimer scheduledTimerWithTimeInterval:ti target:proxy selector:@selector(plTimerTargetAction:) userInfo:userInfo repeats:repeats];
    proxy.timer = timer;
    return timer;
}

+ (instancetype)plTimerWithTimeInterval:(NSTimeInterval)ti target:(id)aTarget selector:(SEL)aSelector userInfo:(id)userInfo repeats:(BOOL)repeats
{
    PLTimerProxy *proxy = [[PLTimerProxy alloc] init];
    proxy.target = aTarget;
    proxy.selector = aSelector;

    NSTimer *timer = [NSTimer timerWithTimeInterval:ti target:proxy selector:@selector(plTimerTargetAction:) userInfo:userInfo repeats:repeats];
    [[NSRunLoop currentRunLoop] addTimer:timer forMode:NSRunLoopCommonModes];
    proxy.timer = timer;
    return nil;
}


@end
