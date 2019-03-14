//
//  CADisplayLinkController.m
//  TimerDemo
//
//  Created by zpz on 2019/3/13.
//  Copyright © 2019 zpz. All rights reserved.
//

#import "CADisplayLinkController.h"
#import "PLProxy.h"
#import "PLProxy1.h"
@interface CADisplayLinkController ()
@property (nonatomic, strong) CADisplayLink *link;
@end

@implementation CADisplayLinkController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self test];
    [self test1];
    [self test2];
    

//   用weakSelf 无法解决 此处内存泄露问题，因为 displayLinkWithTarget:self  内部会对 self进去strong强引用
//    __weak typeof(self) weakSelf = self;
    
    
//    Runloop *runloop
    
    // link 强引用self
}


/**
 tartet 直接传入self会造成 控制器无法释放， 原因 [NSRunLoop mainRunLoop] 持有 link , link 持有self , self 有强引用，不会调用dealloc , [link invalidate] 方法无法调用， 造成 self 和 link 都无法释放，内存泄露
 */
- (void)test
{
    CADisplayLink *link = [CADisplayLink displayLinkWithTarget:self selector:@selector(linkTest)];
    self.link = link;
    link.preferredFramesPerSecond = 1;
    [link addToRunLoop:[NSRunLoop mainRunLoop] forMode:NSRunLoopCommonModes];
}


/**
 通过 引入 PLProxy 中间对象， PLproxy 对象对 self 弱引用，即导航栏pop时 self无强引用，调用dealloc [link invalidate]， link 销毁， self 释放。 其中  PLProxy 对象中用了消息转发
 */
- (void)test1
{
    PLProxy *proxy = [[PLProxy alloc] init];
    proxy.target = self;
    CADisplayLink *link = [CADisplayLink displayLinkWithTarget:proxy selector:@selector(linkTest)];
    self.link = link;
    link.preferredFramesPerSecond = 1;
    [link addToRunLoop:[NSRunLoop mainRunLoop] forMode:NSRunLoopCommonModes];
}

- (void)test2
{
    CADisplayLink *link = [CADisplayLink displayLinkWithTarget:[PLProxy1 proxyWithTarget:self] selector:@selector(linkTest)];
    self.link = link;
    link.preferredFramesPerSecond = 1;
    [link addToRunLoop:[NSRunLoop mainRunLoop] forMode:NSRunLoopCommonModes];
}

- (void)linkTest
{
    NSLog(@"%s",__FUNCTION__);
}

- (void)dealloc
{
    NSLog(@"%s",__FUNCTION__);
    [self.link invalidate];
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
