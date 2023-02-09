//
//  PLPerson.m
//  RuntimeDemo
//
//  Created by zpz on 2019/4/16.
//  Copyright © 2019 zpz. All rights reserved.
//

#import "PLPerson.h"
#import <objc/runtime.h>
#import <objc/message.h>

@implementation PLPerson
//@synthesize a = _a;
@dynamic a;

- (void)test
{
    
}

void c_other(id self, SEL _cmd)
{
    NSLog(@"");
}

// 动态方法解析
+ (BOOL)resolveInstanceMethod:(SEL)sel
{
    if (sel == @selector(test)) {
        
//        Method method = class_getInstanceMethod(self, @selector(test));
//        class_addMethod(self, @selector(test), method_getImplementation(method), method_getTypeEncoding(method));
     
        class_addMethod(self, sel, (IMP)c_other, "v16@0:8");
        
        return YES;
    }
    return [super resolveInstanceMethod:sel];
}

+ (BOOL)resolveClassMethod:(SEL)sel
{
    return YES;
}

// 消息转发

- (id)forwardingTargetForSelector:(SEL)aSelector
{
    return [super forwardingTargetForSelector:aSelector];
}

+ (id)forwardingTargetForSelector:(SEL)aSelector
{
    return [super forwardingTargetForSelector:aSelector];
}
// 不能自己呼出
+ (NSMethodSignature *)methodSignatureForSelector:(SEL)aSelector
{
    return [super instanceMethodSignatureForSelector:aSelector];
}

- (NSMethodSignature *)methodSignatureForSelector:(SEL)aSelector
{
    return [super methodSignatureForSelector:aSelector];
}
//NSInvocation封装了一个方法调用

+ (void)forwardInvocation:(NSInvocation *)anInvocation
{
    
}

- (void)forwardInvocation:(NSInvocation *)anInvocation
{
//    anInvocation.selector
//    anInvocation.target
//    anInvocation getArgument:NULL atIndex:0
}

@end
