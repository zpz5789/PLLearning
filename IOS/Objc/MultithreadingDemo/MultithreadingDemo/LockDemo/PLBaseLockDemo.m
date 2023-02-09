//
//  PLBaseLockDemo.m
//  MultithreadingDemo
//
//  Created by zpz on 2019/3/23.
//  Copyright © 2019 zpz. All rights reserved.
//

#import "PLBaseLockDemo.h"
@interface PLBaseLockDemo()
@property (nonatomic, assign) int money;
@property (assign, nonatomic) int ticketsCount;
@end

@implementation PLBaseLockDemo
- (void)otherTest{};

- (void)moneyTest
{
    self.money = 1000;
    
    dispatch_queue_t queue = dispatch_get_global_queue(0, 0);
    
    dispatch_async(queue, ^{
        for (int i = 0; i < 10; i++) {
            [self __saveMoney];
        }
    });
    
    dispatch_async(queue, ^{
        for (int i = 0; i < 10; i++) {
            [self __drawMoney];
        }
    });
}


- (void)__saveMoney
{
    int oldMoney = self.money;
    sleep(.2);
    oldMoney += 200;
    self.money = oldMoney;
    
    NSLog(@"存200，还剩%d元 - %@", oldMoney, [NSThread currentThread]);
}


- (void)__drawMoney
{
    int oldMoney = self.money;
    sleep(.2);
    oldMoney -= 100;
    self.money = oldMoney;
    
    NSLog(@"取100，还剩%d元 - %@", oldMoney, [NSThread currentThread]);
}

- (void)ticketTest
{
    self.ticketsCount = 15;
    
    dispatch_queue_t queue = dispatch_get_global_queue(0, 0);
    
    dispatch_async(queue, ^{
        for (int i = 0; i < 5; i++) {
            [self __saleTicket];
        }
    });
    
    dispatch_async(queue, ^{
        for (int i = 0; i < 5; i++) {
            [self __saleTicket];
        }
    });
    
    dispatch_async(queue, ^{
        for (int i = 0; i < 5; i++) {
            [self __saleTicket];
        }
    });
}


- (void)__saleTicket
{
    int oldTicketsCount = self.ticketsCount;
    sleep(.2);
    oldTicketsCount--;
    self.ticketsCount = oldTicketsCount;
    NSLog(@"还剩%d张票 - %@", oldTicketsCount, [NSThread currentThread]);
}

@end
