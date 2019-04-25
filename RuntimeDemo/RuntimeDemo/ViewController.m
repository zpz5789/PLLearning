//
//  ViewController.m
//  RuntimeDemo
//
//  Created by zpz on 2019/4/15.
//  Copyright © 2019 zpz. All rights reserved.
//

#import "ViewController.h"
#import <objc/runtime.h>
#import <objc/message.h>
@interface ViewController ()

@end

@implementation ViewController

/*
 什么是runtime?
 OC是一门动态性比较强的编程语言，允许很多操作推迟到程序运行时再进行
 OC的动态性就是由Runtime来支撑和实现的，Runtime是一套C语言的API，封装了很多动态性相关的函数
 平时编写的OC代码，底层都是转换成了Runtime API进行调用
 
 什么是isa?
 在arm64架构之前，isa就是一个普通的指针，存储着Class/Meta-Class对象的内存地址。
 在arm64架构开始，对isa进行了优化，变成了一个公用体（union结构），还使用位域来存储更多信息。
 
 对象的isa& ISA_MASK 指向类对象  类对象的isa& ISA_MASK指向元类。
 
 
 isa优化成公用体好处？为什么这么做？
 
 利用公用体和位域技术进行优化，不仅仅是存储类Class/Meta-Class对象的内存地址，还存储着更多的信息。
 bits来存储
 
 struct作用仅仅只是增强可读性。
 
 类对象、元类对象的地址值 最后三位都是零， 按ISA_MASK掩码运算后 三位为0
 
 isa & ISA_MASK = Class/Meta-Class对象的内存地址；
 
 
 union isa_t
 {
 Class cls;
 uintptr_t bits;
 # if __arm64__
 #   define ISA_MASK        0x0000000ffffffff8ULL
 #   define ISA_MAGIC_MASK  0x000003f000000001ULL
 #   define ISA_MAGIC_VALUE 0x000001a000000001ULL
 struct {
 uintptr_t nonpointer        : 1;
 uintptr_t has_assoc         : 1;
 uintptr_t has_cxx_dtor      : 1;
 uintptr_t shiftcls          : 33; // MACH_VM_MAX_ADDRESS 0x1000000000
 uintptr_t magic             : 6;
 uintptr_t weakly_referenced : 1;
 uintptr_t deallocating      : 1;
 uintptr_t has_sidetable_rc  : 1;
 uintptr_t extra_rc          : 19;
 #       define RC_ONE   (1ULL<<45)
 #       define RC_HALF  (1ULL<<18)
 };
 
 }
 
 nonpointer：0 ，代表普通指针，存储这class/mateclass对象的内存地址  1，代表优化过，使用位域技术存储更多信息。
 has_assoc：是否有设置过关联对象，如果没有，释放时候会更快。
 has_cxx_dtor： 代表有没有c++的析构函数。如果没有，释放的更快。表示当前对象有 C++ 或者 ObjC 的析构器(destructor)，如果没有析构器就会快速释放内存。
 shiftcls： 33位存储着类对象的地址值。存储Class/Meta-Class对象的内存地址
 magic：用于在调试时分辨对象是否未完成初始化  用于调试器判断当前对象是真的对象还是没有初始化的空间
 weakly_referenced： 对象是否曾经弱引用过。对象被指向或者曾经指向一个 ARC 的弱变量，没有弱引用的对象可以更快释放

 deallocating： 对象是否正在释放
 extra_rc：里面存储的值是引用计数器减1 19位
 has_sidetable_rc：引用计数器是否过大无法存储在isa中，如果为1，那么引用计数会存储在一个叫SideTable的类的属性中
 
 // 从销毁函数可以看出 没有has_assoc has_cxx_dtor等释放的更快
 void *objc_destructInstance(id obj)
 {
 if (obj) {
 // Read all of the flags at once for performance.
 bool cxx = obj->hasCxxDtor();
 bool assoc = obj->hasAssociatedObjects();
 
 // This order is important.
 if (cxx) object_cxxDestruct(obj);
 if (assoc) _object_remove_assocations(obj);
 obj->clearDeallocating();
 }
 
 return obj;
 }
 */

/*
 方法：
 
 rw-t
 ro-t
 
 
 method_t 数据结构
 
 struct method_t{
 SEL name;
 const char *types;
 IMP imp;
 }
 
 types;怎么计算的？
 
 imp 函数地址。
 
 
 
 方法调用：方法缓存
 1. 先根据isa去类对象里面的方法缓存列表cache_t cache里面找方法，如果类对象方法缓存列表中没有找到，就去类的bits class_data_bits_t中的方法列表查找，方法列表中找到则调用，否则根据类对象的supclass指针去父类重复以上操作。
    如果找到了则调用，并将方法缓存到类对象的方法列表中。
 

    cache是用散列表来缓存曾经调用过的方法，可以提高方法的查找速度。key为@selector value 为imp
 
 struct cache_t {
 struct bucket_t *_buckets;//散列表
 mask_t _mask;// 散列表的长度 -1
 mask_t _occupied;// 已经缓存的方法数量
 }
 
 为什么散列表快？
 @selector & maks 得到索引，直接位运算取出索引里面的值。 冲突的时候，索引-1 ，如果减到零的话，就让索引=mask-1
 */

/*
 OC的消息发送机制
 OC中的方法调用其实都是转成了objc_msgSend函数的调用，给receiver（方法调用者）发送了一条消息（selector方法名）
 
 两个隐藏参数 receiver/  _cmd   self, _cmd
 
 objc_msgSend底层有3大阶段
 
 消息发送（当前类、父类中查找）、动态方法解析、消息转发
 
 objc_msgSend()调用流程，三大阶段
 1. 消息发送
 
 2. 动态方法解析
 
 3. 消息转发
 
 
 [super message] 的底层实现
 1、消息接受者仍然是子类对象、
 2、查找方法从父类开始。
 
 
 isMemberOfClass 和 isKindOfClass 区别
 + isMemberOfClass isKindOfClass 元类比较
 - isMemberOfClass isKindOfClass 类比较
 
 - (BOOL)isMemberOfClass:(Class)cls {
     return [self class] == cls;
 }
 
 - (BOOL)isKindOfClass:(Class)cls {
     for (Class tcls = [self class]; tcls; tcls = tcls->superclass) {
         if (tcls == cls) return YES;
     }
     return NO;
 }
 
 
 + (BOOL)isMemberOfClass:(Class)cls {
     return object_getClass((id)self) == cls;
 }
 
 
 + (BOOL)isKindOfClass:(Class)cls {
     for (Class tcls = object_getClass((id)self); tcls; tcls = tcls->superclass) {
         if (tcls == cls) return YES;
     }
     return NO;
 }

 */
- (void)viewDidLoad {
    [super viewDidLoad];
//    objc_msgSend()
//    objc_msgSend(<#id receiver#>, <#SEL selector#>)
    // objc_msgSend(person, @selector(personTest));
    // 消息接收者（receiver）：person
    // 消息名称：personTest
    // Do any additional setup after loading the view, typically from a nib.
    objc_getClass(<#const char * _Nonnull name#>)
    
//    @synthesize与@dynamic区别   控制生成get/set方法的实现。
//    object_isClass(self);
}


- (void)test
{
    
}

@end
