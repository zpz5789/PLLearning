//
//  PAGPPreViewBigImageView.m
//  AnimationDemo
//
//  Created by zpz on 2020/2/29.
//  Copyright © 2020 zpzDev. All rights reserved.
//

#import "PAGPPreViewBigImageView.h"
#import "PAGPImagePreviewView.h"

@interface PAGPPreViewBigImageView ()
@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) UIScrollView *bgScrollView;
@property (nonatomic, strong) PAGPImagePreviewView *imagePreviewView;
@end

@implementation PAGPPreViewBigImageView

- (void)viewDidLoad {
    [super viewDidLoad];
    self.imagePreviewView = [[PAGPImagePreviewView alloc] initWithFrame:CGRectZero];
    [self.view addSubview:self.imagePreviewView];
    __weak typeof(self) _weakSelf = self;
    self.imagePreviewView.singleTapGestureBlock = ^{
        [_weakSelf dismissViewControllerAnimated:YES completion:nil];
    };
    
    self.imagePreviewView.frame = self.view.bounds;
    
    self.imagePreviewView.image = self.image;

//    [self.view addSubview:self.bgScrollView];
//    [self.view addSubview:self.imageView];
//
    // Do any additional setup after loading the view.
}

- (void)setImage:(UIImage *)image {
    _image = image;
    self.imagePreviewView.image = image;
}

- (UIScrollView *)bgScrollView {
    if (!_bgScrollView) {
        _bgScrollView = [[UIScrollView alloc] initWithFrame:[UIScreen mainScreen].bounds];
        _bgScrollView.backgroundColor = [UIColor lightGrayColor];
    }
    return _bgScrollView;
}

- (UIImageView *)imageView {
    if (!_imageView) {
        _imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
    }
    return _imageView;
}




@end
