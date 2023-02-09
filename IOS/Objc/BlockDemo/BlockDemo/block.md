# block


## block的本质？

block本质是一个OC对象，因为内部有isa指针。
block是封装了函数和函数调用环境的OC对象。 


## block的底层结构

我们借助clang转换OC为C++代码，命令如下：

```
xcrun -sdk iphoneos clang -arch arm64 -rewrite-objc -fobjc-arc -fobjc-runtime=ios-8.0.0 main.m
```

```c
void (^block)() = ^{
    NSLog(@"I am block");
};
block();
```

转化为

```c
void (*block)() = ((void (*)())&__main_block_impl_0((void *)__main_block_func_0, &__main_block_desc_0_DATA));

((void (*)(__block_impl *))((__block_impl *)block)->FuncPtr)((__block_impl *)block);
```

简化为：

```
void (*block)() = &__main_block_impl_0(__main_block_func_0, &__main_block_desc_0_DATA);
        
(block)->FuncPtr)(block);
```
可知block定义 为一个 `&__main_block_impl_0`的函数指针，它有两个参数分别传入了 `__main_block_func_0` 和 `__main_block_desc_0_DATA`，
调用block可以看到是 调用block的`FuncPtr`指针找到一个函数，然后将block自身作为参数传入。
下面来看看`__main_block_impl_0`底层结构：

```
struct __main_block_impl_0 {
    struct __block_impl impl;//__block_impl类型的结构体
    struct __main_block_desc_0* Desc; //__main_block_desc_0类型的结构体
    // __main_block_impl_0是c++结构体构造函数
    __main_block_impl_0(void *fp, struct __main_block_desc_0 *desc, int flags=0) {
        impl.isa = &_NSConcreteStackBlock;
        impl.Flags = flags;
        impl.FuncPtr = fp;
        Desc = desc;
    }
};
```

__block_impl 结构体长这样：

```
struct __block_impl {
    void *isa;// 指向block的类型
    int Flags;
    int Reserved;// 保留字段
    void *FuncPtr; // 函数指针，指向block代码段的地址
};
```

__main_block_desc_0结构体长这样：

```
static struct __main_block_desc_0 {
    size_t reserved;// 保留字段
    size_t Block_size;// block大小
} __main_block_desc_0_DATA = { 0, sizeof(struct __main_block_impl_0)};// 传入两个参数初始化
```

底层架构如下图所示：

![](media/15548863584096/15550641283030.jpg)

## block变量捕获


```
int a = 10;
void (^block)() = ^{
NSLog(@"I am block %d", a);
};
int a = 20;
// 输出为10，
```
转换成c++后代码如下：

```c
  struct __main_block_impl_0 {
  struct __block_impl impl;
  struct __main_block_desc_0* Desc;
  int a;
  __main_block_impl_0(void *fp, struct __main_block_desc_0 *desc, int _a, int flags=0) : a(_a) {
    impl.isa = &_NSConcreteStackBlock;
    impl.Flags = flags;
    impl.FuncPtr = fp;
    Desc = desc;
  }
};
```
可以看到block会捕获自动变量使其变为它的一个成员变量，且结构体的构造函数也发生改变，增加了一个参数`int _a`。block内部使用a的时候，` int a = __cself->a; // bound by copy`，可知读取的是block内部的a。 故在block外面修改a的值不影响block内部输出。

我们再来看看其他变量的一些情况

```
int c = 10;
static int d = 10;

int main(int argc, const char * argv[]) {
    @autoreleasepool {
        
        int a = 10;
        static int b = 10;
        void (^block)() = ^{
            NSLog(@"a %d b %d c %d d %d", a, b, c, d);
        };
        a = 20;
        b = 20;
        c = 20;
        d = 20;
        block();
        // 输出 a 10 b 20 c 20 d 20
    }
    return 0;
}
```
转化为：

