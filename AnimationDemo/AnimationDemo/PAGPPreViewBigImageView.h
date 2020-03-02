//
//  PAGPPreViewBigImageView.h
//  AnimationDemo
//
//  Created by zpz on 2020/2/29.
//  Copyright © 2020 zpzDev. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LYPictureBrowseInteractiveAnimatedTransition.h"

NS_ASSUME_NONNULL_BEGIN

//@interface PAGPPreViewBigImageConfig : NSObject
////@property (nonatomic, strong)
//@end

@interface PAGPPreViewBigImageView : UIViewController
@property (nonatomic, strong) UIImage *image;
@property (nonatomic, strong) LYPictureBrowseInteractiveAnimatedTransition *animatedTransition;
@end

NS_ASSUME_NONNULL_END
