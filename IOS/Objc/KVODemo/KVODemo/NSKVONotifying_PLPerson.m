//
//  NSKVONotifying_PLPerson.m
//  KVODemo
//
//  Created by zpz on 2019/4/9.
//  Copyright © 2019 zpz. All rights reserved.
//  KVO伪代码

#import "NSKVONotifying_PLPerson.h"

@implementation NSKVONotifying_PLPerson
- (void)setAge:(int)age
{
    _NSSetIntValueAndNotify();
//    _NSSetDoubleValueAndNotify()
}

// 伪代码
void _NSSetIntValueAndNotify ()
{
    [self willChangeValueForKey:@"age"];
    [super setAge:age];
    [self didChangeValueForKey:@"age"];
}

- (void)didChangeValueForKey:(NSString *)key
{
    // 通知监听器，某某属性值发生了改变
    [oberser observeValueForKeyPath:key ofObject:self change:nil context:nil];
}

- (Class)class
{
    return [PLPerson class];
}

- (void)dealloc
{
    // 收尾工作
}

- (void)_isKVOA
{
    return YES;
}
@end