```
struct __main_block_impl_0 {
  struct __block_impl impl;
  struct __main_block_desc_0* Desc;
  int a;
  int *b;
  __main_block_impl_0(void *fp, struct __main_block_desc_0 *desc, int _a, int *_b, int flags=0) : a(_a), b(_b) {
    impl.isa = &_NSConcreteStackBlock;
    impl.Flags = flags;
    impl.FuncPtr = fp;
    Desc = desc;
  }
};

static void __main_block_func_0(struct __main_block_impl_0 *__cself) {
  int a = __cself->a; // bound by copy
  int *b = __cself->b; // bound by copy

            NSLog((NSString *)&__NSConstantStringImpl__var_folders_qf_5zn_z9zn5td5c6thrwfmdy6m0000gn_T_main_e050fd_mi_0, a, (*b), c, d);
        }
```
可知，a， b被捕获到了block内部，c，d不影响。a , b有区别，a是在block内部创建一个新的变量所以外部改变不影响内部输出，b是以&b的形式被捕获即指针被捕获，所以在block外部修改b会影响block内部的b，从而影响输出b的值。 c和d我们不难理解，全局变量和静态全局变量不受block捕获，因为它们的作用域是全局的可以直接访问，存在数据区域。

我们得出block变量捕获规则：

| 变量类型 | 捕获到block内部 | 访问方式 |
| --- | --- | --- |
| auto局部变量 | ✔️ | 值传递 |
| static局部变量 | ✔️ | 指针传递 |
| 全局变量 | ❌ | 直接访问 |


## block类型

block有3种类型，可以通过调用class方法或者isa指针查看具体类型，最终都是继承自NSBlock类。

* [ ] __NSGlobalBlock__  (_NSConcreteGlobalBlock) 存放在全局区(.data)
* [ ] __NSSTackBlock__ (_NSConcreteStackBlock) 存放在栈区
* [ ] __NSMallocBlock__ (_NSConcreteMallocBlock) 存放在堆区

```
        void (^block1)(void) = ^{
            NSLog(@"Hello");
        };
        
        int age = 10;
        void (^block2)(void) = ^{
            NSLog(@"Hello - %d", age);
        };
        
        NSLog(@"%@ %@ %@", [block1 class], [block2 class], [^{
            NSLog(@"%d", age);
        } class]);
        // 输出：__NSGlobalBlock__ __NSMallocBlock__ __NSStackBlock__
```

判断block类型：

| block类型 |  环境 |
| :-: | :-: |
| __NSGlobalBlock__ | 没有访问auto变量 |
| __NSStackBlock__ | 访问了auto变量 |
| __NSStackBlock__ | 调用了copy |

每一种类型的block调用copy后的结果如下所示


| block的类型 | 副本源的配置存储域 | 复制效果 |
| :-: | :-: | :-: |
| __NSGlobalBlock__ | 程序的数据区域 | 什么也不做 |
| __NSStackBlock__ | 栈 | 复制到堆上 |
| __NSMallocBlock__ | 堆 | 引用计数增加 |


## ARC对block做了什么

在ARC环境下，编译器会根据情况自动将栈上的block复制到堆上，比如以下情况:

* [ ] block作为函数返回值时候
* [ ] 将block赋值给__strong指针时
* [ ] block作为Cocoa API中方法名含有usingBlock的方法参数时
* [ ] block作为GCD API的方法参数时候

所以MRC block属性建议写法

```c
@property (copy, nonatomic) void (^block)(void);
```
ARC block属性建议写法

```c
@property (strong, nonatomic) void (^block)(void);
@property (copy, nonatomic) void (^block)(void);
```

## 对象类型的auto变量

```
PLPerson *person = [[PLPerson alloc] init];
void (^block)(void) = ^{
    NSLog(@"%@",person);
};
```
转换成c++为

```
struct __main_block_impl_0 {
  struct __block_impl impl;
  struct __main_block_desc_0* Desc;
  PLPerson *__strong strongPerson;
  PLPerson *__weak weakPerson;
  __main_block_impl_0(void *fp, struct __main_block_desc_0 *desc, PLPerson *__strong _strongPerson, PLPerson *__weak _weakPerson, int flags=0) : strongPerson(_strongPerson), weakPerson(_weakPerson) {
    impl.isa = &_NSConcreteStackBlock;
    impl.Flags = flags;
    impl.FuncPtr = fp;
    Desc = desc;
  }
};

static struct __main_block_desc_0 {
  size_t reserved;
  size_t Block_size;
  void (*copy)(struct __main_block_impl_0*, struct __main_block_impl_0*);
  void (*dispose)(struct __main_block_impl_0*);
} __main_block_desc_0_DATA = { 0, sizeof(struct __main_block_impl_0), __main_block_copy_0, __main_block_dispose_0};

```

