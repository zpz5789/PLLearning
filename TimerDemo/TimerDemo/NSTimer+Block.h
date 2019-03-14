//
//  NSTimer+Block.h
//  TimerDemo
//
//  Created by zpz on 2019/3/14.
//  Copyright © 2019 zpz. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSTimer (Block)
+ (NSTimer *)pl_scheduledTimerWithTimeInterval:(NSTimeInterval)interval
                                          block:(void(^)(void))block
                                        repeats:(BOOL)repeats;

@end

NS_ASSUME_NONNULL_END
