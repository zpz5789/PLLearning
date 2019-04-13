//
//  NSObject+Block_KVO.m
//  KVODemo
//
//  Created by zpz on 2019/4/13.
//  Copyright © 2019 zpz. All rights reserved.
//

#import "NSObject+Block_KVO.h"
#import <objc/runtime.h>
#import <objc/message.h>

/*
 是否能加锁 ？
 dispatch_async ？
整形类型 ？
 */

static NSString * const kPLkvoClassPrefix_for_Block = @"PLObserver_";
static NSString * const kPLkvoAssiociateObserver_for_Block = @"PLAssiociateObserver";


@interface PL_ObserverInfo_for_Block : NSObject

@property (nonatomic, weak) NSObject * observer;
@property (nonatomic, copy) NSString * key;
@property (nonatomic, copy) PL_ObservingHandler handler;

@end

@implementation PL_ObserverInfo_for_Block

- (instancetype)initWithObserver: (NSObject *)observer forKey: (NSString *)key observeHandler: (PL_ObservingHandler)handler
{
    if (self = [super init]) {
        
        self.observer = observer;
        self.key = key;
        self.handler = handler;
    }
    return self;
}

@end


#pragma mark -- Transform setter or getter to each other Methods
static NSString * setterForGetter(NSString *getter)
{
    // observedNum
    if(getter.length <= 0) {return nil;}
    // O
    NSString * firstString = [[getter substringToIndex: 1] uppercaseString];
    //bservedNum
    NSString * leaveString = [getter substringFromIndex: 1];
    // setObservedNum:
    return [NSString stringWithFormat: @"set%@%@:", firstString, leaveString];
}

static NSString * getterForSetter(NSString *setter)
{
    // setAge: -> age
    if (setter.length <= 0 || ![setter hasPrefix: @"set"] || ![setter hasSuffix: @":"]) {
        return nil;
    }
    NSRange range = NSMakeRange(3, setter.length - 4);
    // Age
    NSString * getter = [setter substringWithRange: range];
    // a
    NSString * firstString = [[getter substringToIndex: 1] lowercaseString];
    // age
    getter = [getter stringByReplacingCharactersInRange: NSMakeRange(0, 1) withString: firstString];
    return getter;
}

static Class kvo_Class(id self)
{
    return class_getSuperclass(object_getClass(self));
}

static void KVO_setter(id self, SEL _cmd, id newValue)
{
    NSString * setterName = NSStringFromSelector(_cmd);
    NSString * getterName = getterForSetter(setterName);
    // 如果没有getterName
    if (!getterName) {
        @throw [NSException exceptionWithName: NSInvalidArgumentException reason: [NSString stringWithFormat: @"unrecognized selector sent to instance %p", self] userInfo: nil];
        return;
    }
    
    id oldValue = [self valueForKey: getterName];
    // 父类结构体指针
    struct objc_super superClass = {
        .receiver = self,
        .super_class = class_getSuperclass(object_getClass(self))
    };
    
    [self willChangeValueForKey: getterName];
    // 调用父类的set方法
    // void (*)(void *, SEL, __strong id)
//    void (*objc_msgSendSuperKVO)(void *, SEL, id) = (void *)objc_msgSendSuper;
    // 函数指针
    void (*objc_msgSendSuperKVO)(void *, SEL, id) = (void *)objc_msgSendSuper;
    objc_msgSendSuperKVO(&superClass, _cmd, newValue);
    [self didChangeValueForKey: getterName];

    //获取所有监听回调对象进行回调
    NSMutableArray * observers = objc_getAssociatedObject(self, (__bridge const void *)kPLkvoAssiociateObserver_for_Block);
    for (PL_ObserverInfo_for_Block * info in observers) {
        if ([info.key isEqualToString: getterName]) {
            dispatch_async(dispatch_queue_create(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                info.handler(self, getterName, oldValue, newValue);
            });
        }
    }
}

@implementation NSObject (Block_KVO)



