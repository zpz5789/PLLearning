//
//  PLPersistentThead.m
//  RunLoopDemo
//
//  Created by zpz on 2019/3/19.
//  Copyright © 2019 zpz. All rights reserved.
//

#import "PLPersistentThread.h"
@interface PLThread : NSThread
@end
@implementation PLThread

- (void)dealloc
{
    NSLog(@"%s",__FUNCTION__);
}

@end

@interface PLPersistentThread ()
@property (nonatomic, strong) PLThread *thread;
@property (nonatomic, assign, getter=isStopped) BOOL stopped;
@end

@implementation PLPersistentThread

- (instancetype)init
{
    if (self = [super init]) {
        __weak typeof(self) weakSelf = self;
        _thread = [[PLThread alloc] initWithBlock:^{
            [[NSRunLoop currentRunLoop] addPort:[[NSPort alloc] init] forMode:NSDefaultRunLoopMode];
            while (weakSelf && !weakSelf.isStopped) {
                [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode beforeDate:[NSDate distantFuture]];
            }
        }];
    }
    return self;
}

- (void)start
{
    if (!_thread) {
        return;
    }
    [_thread start];
}

- (void)cancel
{
    if (!_thread) {
        return;
    }
    
    [self performSelector:@selector(__cancel) onThread:self.thread withObject:nil waitUntilDone:YES];
}

- (void)executeTask:(PLPersistentThreadTask)task
{
    if (!_thread || !task) {
        return;
    }
    [self performSelector:@selector(__doTask:) onThread:self.thread withObject:task waitUntilDone:NO];

}

#pragma mark - Pravite Method
- (void)__doTask:(PLPersistentThreadTask)task
{
    task();
}

- (void)__cancel
{
    _stopped = YES;
    CFRunLoopStop(CFRunLoopGetCurrent());
    self.thread = nil;
}

- (void)dealloc
{
    NSLog(@"%s %@",__FUNCTION__, _thread);
    [self cancel];
}

@end
