//
//  PAGPImagePreviewView.h
//  AnimationDemo
//
//  Created by zpz on 2020/3/1.
//  Copyright © 2020 zpzDev. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@interface UIView (PZLayout)
@property (nonatomic) CGFloat pz_left;        ///< Shortcut for frame.origin.x.
@property (nonatomic) CGFloat pz_top;         ///< Shortcut for frame.origin.y
@property (nonatomic) CGFloat pz_right;       ///< Shortcut for frame.origin.x + frame.size.width
@property (nonatomic) CGFloat pz_bottom;      ///< Shortcut for frame.origin.y + frame.size.height
@property (nonatomic) CGFloat pz_width;       ///< Shortcut for frame.size.width.
@property (nonatomic) CGFloat pz_height;      ///< Shortcut for frame.size.height.
@property (nonatomic) CGFloat pz_centerX;     ///< Shortcut for center.x
@property (nonatomic) CGFloat pz_centerY;     ///< Shortcut for center.y
@property (nonatomic) CGPoint pz_origin;      ///< Shortcut for frame.origin.
@property (nonatomic) CGSize  pz_size;        ///< Shortcut for frame.size.

@end

@interface PAGPImagePreviewView : UIView
@property (nonatomic, copy) void (^singleTapGestureBlock)(void);

@property (nonatomic, copy) void (^imageProgressUpdateBlock)(double progress);
@property (nonatomic, strong) UIImage *image;

- (void)showWithFristImage:(UIImage *)image fromIndex:(NSInteger)index fromRect:(CGRect)rect;

@end

NS_ASSUME_NONNULL_END