由上可知 对象被block捕获了，且对象修饰符不变，__main_block_desc_0 结构发生了变化，内部多了

```
 void (*copy)(struct __main_block_impl_0*, struct __main_block_impl_0*);
 void (*dispose)(struct __main_block_impl_0*);
```
 两个和内存管理相关的成员变量指针 *copy 和 *dispose。
 
 copy和dispose函数实现如下：
 
 ```
 static void __main_block_copy_0(struct __main_block_impl_0*dst, struct __main_block_impl_0*src) {
    _Block_object_assign((void*)&dst->strongPerson, (void*)src->strongPerson, 3/*BLOCK_FIELD_IS_OBJECT*/);
    _Block_object_assign((void*)&dst->weakPerson, (void*)src->weakPerson, 3/*BLOCK_FIELD_IS_OBJECT*/);
}

static void __main_block_dispose_0(struct __main_block_impl_0*src) {
    _Block_object_dispose((void*)src->strongPerson, 3/*BLOCK_FIELD_IS_OBJECT*/);
    _Block_object_dispose((void*)src->weakPerson, 3/*BLOCK_FIELD_IS_OBJECT*/);
}
 ```

可以看出两个函数是拿到block对象里面所捕获到的对象变量指针进行操作。

> block被拷贝到堆上

当block被拷贝到堆上时候，会调用block内部的copy函数将block拷贝一份到堆上；copy内部会调用 `_Block_object_assign`函数，`_Block_object_assign`函数会根据auto变量的修饰符（__strong，__weak，__unsafe_unretained）作出相应的操作，形成强引用（retain）或者弱引用。

> block从堆上移除

当block从堆上移除的时候，会调用block内部的dispose函数；
dispose函数内部会调用`_Block_object_dispose`函数；
`_Block_object_dispose`函数会自动释放引用的auto变量。


## __block 修饰符

__block修饰符的作用是解决block内部无法修改auto变量值的问题。


```
__block int a = 10;
__block PLPerson *blockPerson = [[PLPerson alloc] init];
__strong PLPerson *strongPerson = [[PLPerson alloc] init];
PLPerson *person = [[PLPerson alloc] init];
__weak PLPerson *weakPerson = person;
void (^block)(void) = ^{
    NSLog(@"%@ %@ %d %@",strongPerson, weakPerson, a++ , blockPerson);
};
block();
```
转化为c++代码如下：

```
struct __main_block_impl_0 {
  struct __block_impl impl;
  struct __main_block_desc_0* Desc;
  PLPerson *__strong strongPerson;
  PLPerson *__weak weakPerson;
  __Block_byref_a_0 *a; // by ref
  __Block_byref_blockPerson_1 *blockPerson; // by ref
  __main_block_impl_0(void *fp, struct __main_block_desc_0 *desc, PLPerson *__strong _strongPerson, PLPerson *__weak _weakPerson, __Block_byref_a_0 *_a, __Block_byref_blockPerson_1 *_blockPerson, int flags=0) : strongPerson(_strongPerson), weakPerson(_weakPerson), a(_a->__forwarding), blockPerson(_blockPerson->__forwarding) {
    impl.isa = &_NSConcreteStackBlock;
    impl.Flags = flags;
    impl.FuncPtr = fp;
    Desc = desc;
  }
};
```
__block修饰的对象被包装成了一个类似` __Block_byref_a_0 *a; `` __Block_byref_blockPerson_1 *blockPerson; `这样的对象。


