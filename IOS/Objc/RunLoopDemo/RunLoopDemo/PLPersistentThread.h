//
//  PLPersistentThead.h
//  RunLoopDemo
//
//  Created by zpz on 2019/3/19.
//  Copyright © 2019 zpz. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef void (^PLPersistentThreadTask)(void);

@interface PLPersistentThread : NSObject
- (void)start;
- (void)cancel;
- (void)executeTask:(PLPersistentThreadTask)task;
@end

NS_ASSUME_NONNULL_END
