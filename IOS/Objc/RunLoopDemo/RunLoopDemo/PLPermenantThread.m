//
//  PLPermenantThread.m
//  RunLoopDemo
//
//  Created by zpz on 2019/3/19.
//  Copyright © 2019 zpz. All rights reserved.
//

#import "PLPermenantThread.h"
@interface PLPermenantThread ()
@property (strong, nonatomic) NSThread *thread;
@end
@implementation PLPermenantThread

- (instancetype)init
{
    if (self = [super init]) {
        self.thread = [[NSThread alloc] initWithBlock:^{
            // 创建上下文（要初始化一下结构体）
            CFRunLoopSourceContext context = {0};
            
            // 创建source
            CFRunLoopSourceRef source = CFRunLoopSourceCreate(kCFAllocatorDefault, 0, &context);
            
            // 往Runloop中添加source
            CFRunLoopAddSource(CFRunLoopGetCurrent(), source, kCFRunLoopDefaultMode);
            
            // 销毁source
            CFRelease(source);
            
            // 启动
            // 第3个参数：returnAfterSourceHandled，设置为true，代表执行完source后就会退出当前loop
            CFRunLoopRunInMode(kCFRunLoopDefaultMode, 1.0e10, false);
            
        }];
    }
    return self;
}

- (void)start
{
    if (!self.thread) return;

    [self.thread start];
}

- (void)executeTask:(PLPermenantThreadTask)task
{
    if (!self.thread || !task) return;
    
    [self performSelector:@selector(__executeTask:) onThread:self.thread withObject:task waitUntilDone:NO];
}

- (void)cancel
{
    if (!self.thread) return;
    
    [self performSelector:@selector(__stop) onThread:self.thread withObject:nil waitUntilDone:YES];
}

- (void)dealloc
{
    NSLog(@"%s", __func__);
    
    [self cancel];
}

- (void)__stop
{
    CFRunLoopStop(CFRunLoopGetCurrent());
    self.thread = nil;
}


- (void)__executeTask:(PLPermenantThreadTask)task
{
    task();
}


@end
