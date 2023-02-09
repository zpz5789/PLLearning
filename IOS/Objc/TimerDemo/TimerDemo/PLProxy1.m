//
//  PLProxy1.m
//  TimerDemo
//
//  Created by zpz on 2019/3/14.
//  Copyright © 2019 zpz. All rights reserved.
//

#import "PLProxy1.h"

@implementation PLProxy1
+ (instancetype)proxyWithTarget:(id)target
{
    // NSProxy对象没有init方法
    PLProxy1 *proxy = [PLProxy1 alloc];
    proxy.target = target;
    return proxy;
}

- (void)forwardInvocation:(NSInvocation *)invocation
{
    [invocation invokeWithTarget:self.target];
}

- (nullable NSMethodSignature *)methodSignatureForSelector:(SEL)sel
{
    return [self.target methodSignatureForSelector:sel];
}
@end
