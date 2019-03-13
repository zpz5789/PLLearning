//
//  ViewController.m
//  TimerDemo
//
//  Created by zpz on 2019/3/13.
//  Copyright © 2019 zpz. All rights reserved.
//

#import "ViewController.h"
#import "CADisplayLinkController.h"
#import "GCDTimerController.h"
#import "NSTimerController.h"

@interface ViewController ()<UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) NSTimer *timer;
@property (nonatomic, strong) NSArray *dataSource;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _dataSource = @[@"NSTimerController",@"CADisplayLinkController",@"GCDTimerController"];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TimerDemoCell" forIndexPath:indexPath];
    cell.textLabel.text = _dataSource[indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSString *controllerName = self.dataSource[indexPath.row];
    UIViewController * destinationVC = [[NSClassFromString(controllerName) alloc] init];
    destinationVC.view.backgroundColor = [UIColor whiteColor];
    destinationVC.navigationItem.title = controllerName;
    [self.navigationController pushViewController:destinationVC animated:YES];
}

@end
