//
//  PLBaseLockDemo.h
//  MultithreadingDemo
//
//  Created by zpz on 2019/3/23.
//  Copyright © 2019 zpz. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface PLBaseLockDemo : NSObject

- (void)moneyTest;
- (void)ticketTest;
- (void)otherTest;

// 子类使用
- (void)__saveMoney;
- (void)__drawMoney;

- (void)__saleTicket;

@end

NS_ASSUME_NONNULL_END
