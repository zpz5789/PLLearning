//
//  NSConditionLockDemo.m
//  MultithreadingDemo
//
//  Created by zpz on 2019/4/1.
//  Copyright © 2019 zpz. All rights reserved.
//

#import "NSConditionLockDemo.h"

@interface NSConditionLockDemo ()
@property (nonatomic, strong) NSConditionLock *conditionLock;
@end

@implementation NSConditionLockDemo
- (instancetype)init
{
    self = [super init];
    if (self) {
        self.conditionLock = [[NSConditionLock alloc] initWithCondition:1];
    }
    return self;
}

- (void)otherTest
{
    [[[NSThread alloc] initWithTarget:self selector:@selector(__one) object:nil] start];
    
    [[[NSThread alloc] initWithTarget:self selector:@selector(__two) object:nil] start];
    
    [[[NSThread alloc] initWithTarget:self selector:@selector(__three) object:nil] start];
}

- (void)__one
{
    [self.conditionLock lock];
    
    NSLog(@"__one");
    sleep(1);
    
    [self.conditionLock unlockWithCondition:2];
}

- (void)__two
{
    [self.conditionLock lockWhenCondition:2];
    
    NSLog(@"__two");
    sleep(1);
    
    [self.conditionLock unlockWithCondition:3];
}

- (void)__three
{
    [self.conditionLock lockWhenCondition:3];
    
    NSLog(@"__three");
    
    [self.conditionLock unlock];
}
@end
