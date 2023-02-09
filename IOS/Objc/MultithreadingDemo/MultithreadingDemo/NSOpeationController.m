//
//  NSOpeationController.m
//  MultithreadingDemo
//
//  Created by zpz on 2018/8/29.
//  Copyright © 2018年 zpz. All rights reserved.
//

#import "NSOpeationController.h"
#import "PLOperation.h"

@interface NSOpeationController ()

@end

@implementation NSOpeationController

- (void)viewDidLoad {
    [super viewDidLoad];
//    [self operationQueueTest];
//    [self addDependency];
    
    PLOperation *operation = [[PLOperation alloc] init];
    [operation start];
}

- (void)creatOperation
{
    NSInvocationOperation *invocationOp = [[NSInvocationOperation alloc] initWithTarget:self selector:@selector(task1) object:nil];
    [invocationOp start];
    
    NSBlockOperation *blockOperation = [NSBlockOperation blockOperationWithBlock:^{
        NSLog(@"2 --- %@",[NSThread currentThread]);
    }];
    
    [blockOperation addExecutionBlock:^{
        NSLog(@"3 --- %@",[NSThread currentThread]);
    }];
    
    [blockOperation addExecutionBlock:^{
        NSLog(@"4 --- %@",[NSThread currentThread]);
    }];
    
    [blockOperation addExecutionBlock:^{
        NSLog(@"5 --- %@",[NSThread currentThread]);
    }];
    
    [blockOperation start];

}

- (void)operationQueueTest
{
    NSOperationQueue *queue = [[NSOperationQueue alloc] init];
    // 默认并发的 maxConcurrentOperationCount=串行队列
    queue.maxConcurrentOperationCount = 1;
    [queue addOperationWithBlock:^{
        [NSThread sleepForTimeInterval:.5]; // 模拟耗时操作
        NSLog(@"%@",[NSThread currentThread]);
    }];
    
    [queue addOperationWithBlock:^{
        [NSThread sleepForTimeInterval:.5]; // 模拟耗时操作
        NSLog(@"%@",[NSThread currentThread]);
    }];

    
    [queue addOperationWithBlock:^{
        [NSThread sleepForTimeInterval:.5]; // 模拟耗时操作
        NSLog(@"%@",[NSThread currentThread]);
    }];

    
    [queue addOperationWithBlock:^{
        [NSThread sleepForTimeInterval:.5]; // 模拟耗时操作
        NSLog(@"%@",[NSThread currentThread]);
    }];

}

- (void)addDependency
{
    NSOperationQueue *queue = [[NSOperationQueue alloc] init];
    NSBlockOperation *op1 = [NSBlockOperation blockOperationWithBlock:^{
        [NSThread sleepForTimeInterval:.5]; // 模拟耗时操作
        NSLog(@"op1");
    }];
    NSBlockOperation *op2 = [NSBlockOperation blockOperationWithBlock:^{
        [NSThread sleepForTimeInterval:.5]; // 模拟耗时操作
        NSLog(@"op2");
    }];
    [op1 addDependency:op2];
    [queue addOperation:op1];
    [queue addOperation:op2];
}

- (void)task1
{
    for (int i = 0; i < 2; i++) {
        [NSThread sleepForTimeInterval:.5]; // 模拟耗时操作
        NSLog(@"1---%@", [NSThread currentThread]); // 打印当前线
    }
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
