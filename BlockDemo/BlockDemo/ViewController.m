//
//  ViewController.m
//  BlockDemo
//
//  Created by zpz on 2019/4/12.
//  Copyright © 2019 zpz. All rights reserved.
//

#import "ViewController.h"
#import "PLReferenceCycleController.h"
@interface ViewController ()<UITableViewDelegate, UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSDictionary *titleDict;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.titleDict = @{
                       @"block底层结构" : [PLReferenceCycleController class],
                       @"block引用循环": [PLReferenceCycleController class]
                       };
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView
 numberOfRowsInSection:(NSInteger)section {
    return self.titleDict.allKeys.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellId = @"cellId";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellId];
    }
    cell.textLabel.text = [self.titleDict.allKeys objectAtIndex:indexPath.row];
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    Class destinationVcClass = [self.titleDict.allValues objectAtIndex:indexPath.row];
    UIViewController *destinationVc = [[destinationVcClass alloc] init];
    destinationVc.title = [self.titleDict.allKeys objectAtIndex:indexPath.row];
    destinationVc.view.backgroundColor = [UIColor whiteColor];
    [self.navigationController pushViewController:destinationVc animated:YES];
}


@end
