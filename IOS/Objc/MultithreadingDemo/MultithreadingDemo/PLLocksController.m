//
//  PLLocksController.m
//  MultithreadingDemo
//
//  Created by zpz on 2019/3/23.
//  Copyright © 2019 zpz. All rights reserved.
//

#import "PLLocksController.h"
#import "PLBaseLockDemo.h"
#import "OSSpinLockDemo.h"
#import "OSUnfairLockDemo.h"
#import "PthreadMutexLockDemo.h"
#import "NSLockDemo.h"
#import "NSConditionDemo.h"
#import "NSConditionLockDemo.h"
#import "SerialQueueDemo.h"
#import "SemaphoreDemo.h"

@interface PLLocksController ()<UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSDictionary *dataSource;
@property (nonatomic, retain) NSArray *arr;
@end

@implementation PLLocksController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.tableView];
    /*
     性能从高到低
     @"os_unfair_lock",
     @"OSSpinLock",  iOS10被抛弃的 苹果建议用os_unfair_lock替代，不安全有个优先级反转的问题。
     @"dispatch_semaphore",
     @"pthread_mutex", 快平台的
     @"dispatch_queue(DISPATCH_SERIAL)",
     @"NSLock",   对pthread_mutex默认锁的封装
     @"NSCondition", 对pthread_mutex_t 和 pthread_cond_t 的封装，条件+锁封装到一起。
     @"pthread_mutex(recursive)",pthread_mutx_t 递归锁  递归锁锁的性能稍差
     @"NSRecursiveLock", 对pthread_mutex递归锁的封装 ,
     @"NSConditionLock", 带有条件的NSCondition，设置条件值。
     @"@synchronized",  通过一个对象去哈希表里面找到一个对象SynData，找到SynData成员变量的一把锁pthread_mutex(recursive)
     
     
     自旋锁、互斥锁比较
     什么情况使用自旋锁比较划算？
     预计线程等待锁的时间很短
     加锁的代码（临界区）经常被调用，但竞争情况很少发生
     CPU资源不紧张
     多核处理器
     
     什么情况使用互斥锁比较划算？
     预计线程等待锁的时间较长
     单核处理器
     临界区有IO操作
     临界区代码复杂或者循环量大
     临界区竞争非常激烈
     
     */
    
    self.dataSource = @{
                        @"OSSpinLock" : [OSSpinLockDemo class],
                        @"os_unfair_lock" : [OSUnfairLockDemo class],
                        @"dispatch_semaphore" : [SemaphoreDemo class],
                        @"pthread_mutex" : [PthreadMutexLockDemo class],
                        @"dispatch_queue(DISPATCH_SERIAL)" : [SerialQueueDemo class],
                        @"NSLock" : [NSLockDemo class],
                        @"NSCondition" : [NSConditionDemo class],
                        @"NSConditionLock" : [NSConditionLockDemo class],
                        @"@synchronized" : [OSSpinLockDemo class],
                        };

}


#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView
 numberOfRowsInSection:(NSInteger)section {
    return _dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellID = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellID];
    }
    cell.textLabel.text = [_dataSource.allKeys objectAtIndex:indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    Class obj = [_dataSource.allValues objectAtIndex:indexPath.row];
    PLBaseLockDemo *demo = [[obj alloc] init];
    [demo ticketTest];
    [demo moneyTest];
    [demo otherTest];
}



#pragma mark - getter

- (UITableView *)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
    }
    return _tableView;
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
