//
//  CADisplayLinkController.m
//  TimerDemo
//
//  Created by zpz on 2019/3/13.
//  Copyright © 2019 zpz. All rights reserved.
//

#import "CADisplayLinkController.h"

@interface CADisplayLinkController ()
//@property (nonatomic, strong) CADisplayLink *link;
@end

@implementation CADisplayLinkController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    CADisplayLink *link = [CADisplayLink displayLinkWithTarget:self selector:@selector(linkTest)];
    // @property(nonatomic) NSInteger frameInterval
    // API_DEPRECATED("preferredFramesPerSecond", ios(3.1, 10.0),
    // watchos(2.0, 3.0), tvos(9.0, 10.0));
    
    link.preferredFramesPerSecond = 1;
    [link addToRunLoop:[NSRunLoop mainRunLoop] forMode:NSRunLoopCommonModes];

    // link 强引用self
}

- (void)linkTest
{
    NSLog(@"%s",__FUNCTION__);
}

- (void)dealloc
{
    NSLog(@"%s",__FUNCTION__);
//    [self.link invalidate];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
//    if (self.link) {
//        <#statements#>
//    }
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
