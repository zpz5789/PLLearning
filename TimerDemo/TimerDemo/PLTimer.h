//
//  PLTimer.h
//  TimerDemo
//
//  Created by zpz on 2019/3/13.
//  Copyright © 2019 zpz. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface PLTimer : NSObject

/**
 block方式执行定时器

 @param task 任务
 @param start 开始时间
 @param interval 间隔时间
 @param repeats 是否重复调用
 @param async 是否异步
 @return 任务唯一标识
 */
+ (NSString *)executeTask:(void(^)(void))task
              start:(NSTimeInterval)start
           interval:(NSTimeInterval)interval
            repeats:(BOOL)repeats
              async:(BOOL)async;


/**
 selector方式执行定时器

 @param target 执行方法目标对象
 @param selector 定时器回调方法
 @param start 开始时间
 @param interval 间隔时间
 @param repeats 是否重复
 @param async 是否异步
 @return 任务唯一标识
 */
+ (NSString *)executeTask:(id)target
           selector:(SEL)selector
              start:(NSTimeInterval)start
           interval:(NSTimeInterval)interval
            repeats:(BOOL)repeats
              async:(BOOL)async;



/**
 取消任务

 @param name 任务唯一标识
 */
+ (void)cancelTask:(NSString *)name;

@end

NS_ASSUME_NONNULL_END
