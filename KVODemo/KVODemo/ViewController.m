//
//  ViewController.m
//  KVODemo
//
//  Created by zpz on 2019/4/9.
//  Copyright © 2019 zpz. All rights reserved.
//

#import "ViewController.h"
#import "PLPerson.h"
#import <objc/runtime.h>
#import <objc/message.h>
#import "NSObject+Block_KVO.h"

@interface ViewController ()
@property (nonatomic, strong) PLPerson *person;
@end

@implementation ViewController

/*
 
 KVC一定会触发KVO
 
 KVC赋值顺序。
 
 setKey:
 _setKey:
 accessInstanceVal -> YES?
 _key
 _isKey
 key
 isKey
 
 KVC取值顺序
 getKey
 key
 isKey
 _key
 accessInstanceVal -> YES?
 _key
 _isKey
 key
 isKey

 
 */


/**
 * KVO为什么能够监听到属性变化，监听原理是什么？
 * 如何自己手动实现KVO？
 */

- (void)printMethodNamesOfClass:(Class)cls
{
    unsigned int count;
    Method *methodList = class_copyMethodList(cls, &count);
    NSMutableString *methodNames = [NSMutableString string];
    for (int i = 0; i < count; i++) {
        // 获得方法
        Method method = methodList[i];
        // 获得方法名
        NSString *methodName = NSStringFromSelector(method_getName(method));
        // 拼接方法名
        [methodNames appendString:methodName];
        [methodNames appendString:@", "];
    }
    free(methodList);
    NSLog(@"%@ %@", cls, methodNames);

}


- (void)viewDidLoad {
    [super viewDidLoad];
    self.person = [[PLPerson alloc] init];
//    [self.person addObserver:self forKeyPath:@"age" options:NSKeyValueObservingOptionNew context:@"123"];
    // personRealClass = NSKVONotifying_PLPerson
    Class personRealClass = object_getClass(self.person);
    // NSKVONotifying_PLPerson setAge:, class, dealloc, _isKVOA 内部重写了这4个方法
//    [self printMethodNamesOfClass:personRealClass];
    // supClass = MJPerson
//    Class supClass = class_getSuperclass(object_getClass(self.person));
    // iSA交换技术
    // Do any additional setup after loading the view, typically from a nib.
    
    [self.person PL_addObserver:self forKey:@"age" withBlock:^(id observedObject, NSString *observedKey, id oldValue, id newValue) {
        NSLog(@"%@ %@ %@ %@", observedObject, observedObject, oldValue, newValue);
    }];
    
    self.person.age = 10;
}

- (void)addSubviewTemp:(UIView *)view with:(NSString *)temp
{
    
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    // 断点可以看到函数调用栈，
    // _NSSetIntValueAndNotify 
    // self.person->isa  变为 NSKVONotifying_PLPerson， 是PLPerson的子类;
    self.person.age = 100;
    

}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context
{
    NSLog(@"%@", change);
}

@end
