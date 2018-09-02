//
//  GCDController.m
//  MultithreadingDemo
//
//  Created by zpz on 2018/8/29.
//  Copyright © 2018年 zpz. All rights reserved.
//

#import "GCDController.h"

static NSString *const cellID = @"gcdCellID";

@interface GCDController ()<UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) NSArray *dataSource;
@end

@implementation GCDController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _dataSource = @[@"创建队列",@"同步串行" ,@"同步并行",@"异步串行",@"异步并行",@"主线程同步",@"主线程异步",@"栅栏函数",@"GCD队列组",@"其他常用函数",@"信号量",@"倒计时"];
    // 概念
    // 串行队列：所有任务会在一条线程中执行（有可能是当前线程也有可能是新开辟的线程），并且一个任务执行完毕后，才开始执行下一个任务。（等待完成）
    // 并行队列：可以开启多条线程并行执行任务（但不一定会开启新的线程），并且当一个任务放到指定线程开始执行时，下一个任务就可以开始执行了。（等待发生）
   
    // 任务的管理方式
    // 任务的执行方式
    // 从什么样的队列中拿出任务在xxxx线程中按照什么执行方式来执行。
    /*
     同步任务，使用dispatch_sync将任务加入队列。将同步任务加入串行队列，会顺序执行，一般不这样做并且在一个任务未结束时调起其它同步任务会死锁。将同步任务加入并行队列，会顺序执行，但是也没什么意义。
     异步任务，使用dispatch_async将任务加入队列。将异步任务加入串行队列，会顺序执行，并且不会出现死锁问题。将异步任务加入并行队列，会并行执行多个任务，这也是我们最常用的一种方式。
     
     1、创建一个队列（串行队列或并发队列） 2、将任务追加到任务的等待队列中，然后系统就会根据任务类型执行任务（同步执行或异步执行）
     

     */
//    [self deadLock];
    
    // Do any additional setup after loading the view.
}

#pragma mark - 创建GCD队列
- (void)creatQueue
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

#pragma mark - 同步异步串行并发多种组合方式
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
    // 并发队列
    dispatch_queue_t queue = dispatch_queue_create("test", DISPATCH_QUEUE_CONCURRENT);
    
    // 同步执行
    dispatch_sync(queue, ^{
        for (int i = 0; i < 10; i++) {
            NSLog(@"并发同步1   %@",[NSThread currentThread]);
        }
    });
    dispatch_sync(queue, ^{
        for (int i = 0; i < 10; i++) {
            NSLog(@"并发同步1   %@",[NSThread currentThread]);
        }
    });
    dispatch_sync(queue, ^{
        for (int i = 0; i < 10; i++) {
            NSLog(@"并发同步1   %@",[NSThread currentThread]);
        }
    });

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
    dispatch_queue_t queue = dispatch_get_main_queue();
    // 同步执行
    dispatch_sync(queue, ^{
        for (int i = 0; i < 10; i++) {
            NSLog(@"主线程并发同步1   %@",[NSThread currentThread]);
        }
    });
    dispatch_sync(queue, ^{
        for (int i = 0; i < 10; i++) {
            NSLog(@"主线程并发同步1   %@",[NSThread currentThread]);
        }
    });
    dispatch_sync(queue, ^{
        for (int i = 0; i < 10; i++) {
            NSLog(@"主线程并发同步1   %@",[NSThread currentThread]);
        }
    });
    // 结果：发生死锁
#warning 待完善
    // 原因：

}

// 主线程异步
- (void)asyncOnMainQueue
{
    dispatch_queue_t queue = dispatch_get_main_queue();
    // 异步执行
    dispatch_async(queue, ^{
        for (int i = 0; i < 3; i++) {
            NSLog(@"主线程异步1   %@",[NSThread currentThread]);
        }
    });
    dispatch_async(queue, ^{
        for (int i = 0; i < 3; i++) {
            NSLog(@"主线程异步2   %@",[NSThread currentThread]);
        }
    });
}

#pragma mark - 线程间通信
- (void)communicationBetweenThread
{
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        // 耗时操作放在这里，例如下载图片。（运用线程休眠两秒来模拟耗时操作）
        [NSThread sleepForTimeInterval:2];
        NSString *picURLStr = @"https://upload.jianshu.io/users/upload_avatars/644999/0ba0d431ecac.jpg?imageMogr2/auto-orient/strip|imageView2/1/w/240/h/240";
        NSURL *picURL = [NSURL URLWithString:picURLStr];
        NSData *picData = [NSData dataWithContentsOfURL:picURL];
        UIImage *image = [UIImage imageWithData:picData];
        dispatch_async(dispatch_get_main_queue(), ^{
            // 主线程UI更新操作
            
        });
    });
}

