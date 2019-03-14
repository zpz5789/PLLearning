//
//  NSTimer+Block.m
//  TimerDemo
//
//  Created by zpz on 2019/3/14.
//  Copyright © 2019 zpz. All rights reserved.
//

#import "NSTimer+Block.h"

@implementation NSTimer (Block)


+ (NSTimer *)pl_scheduledTimerWithTimeInterval:(NSTimeInterval)interval
                                         block:(void(^)(void))block
                                       repeats:(BOOL)repeats
{
    NSTimer *timer = [self scheduledTimerWithTimeInterval:interval target:self
                                                 selector:@selector(pl_blockInvoke:)
                                                 userInfo:[block copy]
                                                  repeats:repeats];
    return timer;
}

+ (void)pl_blockInvoke:(NSTimer *)timer
{
    void (^block)(void) = timer.userInfo;
    if (block) {
        block();
    }
}

@end
