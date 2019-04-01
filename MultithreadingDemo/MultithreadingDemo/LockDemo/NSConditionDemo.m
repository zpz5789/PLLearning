//
//  NSConditionDemo.m
//  MultithreadingDemo
//
//  Created by zpz on 2019/4/1.
//  Copyright © 2019 zpz. All rights reserved.
// 

#import "NSConditionDemo.h"

@interface NSConditionDemo ()
@property (nonatomic, strong) NSCondition *condition;
@property (strong, nonatomic) NSMutableArray *data;
@end

@implementation NSConditionDemo
- (instancetype)init
{
    self = [super init];
    if (self) {
        self.condition = [[NSCondition alloc] init];
        self.data = [NSMutableArray array];
    }
    return self;
}

- (void)otherTest
{
    [[[NSThread alloc] initWithTarget:self selector:@selector(__remove) object:nil] start];
    
    [[[NSThread alloc] initWithTarget:self selector:@selector(__add) object:nil] start];
}

// 线程1
// 删除数组中的元素
- (void)__remove
{
    [self.condition lock];
    NSLog(@"__remove - begin");
    
    if (self.data.count == 0) {
        // 等待
        [self.condition wait];
    }
    
    [self.data removeLastObject];
    NSLog(@"删除了元素");
    
    [self.condition unlock];
}

// 线程2
// 往数组中添加元素
- (void)__add
{
    [self.condition lock];
    
    sleep(1);
    
    [self.data addObject:@"Test"];
    NSLog(@"添加了元素");
    // 信号
    [self.condition signal];

    [self.condition unlock];
    
}

@end