#pragma mark - GCD栅栏 栅栏函数需要注意点 应用
- (void)barrierGCD
{
    // 不能使用全局并发队列，否则失去意义
    // 在同步栅栏时栅栏函数在主线程中执行,而异步栅栏中开辟了子线程栅栏函数在子线程中执行
    // 在使用栅栏函数时.使用自定义队列才有意义,如果用的是串行队列或者系统提供的全局并发队列,这个栅栏函数的作用等同于一个同步函数的作用
    // dispatch_barrier_sync: Submits a barrier block object for execution and waits until that block completes.(提交一个栅栏函数在执行中,它会等待栅栏函数执行完)
    // dispatch_barrier_async: Submits a barrier block for asynchronous execution and returns immediately.(提交一个栅栏函数在异步执行中,它会立马返回)

//    dispatch_queue_t queue = dispatch_get_global_queue(0, 0);
    NSLog(@"start");
    dispatch_queue_t queue = dispatch_queue_create("test", DISPATCH_QUEUE_CONCURRENT);
    dispatch_async(queue, ^{
        for (int i = 0; i < 3; i++) {
            NSLog(@"栅栏： 并发异步任务1 %@",[NSThread currentThread]);
        }
    });
    NSLog(@"after1");
    NSLog(@"after1-1");
    NSLog(@"after1-2");
    NSLog(@"after1-3");

    dispatch_async(queue, ^{
        for (int i = 0; i < 3; i++) {
            NSLog(@"栅栏： 并发异步任务2 %@",[NSThread currentThread]);
        }
    });
    NSLog(@"after2");

    // dispatch_barrier_sync -> 2018-08-30 15:55:30.026497+0800 MultithreadingDemo[8466:1016098] ------------barrier------------<NSThread: 0x6040000622c0>{number = 1, name = main}

    dispatch_barrier_sync(queue, ^{
        NSLog(@"------------barrier------------%@", [NSThread currentThread]);
    });
    NSLog(@"after barrier");

    dispatch_async(queue, ^{
        for (int i = 0; i < 3; i++) {
            NSLog(@"栅栏： 并发异步任务3 %@",[NSThread currentThread]);
        }
    });
    NSLog(@"after 3");

    dispatch_async(queue, ^{
        for (int i = 0; i < 3; i++) {
            NSLog(@"栅栏： 并发异步任务4 %@",[NSThread currentThread]);
        }
    });
    NSLog(@"after 4 end");

    // 执行顺序 1 2 随机 但是 3 4 一定是在 1 2 barrier 后面
    // 应用 多读单写模型
}

#pragma mark - GCD队列组
- (void)groupGCD
{
    dispatch_group_t group = dispatch_group_create();
    dispatch_group_async(group, dispatch_get_global_queue(0, 0), ^{
        NSLog(@"队列组：有一个耗时操作1完成！");
    });
    
    dispatch_group_async(group, dispatch_get_global_queue(0, 0), ^{
        NSLog(@"队列组：有一个耗时操作2完成！");
    });
    
    dispatch_group_notify(group, dispatch_get_main_queue(), ^{
        NSLog(@"队列组：前面的耗时操作都完成了，回到主线程进行相关操作");
    });
    
#warning 待完善
    // 应用：常应用于单页面多网络请求场景，多个网络请求执行完毕再刷新UI、
    // 下载一个大的文件，分块下载，全部下载完成后再合成一个文件 再比如同时下载多个图片，监听全部下载完后的动作
    // example
    dispatch_group_t netWorkGroup = dispatch_group_create();
    
    NSURLSession *session = [NSURLSession sharedSession];
    NSURL *url = [NSURL URLWithString:@"https://upload.jianshu.io/users/upload_avatars/644999/0ba0d431ecac.jpg?imageMogr2/auto-orient/strip|imageView2/1/w/240/h/240"];
    NSURLSessionDataTask *task = [session dataTaskWithURL:url completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        NSLog(@"%@ %@ %@ %@", data, response, error, [NSThread currentThread]);
    }];
    [task resume];
}

#pragma mark - 其他常用函数
- (void)otherFunctionGCD
{
    // 延时执行
    // 主线程延时 1秒执行
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
    });
    
#warning 待完善
    // 拓展：GCD定时器 与 其他定时器的区别和联系
    
    // 一次性执行代码
    // 应用：常用于单例生成、 load方法中method swizzle等整个应用程序生命周期只需一次性执行的地方
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        // input一次性执行的代码
    });
    
    
    // 快速迭代
    dispatch_queue_t queue = dispatch_get_global_queue(0, 0);
    // dispatch_apply几乎同时遍历多个数字
    dispatch_apply(7, queue, ^(size_t index) {
        NSLog(@"dispatch_apply：%zd======%@",index, [NSThread currentThread]);
    });
    
}

