//
//  PAGPImageBrowser.m
//  AnimationDemo
//
//  Created by zpz on 2020/3/1.
//  Copyright © 2020 zpzDev. All rights reserved.
//

#import "PAGPImageBrowser.h"

@implementation PAGPImageBrowser


- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = UIColor.blackColor;
        UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(respondsToLongPress:)];
        [self addGestureRecognizer:longPress];
//        [self initValue];
    }
    return self;
}


- (void)show {
    [self showToView:[UIApplication sharedApplication].keyWindow];
}

- (void)showToView:(UIView *)view {
    [self showToView:view containerSize:view.bounds.size];
}

- (void)showToView:(UIView *)view containerSize:(CGSize)containerSize {
    [view addSubview:self];
    self.frame = view.bounds;
    self.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    
}




/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