- (void)PL_addObserver:(NSObject *)observer
                forKey:(NSString *)key
             withBlock:(PL_ObservingHandler)observedhandler
{
    // 判断源类是否有get setter 方法，没有的话就抛出异常
    SEL setterSelector = NSSelectorFromString(setterForGetter(key));
    Method setterMethod = class_getInstanceMethod([self class], setterSelector);
    if (!setterMethod) {
        @throw [NSException exceptionWithName: NSInvalidArgumentException reason: [NSString stringWithFormat: @"unrecognized selector sent to instance %@", self] userInfo: nil];
        return;
    }
    
    // 创建一个新的子类，重写setter方法
    Class observedClass = object_getClass(self);
    NSString * className = NSStringFromClass(observedClass);
    // 判断kvo真实类是否创建
    if (![className hasPrefix:kPLkvoClassPrefix_for_Block]) {
        // 创建新类，交换isa
        observedClass = [self createKVOClassWithOriginalClassName:className];
        object_setClass(self, observedClass);
    }
    
    
    // 添加kvo类的setter
    if (![self hasSelector: setterSelector]) {
        const char * types = method_getTypeEncoding(setterMethod);
        class_addMethod(observedClass, setterSelector, (IMP)KVO_setter, types);
    }
    // 保存观察者类和block关联起来，当调用kvo类后通知调用block
    NSMutableArray * observers = objc_getAssociatedObject(self, (__bridge void *)kPLkvoAssiociateObserver_for_Block);
    
    if (!observers) {
        observers = [NSMutableArray array];
        objc_setAssociatedObject(self, (__bridge void *)kPLkvoAssiociateObserver_for_Block, observers, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    
    PL_ObserverInfo_for_Block * newInfo = [[PL_ObserverInfo_for_Block alloc] initWithObserver: observer forKey: key observeHandler: observedhandler];
    [observers addObject:newInfo];
}

- (void)PL_removeObserver:(NSObject *)object forKey:(NSString *)key
{
    NSMutableArray * observers = objc_getAssociatedObject(self, (__bridge void *)kPLkvoAssiociateObserver_for_Block);
    
    PL_ObserverInfo_for_Block * observerRemoved = nil;
    for (PL_ObserverInfo_for_Block * observerInfo in observers) {
        
        if (observerInfo.observer == object && [observerInfo.key isEqualToString: key]) {
            
            observerRemoved = observerInfo;
            break;
        }
    }
    [observers removeObject: observerRemoved];
}



- (Class)createKVOClassWithOriginalClassName: (NSString *)className
{
    // 类名 PLObserver_ + 原始类名
    NSString * kvoClassName = [kPLkvoClassPrefix_for_Block stringByAppendingString: className];
    Class observedClass = NSClassFromString(kvoClassName);
    if (observedClass) {
        return observedClass;
    }
    
    // 创建新类 objc_allocateClassPair
    Class superClass = object_getClass(self);
    Class kvoClass = objc_allocateClassPair(superClass, kvoClassName.UTF8String, 0);
    
    // 替换isa 当调用set方法时候会去isa指针指向的类中去找方法
    Method classMethod = class_getInstanceMethod(superClass, @selector(class));
    const char * types = method_getTypeEncoding(classMethod);
    // 添加class方法 欺骗外部调用者
    class_addMethod(kvoClass, @selector(class), (IMP)kvo_Class, types);
    objc_registerClassPair(kvoClass);
    return kvoClass;
}

- (BOOL)hasSelector:(SEL)selector
{
    Class observedClass = object_getClass(self);
    unsigned int methodCount = 0;
    Method * methodList = class_copyMethodList(observedClass, &methodCount);
    for (int i = 0; i < methodCount; i++) {
        Method method = methodList[i];
        SEL methodSel = method_getName(method);
        if (methodSel == selector) {
            free(methodList);
            return YES;
        }
    }
    free(methodList);
    return NO;
}


@end