#pragma mark - 死锁
- (void)deadLockGCD
{
#warning message
    /// 怎么解释，有点疑问。
    dispatch_queue_t queue = dispatch_queue_create("com.test.queue", DISPATCH_QUEUE_CONCURRENT);
    dispatch_async(queue, ^{
        for (int i = 0; i < 10; i ++) {
            NSLog(@"1. %@",[NSThread currentThread]);
        }
        dispatch_sync(queue, ^{
            for (int i = 0; i < 5; i ++) {
                NSLog(@"2. %@",[NSThread currentThread]);
            }
        });
        for (int i = 0; i < 10; i ++) {
            NSLog(@"3. %@",[NSThread currentThread]);
        }

    });
    // 1 执行完之后，再执行2。
}

#pragma mark - 信号量
- (void)semaphoreGCD
{
    /*
     dispatch_semaphore_create(1);//创建1个信号
     dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);//当计数值大于1时，或者在待机中计数值大于1时，对该计数减1并且返回。
     dispatch_semaphore_signal(semaphore);//对计数值加1
     */
     // 应用： 解决线程同步问题。加锁
    
    // dispatch_semaphore_signal有两类用法：a、解决同步问题；b、解决有限资源访问（资源为1，即互斥）问题。
    // dispatch_semaphore_wait，若semaphore计数为0则等待，大于0则使其减1。
    // dispatch_semaphore_signal使semaphore计数加1。
    
    // a、同步问题：输出肯定为1、2、3。
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_semaphore_t semaphore1 = dispatch_semaphore_create(1);
    dispatch_semaphore_t semaphore2 = dispatch_semaphore_create(0);
    dispatch_semaphore_t semaphore3 = dispatch_semaphore_create(0);

    dispatch_async(queue, ^{
        // 任务1
        dispatch_semaphore_wait(semaphore1, DISPATCH_TIME_FOREVER);
        NSLog(@"1\n");
        dispatch_semaphore_signal(semaphore2);
        // 如果不加这句会崩溃 内存管理问题
        dispatch_semaphore_signal(semaphore1);
    });
    
    dispatch_async(queue, ^{
        // 任务2
        dispatch_semaphore_wait(semaphore2, DISPATCH_TIME_FOREVER);
        NSLog(@"2\n %@",semaphore1);
        dispatch_semaphore_signal(semaphore3);
//        dispatch_semaphore_signal(semaphore2);
    });
    
    dispatch_async(queue, ^{
        // 任务3
        dispatch_semaphore_wait(semaphore3, DISPATCH_TIME_FOREVER);
        NSLog(@"3\n");
//        dispatch_semaphore_signal(semaphore3);
    });
    
    
    // b、有限资源访问问题:for循环看似能创建100个异步任务，实质由于信号限制，最多创建10个异步任务。
//    dispatch_queue_t queue1 = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
//    dispatch_semaphore_t semaphore = dispatch_semaphore_create(10);
//    for (int i = 0; i < 100; i ++) {
//        dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
//        dispatch_async(queue1, ^{
//            // 任务
//            NSLog(@"%@ %@",@(i), [NSThread currentThread]);
//            dispatch_semaphore_signal(semaphore);
//        });
//    }
}

#pragma mark - 倒计时定时器
- (void)sourceTimerGCD
{
    dispatch_source_t timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, dispatch_get_main_queue());
    
    dispatch_source_set_timer(timer, dispatch_time(DISPATCH_TIME_NOW, 15ULL*NSEC_PER_SEC), DISPATCH_TIME_FOREVER, 1ull*NSEC_PER_SEC);
    
    dispatch_source_set_event_handler(timer, ^{
        NSLog(@"wake up");
        dispatch_source_cancel(timer);
    });
    
    dispatch_source_set_cancel_handler(timer, ^{
        NSLog(@"canceled");
    });
    
    dispatch_resume(timer);
    // 应用：定时器倒计时
    
    /*
     NSTimer缺点、不精确、依赖runLoop、 创建销毁在同一线程上面。存在内存泄露的风险。
     */

    
}


#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID forIndexPath:indexPath];
    cell.textLabel.text = [self.dataSource objectAtIndex:indexPath.row];
    return cell;
}

#pragma mark - UITableViewDategate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //@"创建队列",@"同步串行" ,@"同步并行",@"异步串行",@"异步并行",@"主线程同步",@"主线程异步"
    switch (indexPath.row) {
        case 0:
            [self creatQueue];
            break;
        case 1:
            [self syncSerial];
            break;
        case 2:
            [self syncConcurrent];
            break;
        case 3:
            [self asyncSerial];
            break;
        case 4:
            [self asyncConcurrent];
            break;
        case 5:
            [self syncOnMainQueue];
            break;
        case 6:
            [self asyncOnMainQueue];
            break;
        case 7:
            [self barrierGCD];
            break;
        case 8:
            [self groupGCD];
            break;
        case 9:
            [self otherFunctionGCD];
            break;
        case 10:
            [self semaphoreGCD];
            break;
        case 11:
            [self sourceTimerGCD];
            break;
        default:
            break;
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
