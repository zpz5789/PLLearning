//
//  NSTheadController.m
//  MultithreadingDemo
//
//  Created by zpz on 2018/8/29.
//  Copyright © 2018年 zpz. All rights reserved.
//

#import "NSTheadController.h"

@interface NSTheadController ()

@end

@implementation NSTheadController

- (void)viewDidLoad {
    [super viewDidLoad];
    /** 三种创建方式子线程 */
    // 方式一：创建NSThead实例，并调用start方法
    //    NSThread *threadA1 = [[NSThread alloc] initWithBlock:^{
    //        [self threadA];
    //    }];
    //    [threadA1 start];
    
    NSThread *threadA2 = [[NSThread alloc] initWithTarget:self selector:@selector(threadA) object:nil];
    // 线程加入线程池等待CPU调度，时间很快，几乎是立刻执行
    [threadA2 start];
    
    // 方式二：调用类方法 detachNewThreadSelector: toTarget: withObject:，不需要调用start
    // [NSThread detachNewThreadWithBlock:<#^(void)block#>];
    [NSThread detachNewThreadSelector:@selector(threadB) toTarget:self withObject:nil];

    // 方式三：
    // [self performSelectorOnMainThread:<#(nonnull SEL)#> withObject:<#(nullable id)#> waitUntilDone:<#(BOOL)#>];
    [self performSelectorInBackground:@selector(threadC) withObject:nil];
    
    /** 常用方法 */
    // 常用获取主线程方法
    [NSThread mainThread];
    
    // 获取当前线程方法
    [NSThread currentThread];
    
    /** 应用 */
    // 常驻线程

}

- (void)threadA
{
    NSLog(@"%@-%@",NSStringFromSelector(_cmd),[NSThread currentThread]);
}

- (void)threadB
{
    NSLog(@"%@-%@",NSStringFromSelector(_cmd),[NSThread currentThread]);
}

- (void)threadC
{
    NSLog(@"%@-%@",NSStringFromSelector(_cmd),[NSThread currentThread]);
}

// 常驻线程
- (void)resistentThread
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
