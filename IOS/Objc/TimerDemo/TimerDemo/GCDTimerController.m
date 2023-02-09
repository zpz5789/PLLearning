//
//  GCDTimerController.m
//  TimerDemo
//
//  Created by zpz on 2019/3/13.
//  Copyright © 2019 zpz. All rights reserved.
//

#import "GCDTimerController.h"
#import "PLTimer.h"

@interface GCDTimerController ()
@property (strong, nonatomic) dispatch_source_t timer;
@end

@implementation GCDTimerController
{
    NSString *_taskId;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self test2];
}

- (void)test1
{
    dispatch_queue_t queue = dispatch_queue_create("timer", DISPATCH_QUEUE_SERIAL);
    self.timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
    uint64_t start = 1.0;
    uint64_t interval = 2.0;
    dispatch_source_set_timer(self.timer, dispatch_time(DISPATCH_WALLTIME_NOW, start * NSEC_PER_SEC), interval * NSEC_PER_SEC, 0);
    // 传入block作为定时任务
    //    dispatch_source_set_event_handler(self.timer, ^{
    //        NSLog(@"timerFire");
    //    });
    
    // 传入函数指针作为定时任务
    dispatch_source_set_event_handler_f(self.timer, timerFire);
    dispatch_resume(self.timer);
}

- (void)test2
{
   _taskId = [PLTimer executeTask:^{
        NSLog(@"PLTimer execute %@",[NSThread currentThread]);
    } start:2 interval:1 repeats:YES async:YES];
    
//    [PLTimer executeTask:self selector:@selector(timerExecute) start:5 interval:2 repeats:NO async:NO];
}


- (void)timerExecute
{
    NSLog(@"PLTimer execute %@",[NSThread currentThread]);
}

void timerFire(void *param)
{
    NSLog(@"timerFire");
}

- (void)dealloc
{
    [PLTimer cancelTask:_taskId];
    NSLog(@"%s",__FUNCTION__);
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
