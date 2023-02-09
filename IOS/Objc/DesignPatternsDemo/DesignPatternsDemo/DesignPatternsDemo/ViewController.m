//
//  ViewController.m
//  DesignPatternsDemo
//
//  Created by zpz on 2017/10/23.
//  Copyright © 2017年 zpz. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()<UITableViewDelegate, UITableViewDataSource>
@property(nonatomic, strong) UITableView *tableView;
@property(nonatomic, strong) NSArray *patternNames;
@end

@implementation ViewController

- (void)viewDidLoad {
    //AbstractFactory
    [super viewDidLoad];
    [self loadData];
    [self buildUI];
    // Do any additional setup after loading the view, typically from a nib.
}


#pragma mark - TableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _patternNames.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifer = @"cellID";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifer];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:identifer];
    }
    cell.textLabel.text = [NSString stringWithFormat:@"%ld. %@",indexPath.row + 1,[_patternNames objectAtIndex:indexPath.row]];
    return cell;
}

#pragma mark - privte
- (void)loadData
{
    _patternNames =  @[
                       @"SimpleFactory",
                       @"FactoryMethod",
                       @"AbstractFactory",
                       @"Singleton",
                       @"Prototype",
                       @"Builder",
                       @"State",
                       @"Observer",
                       @"Mediator",
                       @"Command",
                       @"Chain of Responsibility",
                       @"Proxy Pattern",
                       @"Decorator",
                       @"Composite",
                       @"Adapter",
                       @"Facade",
                       @"",
                       @"",
                       ];
}


- (void)buildUI
{
    self.title = @"DesignPatterns";
    _tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [self.view addSubview:_tableView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
