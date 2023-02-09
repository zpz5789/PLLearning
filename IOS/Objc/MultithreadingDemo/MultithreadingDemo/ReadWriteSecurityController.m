//
//  ReadWriteSecurityController.m
//  MultithreadingDemo
//
//  Created by zpz on 2019/4/1.
//  Copyright © 2019 zpz. All rights reserved.
//

#import "ReadWriteSecurityController.h"
#import <pthread.h>

@interface ReadWriteSecurityController ()
@property (assign, nonatomic) pthread_rwlock_t lock;
@property (strong, nonatomic) dispatch_queue_t queue;

@end

@implementation ReadWriteSecurityController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 多读单写  读写锁或者dispatch_barrier_async（异步栅栏函数）
    
    // Do any additional setup after loading the view.
}


- (void)test2
{
    /*
     这个函数传入的并发队列必须是自己通过dispatch_queue_creat创建的
     如果传入的是一个串行或是一个全局并发对列，那这个k函数便等同于dispatch_async函数的效果。
     */
    self.queue = dispatch_queue_create("rw_queue", DISPATCH_QUEUE_CONCURRENT);
    
    for (int i = 0; i < 10; i++) {
        dispatch_async(self.queue, ^{
            [self read];
        });
        
        dispatch_async(self.queue, ^{
            [self read];
        });
        
        dispatch_async(self.queue, ^{
            [self read];
        });
        
        dispatch_barrier_async(self.queue, ^{
            [self write];
        });
    }
}

- (void)read {
    sleep(1);
    NSLog(@"read");
}

- (void)write
{
    sleep(1);
    NSLog(@"write");
}



#if 0
- (void)test1
{
    // 初始化锁
    pthread_rwlock_init(&_lock, NULL);
    
    dispatch_queue_t queue = dispatch_get_global_queue(0, 0);
    
    for (int i = 0; i < 10; i++) {
        dispatch_async(queue, ^{
            [self read];
        });
        dispatch_async(queue, ^{
            [self write];
        });
    }
}

- (void)read {
    pthread_rwlock_rdlock(&_lock);
    
    sleep(1);
    NSLog(@"%s", __func__);
    
    pthread_rwlock_unlock(&_lock);
}

- (void)write
{
    pthread_rwlock_wrlock(&_lock);
    
    sleep(1);
    NSLog(@"%s", __func__);
    
    pthread_rwlock_unlock(&_lock);
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
