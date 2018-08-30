//
//  GCDController.m
//  MultithreadingDemo
//
//  Created by zpz on 2018/8/29.
//  Copyright © 2018年 zpz. All rights reserved.
//

#import "GCDController.h"

@interface GCDController ()

@end

@implementation GCDController

- (void)viewDidLoad {
    [super viewDidLoad];
    
//    [self creatStyle];
//    [self syncSerial];
    [self asyncConcurrent];
    // Do any additional setup after loading the view.
}

- (void)creatStyle
{
    // 主队列
    dispatch_queue_t mainQueue = dispatch_get_main_queue();
    // 全局并发队列
    dispatch_queue_t globalQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    
    // 并发队列
    dispatch_queue_t concurrentQueue = dispatch_queue_create("queue1", DISPATCH_QUEUE_CONCURRENT);
    // 串行队列
    dispatch_queue_t serialQueue1 = dispatch_queue_create("queue2", DISPATCH_QUEUE_SERIAL);
    
    // 同步执行
    dispatch_sync(serialQueue1, ^{
        NSLog(@"serialQueue1 同步执行");
    });
    
    //异步执行 synchronous synchronized
    dispatch_async(globalQueue, ^{
        NSLog(@"globalQueue 异步执行");
    });
    
}

#pragma mark - 对列多种组合方式
// 串行同步
- (void)syncSerial
{
    dispatch_queue_t serialQueue1 = dispatch_queue_create("queue2", DISPATCH_QUEUE_SERIAL);
    
    dispatch_sync(serialQueue1, ^{
        for (int i = 0; i < 3; i++) {
            NSLog(@"串行同步1   %@",[NSThread currentThread]);
        }
    });
    dispatch_sync(serialQueue1, ^{
        for (int i = 0; i < 3; i++) {
            NSLog(@"串行同步2   %@",[NSThread currentThread]);
        }
    });
    dispatch_sync(serialQueue1, ^{
        for (int i = 0; i < 3; i++) {
            NSLog(@"串行同步3   %@",[NSThread currentThread]);
        }
    });
    // 串行: 队列中的任务只能依次有序的执行， 同步：任务一个执行完，另一个接着执行，不开线程所以在主线程，所以主线外不开线程，任务根据加入队列的顺序一个一个在主线程执行。
}

// 串行异步
- (void)asyncSerial
{
    // 串行队列
    dispatch_queue_t queue = dispatch_queue_create("test", DISPATCH_QUEUE_SERIAL);
    
    // 异步执行
    dispatch_async(queue, ^{
        for (int i = 0; i < 3; i++) {
            NSLog(@"串行异步1   %@",[NSThread currentThread]);
        }
    });
    dispatch_async(queue, ^{
        for (int i = 0; i < 3; i++) {
            NSLog(@"串行异步2   %@",[NSThread currentThread]);
        }
    });
    dispatch_async(queue, ^{
        for (int i = 0; i < 3; i++) {
            NSLog(@"串行异步3   %@",[NSThread currentThread]);
        }
    });
}

// 并发同步
- (void)syncConcurrent
{
    
}

// 并发异步
- (void)asyncConcurrent
{
    // 并发队列
    dispatch_queue_t queue = dispatch_queue_create("test", DISPATCH_QUEUE_CONCURRENT);
    
    // 异步执行
    dispatch_async(queue, ^{
        for (int i = 0; i < 10; i++) {
            NSLog(@"并发异步1   %@",[NSThread currentThread]);
        }
    });
    dispatch_async(queue, ^{
        for (int i = 0; i < 10; i++) {
            NSLog(@"并发异步2   %@",[NSThread currentThread]);
        }
    });
    dispatch_async(queue, ^{
        for (int i = 0; i < 10; i++) {
            NSLog(@"并发异步3   %@",[NSThread currentThread]);
        }
    });
}

// 主线程同步(死锁)
- (void)syncOnMainQueue
{
    
}

// 主线程异步
- (void)asyncOnMainQueue
{
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
