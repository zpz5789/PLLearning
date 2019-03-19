//
//  ViewController.m
//  RunLoopDemo
//
//  Created by zpz on 2019/3/14.
//  Copyright © 2019 zpz. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)tes1
{
    // 获取runloop
    [NSRunLoop currentRunLoop];
    CFRunLoopGetCurrent();
    
    // RunLoop和线程之间的关系 一条线程对应一个runloop
    // 主线程默认
    
}

- (void)tes2{
    
    
    
}
- (void)tes3{}
- (void)tes4{}
- (void)tes5{}
- (void)tes6{}
- (void)tes7{}
- (void)tes8{}
- (void)tes9{}
- (void)tes10{}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    
}
@end
