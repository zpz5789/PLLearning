//
//  PLReferenceCycleController.m
//  BlockDemo
//
//  Created by zpz on 2019/4/12.
//  Copyright © 2019 zpz. All rights reserved.
//

#import "PLReferenceCycleController.h"

@interface PLObject : NSObject

@property (nonatomic, copy) void (^block)(void);
@property (nonatomic, assign) int var;
@end

@implementation PLObject
- (void)dealloc
{
    NSLog(@"%s",__FUNCTION__);
}
@end

@interface PLReferenceCycleController ()

@end

@implementation PLReferenceCycleController

- (void)viewDidLoad {
    [super viewDidLoad];
    /*
     object对象强引用自己的成员变量block，block在堆上开辟内存自动捕获object对象并且内部会强引用object对象，object指针强引用object对象，导致作用域结束后，只有object指针对object对象的强引用释放，而object对象和block对象依然相互引用，双方都无法释放导致内存泄露。
     解决方法：
     ARC中
     1. 用weak指针指向object对象，此时block捕获weak指针，block内部对object 弱指针指向的对象弱引用从而打破引用循环。
     2. 用__unsafe_unretained指针指向object对象，此时block捕获weak指针，block内部对object 弱指针指向的对象弱引用从而打破引用循环。
     __unsafe_unretained 和 weak的区别 ？ 都是弱引用，区别在于，
     当指向的对象销毁时, __unsafe_unretained指针会依然指向之前的内存空间(野指针)
     当对象销毁时,__weak指针会自动指向nil
     3. __block方法，先调用block(),然后再在block里面把block里面指向对象的指针置空，破除 block对对象的引用，从而打破引用循环。
     
     MRC环境下没有__weak,有两种方法打破循环引用
     1. __unsafe_unretained 和 __block， 其中__unsafe_unretained原理和ARC一样，__block能够解决的原因是MRC环境下，__block修饰生成的底层对象不会对其修饰的对象进行强引用。如下代码
     ···
     __block PLObject *object = [[PLObject alloc] init];
     object.block = ^{
     object.var = 2;
     };
     ···
     */
    
    
//    [self test1];
    [self test3];
    // Do any additional setup after loading the view.
}

- (void)test1
{
    PLObject *object = [[PLObject alloc] init];
    object.block = ^{
        object.var = 2;
    };
    NSLog(@"------");
}

- (void)test2
{
    PLObject *object = [[PLObject alloc] init];
    __weak typeof(object) weakObj = object;
//    __unsafe_unretained typeof(object) weakObj = object;

    object.block = ^{
        weakObj.var = 2;
    };
    NSLog(@"------");
}

- (void)test3
{
    __block PLObject *object = [[PLObject alloc] init];
//    __weak typeof(object) weakObj = object;
    //    __unsafe_unretained typeof(object) weakObj = object;
    
    object.block = ^{
        object.var = 2;
        object = nil;
    };
    
    object.block();
    NSLog(@"------");
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
