//
//  PLProxy.m
//  TimerDemo
//
//  Created by zpz on 2019/3/14.
//  Copyright © 2019 zpz. All rights reserved.
//

#import "PLProxy.h"

@implementation PLProxy
+ (instancetype)proxyWithTarget:(id)target
{
    PLProxy *proxy = [[PLProxy alloc] init];
    proxy.target = target;
    return proxy;
}

- (id)forwardingTargetForSelector:(SEL)aSelector
{
    return self.target;
}
@end
