//
//  SerialQueueDemo.m
//  MultithreadingDemo
//
//  Created by zpz on 2019/4/1.
//  Copyright © 2019 zpz. All rights reserved.
//

#import "SerialQueueDemo.h"

@interface SerialQueueDemo ()
@property (strong, nonatomic) dispatch_queue_t ticketQueue;
@property (strong, nonatomic) dispatch_queue_t moneyQueue;
@end

@implementation SerialQueueDemo

- (instancetype)init
{
    if (self = [super init]) {
        self.ticketQueue = dispatch_queue_create("ticketQueue", DISPATCH_QUEUE_SERIAL);
        self.moneyQueue = dispatch_queue_create("moneyQueue", DISPATCH_QUEUE_SERIAL);
    }
    return self;
}

- (void)__drawMoney
{
    dispatch_sync(self.moneyQueue, ^{
        [super __drawMoney];
    });
}

- (void)__saveMoney
{
    dispatch_sync(self.moneyQueue, ^{
        [super __saveMoney];
    });
}

- (void)__saleTicket
{
    dispatch_sync(self.ticketQueue, ^{
        [super __saleTicket];
    });
}

@end
