//
//  PLPermenantThread.h
//  RunLoopDemo
//
//  Created by zpz on 2019/3/19.
//  Copyright © 2019 zpz. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN
typedef void (^PLPermenantThreadTask)(void);

@interface PLPermenantThread : NSObject

- (void)start;
- (void)cancel;
- (void)executeTask:(PLPermenantThreadTask)task;

@end

NS_ASSUME_NONNULL_END
