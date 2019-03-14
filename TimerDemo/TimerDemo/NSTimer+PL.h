//
//  NSTimer+PL.h
//  TimerDemo
//
//  Created by zpz on 2019/3/14.
//  Copyright © 2019 zpz. All rights reserved.
//

#import <Foundation/Foundation.h>



@interface NSTimer (PL)
/**
 *  创建一个不会造成循环引用的循环执行的Timer
 */
+ (instancetype)plScheduledTimerWithTimeInterval:(NSTimeInterval)ti target:(id)aTarget selector:(SEL)aSelector userInfo:(id)userInfo repeats:(BOOL)repeats;

+ (instancetype)plTimerWithTimeInterval:(NSTimeInterval)ti target:(id)aTarget selector:(SEL)aSelector userInfo:(id)userInfo repeats:(BOOL)repeats;

@end