```
struct __Block_byref_a_0 {
  void *__isa; // 类型
__Block_byref_a_0 *__forwarding;// 指向自己的指针
 int __flags;
 int __size;
 int a; // 
};
struct __Block_byref_blockPerson_1 {
  void *__isa;
__Block_byref_blockPerson_1 *__forwarding;
 int __flags;
 int __size;
 void (*__Block_byref_id_object_copy)(void*, void*);
 void (*__Block_byref_id_object_dispose)(void*);
 PLPerson *__strong blockPerson; // 
};

```
__Block_byref_blockPerson_1结构体对象结构有和内存相关的指针`__Block_byref_id_object_copy`和`_Block_byref_id_object_dispose`，它们的实现如下：

```
static void __Block_byref_id_object_copy_131(void *dst, void *src) {
 _Block_object_assign((char*)dst + 40, *(void * *) ((char*)src + 40), 131);
}
static void __Block_byref_id_object_dispose_131(void *src) {
 _Block_object_dispose(*(void * *) ((char*)src + 40), 131);
}
```
函数里面`(char*)dst + 40 `指的就是  `PLPerson *__strong blockPerson; ` 指针。

- 当block在栈上时候，并不会对__block变量产生强引用。
- 当block变量被copy到堆时，首先会调用block内部的copy函数，copy函数内部会调用`_Block_object_assign`函数，`_Block_object_assign`函数会对指向对象的修饰符（__strong，__weak，__unsafe_unretained）做出相应操作，形成强引用或者弱引用。（注意：这里仅限于ARC时会retain, MRC不会retain）
- 当block从堆中移除时，会调用block内部的dispose函数，然后dispose函数内部会调用`_Block_object_dispose`函数，`_Block_object_dispose`函数会自动释放指向的对象。

> __forwarding指针的意义

栈上的block中__forwarding指针指向自己
当block被拷贝到堆时，栈上的block中的__forwarding指针指向堆上的block,堆上的block中的__forwarding指针指向自身。如下图所示:![屏幕快照 2019-04-12 18.04.13](media/15548863584096/%E5%B1%8F%E5%B9%95%E5%BF%AB%E7%85%A7%202019-04-12%2018.04.13.png)


block对象都是通过__forwarding指针来查找值。
__forwarding指针这里的作用就是针对堆的Block，把原来__forwarding指针指向自己，换成指向`_NSConcreteMallocBlock`上复制之后的__block自己。然后堆上的变量的__forwarding再指向自己。这样不管__block怎么复制到堆上，还是在栈上，都可以通过(i->__forwarding->i)来访问到变量值。


## block循环引用问题

```
@interface PLObject : NSObject
    
@property (nonatomic, copy) void (^block)(void);
@property (nonatomic, assign) int var;
@end
    
PLObject *object = [[PLObject alloc] init];
object.block = ^{
object.var = 2;
};
    
```
object对象强引用自己的成员变量block，block在堆上开辟内存自动捕获object对象并且内部会强引用object对象，object指针强引用object对象，导致作用域结束后，只有object指针对object对象的强引用释放，而object对象和block对象依然相互引用，双方都无法释放导致内存泄露。

解决方法：

> ARC环境中
1. 用weak指针指向object对象，此时block捕获weak指针，block内部对object 弱指针指向的对象弱引用从而打破引用循环。
2. 用__unsafe_unretained指针指向object对象，此时block捕获weak指针，block内部对object 弱指针指向的对象弱引用从而打破引用循环。
 __unsafe_unretained 和 weak的区别 ？ 都是弱引用，区别在于，
     当指向的对象销毁时, __unsafe_unretained指针会依然指向之前的内存空间(野指针)
     当对象销毁时,__weak指针会自动指向nil
3. __block方法，先调用block(),然后再在block里面把block里面指向对象的指针置空，破除 block对对象的引用，从而打破引用循环。


> MRC环境
MRC下没有__weak,有两种方法打破循环引用
     1. __unsafe_unretained 和 __block， 其中__unsafe_unretained原理和ARC一样，__block能够解决的原因是MRC环境下，__block修饰生成的底层对象不会对其修饰的对象进行强引用。如下代码
     ···
     __block PLObject *object = [[PLObject alloc] init];
     object.block = ^{
     object.var = 2;
     };
     ···


