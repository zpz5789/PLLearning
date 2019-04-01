//
//  OSSpinLockDemo.m
//  MultithreadingDemo
//
//  Created by zpz on 2019/4/1.
//  Copyright © 2019 zpz. All rights reserved.
//

#import "OSSpinLockDemo.h"
#import <libkern/OSAtomic.h>

@interface OSSpinLockDemo ()
@property (nonatomic, assign) OSSpinLock moneyLock;
@property (nonatomic, assign) OSSpinLock tickLock;
@end

@implementation OSSpinLockDemo
- (instancetype)init
{
    if (self = [super init]) {
        self.moneyLock = OS_SPINLOCK_INIT;
        self.tickLock = OS_SPINLOCK_INIT;
    }
    return self;
}

- (void)__drawMoney
{
    OSSpinLockLock(&_moneyLock);
    [super __drawMoney];
    OSSpinLockUnlock(&_moneyLock);
}

- (void)__saveMoney
{
    OSSpinLockLock(&_moneyLock);
    [super __saveMoney];
    OSSpinLockUnlock(&_moneyLock);
}

- (void)__saleTicket
{
    OSSpinLockLock(&_tickLock);
    [super __saleTicket];
    OSSpinLockUnlock(&_tickLock);
}

@end
