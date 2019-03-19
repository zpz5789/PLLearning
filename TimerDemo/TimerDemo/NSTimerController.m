//
//  NSTimerController.m
//  TimerDemo
//
//  Created by zpz on 2019/3/13.
//  Copyright © 2019 zpz. All rights reserved.
//

#import "NSTimerController.h"
#import "PLProxy1.h"
#import "NSTimer+PL.h"
#import "NSTimer+Block.h"

@interface NSTimerController ()
@property (nonatomic, strong) NSTimer *timer;

@property (nonatomic, strong) NSThread *thread;
@end

@implementation NSTimerController

- (void)viewDidLoad {
    [super viewDidLoad];
    
//    [self test];
//    [self test1];
    [self test2];
//    [self test3];
}


/**
 NSTimer 创建
 */
- (void)test
{
    // NSTimer 创建方式
    // [NSTimer timer ...] 方式创建的timer 需要加入 一个runloop中timer才能生效 [NSTimer scheduledTimer...]方式创建的timer 会自动添加到当前runloop中执行。

    // 1. block ios(10.0)后才能调用
//    _timer = [NSTimer timerWithTimeInterval:1 repeats:YES block:^(NSTimer * _Nonnull timer) {
//        NSLog(@"timer block style ");
//    }];
    
//    _timer = [NSTimer scheduledTimerWithTimeInterval:1 repeats:NO block:^(NSTimer * _Nonnull timer) {
//
//    }];
    
    // 2. target selector 方式创建
//    _timer = [NSTimer timerWithTimeInterval:1 target:self selector:@selector(timerFire) userInfo:nil repeats:YES];
    
//    _timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(timerFire) userInfo:nil repeats:YES];
    
    // 3. invocation 方式调用
//    _timer = [NSTimer timerWithTimeInterval:1 invocation:[self invocation:@selector(timerFire) withArgument:nil] repeats:YES];
    
    _timer = [NSTimer scheduledTimerWithTimeInterval:1 invocation:[self invocation:@selector(timerFire) withArgument:nil] repeats:YES];
    
    // [NSTimer timer ...] 方式创建的timer 需要加入 一个runloop中timer才能生效
    [[NSRunLoop currentRunLoop] addTimer:_timer forMode:NSDefaultRunLoopMode];
}



/**
 NSTimer 内存泄露问题以及解决方案
 */
- (void)test1
{
    // repeats:NO 不会产生内存泄露
//    _timer =[NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(timerFire) userInfo:nil repeats:NO]
    
    // runloop 强引用 _timer,  _timer 强引用self, 导航栏pop后 self被_timer强引用 不能调用dealloc从而内存泄露， dealloc无法调用 [_timer invalidate] 不能调用， [_timer invalidate]方法不调用 _timer依然被runloop强引用 无法释放，导致导航栏pop后 定时任务依然执行。
    
//    _timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(timerFire) userInfo:nil repeats:YES];

    // 解决办法，引入中间变量，PLproxy1 对象对 self 弱引用，即导航栏pop时 self无强引用，调用dealloc [link invalidate]， link 销毁， self 释放。 其中  PLProxy 对象中用了消息转发
    
//    _timer = [NSTimer scheduledTimerWithTimeInterval:1 target:[PLProxy1 proxyWithTarget:self] selector:@selector(timerFire) userInfo:nil repeats:YES];
    
    // block类型内存泄露可用以下方式解决
//    __weak typeof(self) weakSelf = self;
//    weakSelf.timer = [NSTimer scheduledTimerWithTimeInterval:1 repeats:YES block:^(NSTimer * _Nonnull timer) {
//        NSLog(@"weakSelf block ");
//    }];
    // 为什么block方式可用弱引用解决，而 targe: selector: 方式创建的timer内存泄露问题不能用弱引用解决？
    // targe: selector: 内部会对传入的target强引用，开发者无法控制。而block方式是开发者可以控制的，可以用解决block循环引用的方式解决。
    
    // 创建一个自销毁的定时器1
//    [NSTimer plScheduledTimerWithTimeInterval:1 target:self selector:@selector(timerFire) userInfo:nil repeats:YES];
    
    // block 方式解决timer强引用 self问题
    /*
     将block作为userinfo的参数传进去，只要计时器还有效，就会一直保留着它，传入参数时要通过copy方法将block，copy到堆上，否则等到稍后要执行它的时候，该块可能已经无效了。计时器现在的target是NSTimer的类对象，由于是个单例，所以不用担心产生循环引用的问题。但是这本身还不能解决问题，因为block捕获了self变量，所以block要保留实例，计时器有通过userinfo保留了block，最后实例本身还要保留计时器，不过改成weak引用，就直接打破保留环，打破循环引用。
     
     这种方式在iOS10 系统给出了方法
     */
    __weak typeof(self) weakSelf = self;
    self.timer = [NSTimer pl_scheduledTimerWithTimeInterval:1 block:^{
//        NSLog(@"block timer --- ");
        [weakSelf timerFire];
    } repeats:YES];

}


