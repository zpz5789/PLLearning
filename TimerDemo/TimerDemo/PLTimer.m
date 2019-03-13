//
//  PLTimer.m
//  TimerDemo
//
//  Created by zpz on 2019/3/13.
//  Copyright © 2019 zpz. All rights reserved.
//

#import "PLTimer.h"

@implementation PLTimer

+ (NSString *)executeTask:(void(^)(void))task
                    start:(NSTimeInterval)start
                 interval:(NSTimeInterval)interval
                  repeats:(BOOL)repeats
                    async:(BOOL)async
{
    if (!task || start < 0 || (interval <= 0 && repeats)) {
        return nil;
    }
    
    return nil;
}



+ (NSString *)executeTask:(id)target
                 selector:(SEL)selector
                    start:(NSTimeInterval)start
                 interval:(NSTimeInterval)interval
                  repeats:(BOOL)repeats
                    async:(BOOL)async
{
    return nil;
}



+ (void)cancelTask:(NSString *)name
{
    
}


@end
