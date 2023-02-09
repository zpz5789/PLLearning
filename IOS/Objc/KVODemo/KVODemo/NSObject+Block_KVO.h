//
//  NSObject+Block_KVO.h
//  KVODemo
//
//  Created by zpz on 2019/4/13.
//  Copyright © 2019 zpz. All rights reserved.
//

#import <Foundation/Foundation.h>


typedef void (^PL_ObservingHandler)(id observedObject, NSString * observedKey, id oldValue, id newValue);

NS_ASSUME_NONNULL_BEGIN

@interface NSObject (Block_KVO)


/**
 *  ① 动态创建一个子类交换isa
 *  ②
 *  ③
 *  ④
 */

- (void)PL_addObserver:(NSObject *)observer
                forKey:(NSString *)key
             withBlock:(PL_ObservingHandler)observinghandler;


- (void)PL_removeObserver: (NSObject *)object forKey: (NSString *)key;

@end

NS_ASSUME_NONNULL_END
