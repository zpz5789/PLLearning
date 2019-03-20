//
//  RunloopController1.m
//  RunLoopDemo
//
//  Created by zpz on 2019/3/19.
//  Copyright © 2019 zpz. All rights reserved.
//

#import "RunLoopController1.h"

@interface RunLoopController1 ()

@end

@implementation RunLoopController1

- (void)viewDidLoad {
    [super viewDidLoad];
    
}

/*
 RunLoop概念：
 RunLoop实际上是一个对象，这个对象管理了其需要处理的消息和事件，并提供了一个入口函数来执行Event Loop（事件循环）逻辑，线程执行了这个函数后，就会一直处于这个函数内部 “接受消息->等待->处理” 的循环中，直到这个循环结束（比如传入 quit 的消息），函数返回。
 
 OSX/iOS 系统中，提供了两个这样的对象：NSRunLoop 和 CFRunLoopRef。
 CFRunLoopRef 是在 CoreFoundation 框架内的，它提供了纯 C 函数的 API，所有这些 API 都是线程安全的。
 NSRunLoop 是基于 CFRunLoopRef 的封装，提供了面向对象的 API，但是这些 API 不是线程安全的。
 
 */

/*
 RunLoop的基本作用
 保持程序的持续运行
 处理App中的各种事件（比如触摸事件、定时器事件等）
 节省CPU资源，提高程序性能：该做事时做事，该休息时休息
 ......
 */

/*
 RunLoop与线程的关系
 
 每条线程都有唯一的一个与之对应的RunLoop对象
 
 RunLoop保存在一个全局的Dictionary里，线程作为key，RunLoop作为value
 
 线程刚创建时并没有RunLoop对象，RunLoop会在第一次获取它时创建
 
 RunLoop会在线程结束时销毁
 
 主线程的RunLoop已经自动获取（创建），子线程默认没有开启RunLoop
 
 */

/*
 RunLoop相关的类
 
 
 
 struct __CFRunLoopMode {
 CFStringRef _name;            // Mode Name, 例如 @"kCFRunLoopDefaultMode"
 CFMutableSetRef _sources0;    // Set
 CFMutableSetRef _sources1;    // Set
 CFMutableArrayRef _observers; // Array
 CFMutableArrayRef _timers;    // Array
 ...
 };
 
 struct __CFRunLoop {
 CFMutableSetRef _commonModes;     // Set
 CFMutableSetRef _commonModeItems; // Set<Source/Observer/Timer>
 CFRunLoopModeRef _currentMode;    // Current Runloop Mode
 CFMutableSetRef _modes;           // Set
 ...
 };

 
 CFRunLoopRef： RunLoop对象， 一个RunLoop包含若干个Mode, 每个 Mode 又包含若干个 Source/Timer/Observer，
 要正常运行起来必须需要运行在指定的一个Mode下，这个Mode称为_currentMode，如果需要切换 Mode，只能退出 Loop，再重新指定一个 Mode 进入。这样做主要是为了分隔开不同组的 Source/Timer/Observer，让其互不影响。

 CFRunLoopModeRef：RunLoop的运行模式，一个运行模式下有若干个Tiems。
 
 CFRunLoopSourceRef：Source有两个版本：Source0 和 Source1。
 
 CFRunLoopTimerRef
 CFRunLoopObserverRef
 

 source0和 Source1?
 timer
 */

@end
