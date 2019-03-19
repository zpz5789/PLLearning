//
//  RunLoopController3.m
//  RunLoopDemo
//
//  Created by zpz on 2019/3/19.
//  Copyright © 2019 zpz. All rights reserved.
//

#import "RunLoopController3.h"
#import "PLPersistentThread.h"

@interface PLThread1 : NSThread
@end
@implementation PLThread1

- (void)dealloc
{
    NSLog(@"%s",__FUNCTION__);
}
@end


@interface RunLoopController3 ()
//@property (nonatomic, strong) PLThread1 *thread;
@property (nonatomic, strong) PLPersistentThread *thread;

@property (nonatomic, assign) BOOL isStop;
@end

@implementation RunLoopController3

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(100, 100, 100, 100)];
    [button setTitle:@"停止" forState:UIControlStateNormal];
    [button setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(stop) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
    
//    [self test1];
    
    [self test2];
}


- (void)test2
{
    self.thread = [[PLPersistentThread alloc] init];
    [self.thread start];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.thread executeTask:^{
        NSLog(@"do task %@", [NSThread currentThread]);
    }];
}


- (void)dealloc
{
    NSLog(@"%s",__FUNCTION__);
//    [self.thread stop];
}

- (void)stop
{
   [self.thread cancel];
}

#if 0
- (void)test1
{
    __weak typeof(self) weakSelf = self;
    self.thread = [[PLThread1 alloc] initWithBlock:^{
        NSLog(@"%s %@", __FUNCTION__, [NSThread currentThread]);
        [[NSRunLoop currentRunLoop] addPort:[NSPort port] forMode:NSDefaultRunLoopMode];
        while (weakSelf && !weakSelf.isStop) {
            [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode beforeDate:[NSDate distantFuture]];
        }
        NSLog(@"----- end RunLoop");
    }];
    self.thread.name = @"child";
    [self.thread start];
}

- (void)stop
{
    if (!self.thread) {
        return;
    }
    [self performSelector:@selector(stopThread) onThread:self.thread withObject:nil waitUntilDone:YES];
}

- (void)stopThread
{
    NSLog(@"%s",__func__);
    self.isStop = YES;
    CFRunLoopStop(CFRunLoopGetCurrent());
    self.thread = nil;
}

- (void)doTask
{
    NSLog(@"%s %@", __FUNCTION__, [NSThread currentThread]);
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self performSelector:@selector(doTask) onThread:self.thread withObject:nil waitUntilDone:NO];
}

- (void)dealloc
{
    NSLog(@"%s",__FUNCTION__);
    [self stop];

}
#endif
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
