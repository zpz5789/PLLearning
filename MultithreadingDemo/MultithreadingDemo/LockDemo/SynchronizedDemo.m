//
//  SynchronizedDemo.m
//  MultithreadingDemo
//
//  Created by zpz on 2019/4/1.
//  Copyright © 2019 zpz. All rights reserved.
//

#import "SynchronizedDemo.h"

@interface SynchronizedDemo ()

@end

@implementation SynchronizedDemo

- (void)__drawMoney
{
    @synchronized([self class]) {
        [super __drawMoney];
    }
    // 通过 [self class] 去底层一个map里面去查找到一个 data,  date有个成员变量 pthead_mutex_t递归锁。
}

- (void)__saveMoney
{
    @synchronized([self class]) { // objc_sync_enter
        [super __saveMoney];
    } // objc_sync_exit
}

- (void)__saleTicket
{
    static NSObject *lock;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        lock = [[NSObject alloc] init];
    });
    
    @synchronized(lock) {
        [super __saleTicket];
    }
}

- (void)otherTest
{
    @synchronized([self class]) {
        NSLog(@"123");
        [self otherTest];
    }
}
@end