/**
 NSTimer与在子线程中运行
 */
- (void)test2
{
    __weak typeof(self) weakSelf = self;
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        // 子线程使用timer
        NSLog(@"%s - %@ - %@", __FUNCTION__, [NSThread currentThread], [NSRunLoop currentRunLoop]);
        weakSelf.timer = [NSTimer scheduledTimerWithTimeInterval:1 target:[PLProxy1 proxyWithTarget:weakSelf] selector:@selector(timerFire) userInfo:nil repeats:YES];
        // 以上代码timer不会生效
        // 需要加入以下代码才会生效
        // 因为子线程的runloop默认不会运行，需要子线程的runloop 运行起来timer才会生效
        [[NSRunLoop currentRunLoop] run];
    });
}

- (void)test3
{
    // CFRunLoopTimerRef 是基于时间的触发器，它和 NSTimer 是toll-free bridged 的，可以混用。其包含一个时间长度和一个回调（函数指针）。当其加入到 RunLoop 时，RunLoop会注册对应的时间点，当时间点到时，RunLoop会被唤醒以执行那个回调。
    // 所以NSTimer不太准确，因为Timer依赖于runloop, 时间点到了，刚好runloop在处理其他事件，则会等处理完其他事件再来处理NSTimer事件。NSTimer 有个 属性tolerance，表示容忍时间，意思是runloop在处理其他事件超过这个容忍时间则放弃处理本次NSTimer事件，进入下一次时间点处理NStimer事件。
    
    _thread = [[NSThread alloc] initWithTarget:self selector:@selector(treadSelector) object:nil];
    [_thread start];
}

#warning 问题 子线程内存泄露处理
- (void)treadSelector
{
    NSLog(@"%s - %@ ", __FUNCTION__, [NSThread currentThread]);

    __weak typeof(self) weakSelf = self;
    weakSelf.timer = [NSTimer scheduledTimerWithTimeInterval:1 target:[PLProxy1 proxyWithTarget:weakSelf] selector:@selector(timerFire) userInfo:nil repeats:YES];
    [[NSRunLoop currentRunLoop] run];

}

- (void)timerFire
{
    NSLog(@"%s",__FUNCTION__);
}

- (void)dealloc
{
    [_timer invalidate];
    NSLog(@"%s",__FUNCTION__);
}

- (NSInvocation *)invocation:(SEL)aSelector withArgument:(id)anArgument
{
    NSMethodSignature *methodSignature = [self methodSignatureForSelector:aSelector];
    NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:methodSignature];
    invocation.target = self;
    invocation.selector = aSelector;
    
    //NSInvocation 有两个隐藏参数，所以anArgument
    if ([anArgument isKindOfClass:[NSArray class]]) {
        
        NSInteger  count = MIN(methodSignature.numberOfArguments - 2, [(NSArray *)anArgument count]);
        
        for (int i = 0; i< count; i++) {
            
            const char *type  = [methodSignature getArgumentTypeAtIndex:i + 2];
            
            //需要做参数类型判断然后解析成对应类型，这里默认所有参数都是OC对象
            if (strcmp(type, "@") == 0) {
                id argument = anArgument[i];
                [invocation setArgument:&argument atIndex:2+i];
            }
        }
        
    }
    [invocation invoke];
    
    return invocation;
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
