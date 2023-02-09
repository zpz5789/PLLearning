//
//  main.m
//  BlockTest
//
//  Created by zpz on 2019/4/12.
//  Copyright © 2019 zpz. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PLPerson.h"

int main(int argc, const char * argv[]) {
    @autoreleasepool {
        
        __block int a = 10;
        __block PLPerson *blockPerson = [[PLPerson alloc] init];
        __strong PLPerson *strongPerson = [[PLPerson alloc] init];
        PLPerson *person = [[PLPerson alloc] init];
        __weak PLPerson *weakPerson = person;
        void (^block)(void) = ^{
            NSLog(@"%@ %@ %d %@",strongPerson, weakPerson, a++ , blockPerson);
        };
        block();
        
        
    }
    return 0;
}

