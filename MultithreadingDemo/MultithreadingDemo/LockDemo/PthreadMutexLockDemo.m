//
//  PthreadMutexLockDemo.m
//  MultithreadingDemo
//
//  Created by zpz on 2019/4/1.
//  Copyright © 2019 zpz. All rights reserved.
//

#import "PthreadMutexLockDemo.h"
#import <pthread.h>

/// Pthread unix 平台通用  互斥锁
@interface PthreadMutexLockDemo ()
@property (assign, nonatomic) pthread_mutex_t ticketMutex;
@property (assign, nonatomic) pthread_mutex_t moneyMutex;
@property (assign, nonatomic) pthread_mutex_t recursiveMutex;

@property (assign, nonatomic) pthread_mutex_t condMutex;
@property (assign, nonatomic) pthread_cond_t cond;
@property (strong, nonatomic) NSMutableArray *data;

@end

@implementation PthreadMutexLockDemo

- (void)__initMutex:(pthread_mutex_t *)mutex
{
    // 报错  _ticketMutex = {_PTHREAD_MUTEX_SIG_init, {0}};  结构体只能在初始化的时候赋值
    //_ticketMutex = PTHREAD_MUTEX_INITIALIZER ;
    // 静态初始化
    // pthread_mutex_t ticketMutex = PTHREAD_MUTEX_INITIALIZER;
    /*
     /*
     Mutex type attributes
     
     #define PTHREAD_MUTEX_NORMAL        0\
     #define PTHREAD_MUTEX_ERRORCHECK    1\
     #define PTHREAD_MUTEX_RECURSIVE        // 递归锁
     #define PTHREAD_MUTEX_DEFAULT        PTHREAD_MUTEX_NORMAL\
     */
//    pthread_mutexattr_t attr;
//    pthread_mutexattr_init(&attr);
//    pthread_mutexattr_settype(&attr, PTHREAD_MUTEX_DEFAULT);
//    pthread_mutex_init(&_ticketMutex, &attr);
//    pthread_mutex_destroy(&attr);
    // 传NULL相当于 默认类型锁
    pthread_mutex_init(mutex, NULL);
    
}

- (void)__initRecursiveMutex:(pthread_mutex_t *)mutex
{
    // 递归锁：允许同一个线程对一把锁进行重复加锁
    
    // 初始化属性
    pthread_mutexattr_t attr;
    pthread_mutexattr_init(&attr);
    pthread_mutexattr_settype(&attr, PTHREAD_MUTEX_RECURSIVE);
    // 初始化锁
    pthread_mutex_init(mutex, &attr);
    // 销毁属性
    pthread_mutexattr_destroy(&attr);
}

- (void)__conditionInit
{
    _data = [NSMutableArray array];
    pthread_cond_init(&_cond, NULL);
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self __initMutex:&_ticketMutex];
        [self __initMutex:&_moneyMutex];
        [self __initRecursiveMutex:&_recursiveMutex];
        [self __initRecursiveMutex:&_condMutex];
        [self __conditionInit];
    }
    return self;
}

- (void)otherTest
{
    [self otherTest1];
    [self otherTest2];
}

- (void)otherTest2
{
    [[[NSThread alloc] initWithTarget:self selector:@selector(__remove) object:nil] start];
    
    [[[NSThread alloc] initWithTarget:self selector:@selector(__add) object:nil] start];
}



- (void)otherTest1
{
    pthread_mutex_lock(&_recursiveMutex);
    
//    NSLog(@"%s", __func__);
    
    static int count = 0;
    
    NSLog(@"%s count is %d", __func__, count);

    if (count < 10) {
        count++;
        [self otherTest1];
    }
    
    pthread_mutex_unlock(&_recursiveMutex);
}

- (void)__saleTicket
{
    pthread_mutex_lock(&_ticketMutex);
    
    [super __saleTicket];
    
    pthread_mutex_unlock(&_ticketMutex);
}

- (void)__saveMoney
{
    pthread_mutex_lock(&_moneyMutex);
    
    [super __saveMoney];
    
    pthread_mutex_unlock(&_moneyMutex);
}

- (void)__drawMoney
{
    pthread_mutex_lock(&_moneyMutex);
    
    [super __drawMoney];
    
    pthread_mutex_unlock(&_moneyMutex);
}


// 线程1
// 删除数组中的元素
- (void)__remove
{
    pthread_mutex_lock(&_condMutex);
    NSLog(@"__remove - begin");
    
    if (self.data.count == 0) {
        // 等待
        pthread_cond_wait(&_cond, &_condMutex);
    }
    
    [self.data removeLastObject];
    NSLog(@"删除了元素");
    
    pthread_mutex_unlock(&_condMutex);
}

// 线程2
// 往数组中添加元素
- (void)__add
{
    pthread_mutex_lock(&_condMutex);
    
    sleep(1);
    
    [self.data addObject:@"Test"];
    NSLog(@"添加了元素");
    
    // 信号
    pthread_cond_signal(&_cond);
    // 广播
    //    pthread_cond_broadcast(&_cond);
    
    pthread_mutex_unlock(&_condMutex);
}

// 记得销毁
- (void)dealloc
{
    pthread_mutex_destroy(&_moneyMutex);
    pthread_mutex_destroy(&_ticketMutex);
    pthread_mutex_destroy(&_recursiveMutex);
    pthread_mutex_destroy(&_condMutex);
    pthread_cond_destroy(&_cond);
}
@end
