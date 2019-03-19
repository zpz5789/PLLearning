//
//  ViewController.m
//  RunLoopDemo
//
//  Created by zpz on 2019/3/14.
//  Copyright © 2019 zpz. All rights reserved.
//

#import "ViewController.h"
#import "RunLoopController3.h"
@interface ViewController ()<UITableViewDelegate, UITableViewDataSource>

@end

@implementation ViewController
{
    NSArray *_dataSource;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    _dataSource = @[@"RunLoop理论知识",@"RunLoop与NSTimer",@"RunLoop线程保活"];
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView
 numberOfRowsInSection:(NSInteger)section {
    return _dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    cell.textLabel.text = [_dataSource objectAtIndex:indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    RunLoopController3 *runLoopCl = [[RunLoopController3 alloc] init];
    
    [self.navigationController pushViewController:runLoopCl animated:YES];
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
