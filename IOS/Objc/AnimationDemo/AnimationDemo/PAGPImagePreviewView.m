//
//  PAGPImagePreviewView.m
//  AnimationDemo
//
//  Created by zpz on 2020/3/1.
//  Copyright © 2020 zpzDev. All rights reserved.
//

#import "PAGPImagePreviewView.h"

@implementation UIView (PZLayout)
- (CGFloat)pz_left {
    return self.frame.origin.x;
}

- (void)setPz_left:(CGFloat)x {
    CGRect frame = self.frame;
    frame.origin.x = x;
    self.frame = frame;
}

- (CGFloat)pz_top {
    return self.frame.origin.y;
}

- (void)setPz_top:(CGFloat)y {
    CGRect frame = self.frame;
    frame.origin.y = y;
    self.frame = frame;
}

- (CGFloat)pz_right {
    return self.frame.origin.x + self.frame.size.width;
}

- (void)setPz_right:(CGFloat)right {
    CGRect frame = self.frame;
    frame.origin.x = right - frame.size.width;
    self.frame = frame;
}

- (CGFloat)pz_bottom {
    return self.frame.origin.y + self.frame.size.height;
}

- (void)setPz_bottom:(CGFloat)bottom {
    CGRect frame = self.frame;
    frame.origin.y = bottom - frame.size.height;
    self.frame = frame;
}

- (CGFloat)pz_width {
    return self.frame.size.width;
}

- (void)setPz_width:(CGFloat)width {
    CGRect frame = self.frame;
    frame.size.width = width;
    self.frame = frame;
}

- (CGFloat)pz_height {
    return self.frame.size.height;
}

- (void)setPz_height:(CGFloat)height {
    CGRect frame = self.frame;
    frame.size.height = height;
    self.frame = frame;
}

- (CGFloat)pz_centerX {
    return self.center.x;
}

- (void)setPz_centerX:(CGFloat)centerX {
    self.center = CGPointMake(centerX, self.center.y);
}

- (CGFloat)pz_centerY {
    return self.center.y;
}

- (void)setPz_centerY:(CGFloat)centerY {
    self.center = CGPointMake(self.center.x, centerY);
}

- (CGPoint)pz_origin {
    return self.frame.origin;
}

- (void)setPz_origin:(CGPoint)origin {
    CGRect frame = self.frame;
    frame.origin = origin;
    self.frame = frame;
}

- (CGSize)pz_size {
    return self.frame.size;
}

- (void)setPz_size:(CGSize)size {
    CGRect frame = self.frame;
    frame.size = size;
    self.frame = frame;
}
@end


@interface PAGPImagePreviewView ()<UIScrollViewDelegate>
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UIView *imageContainerView;
@property (nonatomic, strong) UIImageView *imageView;
@end

@implementation PAGPImagePreviewView
- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self addSubview:self.scrollView];
        [self.scrollView addSubview:self.imageContainerView];
        [self.imageContainerView addSubview:self.imageView];
        [self configGesture];
    }
    return self;
}

- (void)configGesture {
    UITapGestureRecognizer *tap1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(singleTap:)];
    [self addGestureRecognizer:tap1];
    UITapGestureRecognizer *tap2 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(doubleTap:)];
    tap2.numberOfTapsRequired = 2;
    [tap1 requireGestureRecognizerToFail:tap2];
    [self addGestureRecognizer:tap2];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    _scrollView.frame = CGRectMake(0, 0, self.pz_width, self.pz_height);
    [self recoverSubviews];
}

- (void)recoverSubviews {
    [_scrollView setZoomScale:_scrollView.minimumZoomScale animated:NO];
    [self resizeSubviews];
}

- (void)resizeSubviews {
    _imageContainerView.pz_origin = CGPointZero;
       _imageContainerView.pz_width = self.scrollView.pz_width;
       
       UIImage *image = _imageView.image;
       if (image.size.height / image.size.width > self.pz_height / self.scrollView.pz_width) {
           _imageContainerView.pz_height = floor(image.size.height / (image.size.width / self.scrollView.pz_width));
       } else {
           CGFloat height = image.size.height / image.size.width * self.scrollView.pz_width;
           if (height < 1 || isnan(height)) height = self.pz_height;
           height = floor(height);
           _imageContainerView.pz_height = height;
           _imageContainerView.pz_centerY = self.pz_height / 2;
       }
       if (_imageContainerView.pz_height > self.pz_height && _imageContainerView.pz_height - self.pz_height <= 1) {
           _imageContainerView.pz_height = self.pz_height;
       }
       CGFloat contentSizeH = MAX(_imageContainerView.pz_height, self.pz_height);
       _scrollView.contentSize = CGSizeMake(self.scrollView.pz_width, contentSizeH);
       [_scrollView scrollRectToVisible:self.bounds animated:NO];
       _scrollView.alwaysBounceVertical = _imageContainerView.pz_height <= self.pz_height ? NO : YES;
       _imageView.frame = _imageContainerView.bounds;
       
       [self refreshScrollViewContentSize];
}

- (void)refreshScrollViewContentSize {
    
}

- (void)refreshImageContainerViewCenter {
    CGFloat offsetX = (_scrollView.pz_width > _scrollView.contentSize.width) ? ((_scrollView.pz_width - _scrollView.contentSize.width) * 0.5) : 0.0;
    CGFloat offsetY = (_scrollView.pz_height > _scrollView.contentSize.height) ? ((_scrollView.pz_height - _scrollView.contentSize.height) * 0.5) : 0.0;
    self.imageContainerView.center = CGPointMake(_scrollView.contentSize.width * 0.5 + offsetX, _scrollView.contentSize.height * 0.5 + offsetY);
}


#pragma mark - UIGestureEvent
- (void)singleTap:(UITapGestureRecognizer *)tap {
    if (self.singleTapGestureBlock) {
        self.singleTapGestureBlock();
    }
}

- (void)doubleTap:(UITapGestureRecognizer *)tap {
    if (_scrollView.zoomScale > _scrollView.minimumZoomScale) {
        _scrollView.contentInset = UIEdgeInsetsZero;
        [_scrollView setZoomScale:_scrollView.minimumZoomScale animated:YES];
    } else {
        CGPoint touchPoint = [tap locationInView:self.imageView];
        CGFloat newZoomScale = _scrollView.maximumZoomScale;
        CGFloat xsize = self.frame.size.width / newZoomScale;
        CGFloat ysize = self.frame.size.height / newZoomScale;
        [_scrollView zoomToRect:CGRectMake(touchPoint.x - xsize/2, touchPoint.y - ysize/2, xsize, ysize) animated:YES];
    }
}

- (void)showWithFristImage:(UIImage *)image fromIndex:(NSInteger)index fromRect:(CGRect)rect {
    UIImageView *tmpView = [[UIImageView alloc] initWithFrame:rect];
    tmpView.image = image;
    [[UIApplication sharedApplication].keyWindow addSubview:self];
    [self addSubview:tmpView];
    self.imageContainerView.alpha = 0.0;
    [UIView animateWithDuration:0.3 animations:^{
        CGSize imageSize = image.size;
        if(imageSize.height==0 ||imageSize.width == 0){
            return;
        }
        if(imageSize.height/imageSize.width >= CGRectGetHeight(self.frame)/CGRectGetWidth(self.frame)){
            CGFloat w =  imageSize.width*CGRectGetHeight(self.frame)/imageSize.height;
            tmpView.frame = CGRectMake(0, 0, w, CGRectGetHeight(self.frame));
        }else{
            CGFloat h = imageSize.height*CGRectGetWidth(self.frame)/imageSize.width;
            tmpView.frame = CGRectMake(0, 0, CGRectGetWidth(self.frame), h);
        }
        tmpView.center = CGPointMake(CGRectGetWidth([UIScreen mainScreen].bounds)/2.0, CGRectGetHeight([UIScreen mainScreen].bounds)/2.0);
        
    } completion:^(BOOL finished) {
        self.imageContainerView.alpha = 1;
        [tmpView removeFromSuperview];
    }];
}


#pragma mark - UIScrollViewDelegate

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView {
    return self.imageContainerView;
}

- (void)scrollViewWillBeginZooming:(UIScrollView *)scrollView withView:(UIView *)view {
    scrollView.contentInset = UIEdgeInsetsZero;
}

- (void)scrollViewDidZoom:(UIScrollView *)scrollView {
    [self refreshImageContainerViewCenter];
}

- (void)scrollViewDidEndZooming:(UIScrollView *)scrollView withView:(UIView *)view atScale:(CGFloat)scale {
    [self refreshScrollViewContentSize];
}


#pragma mark - setter

- (void)setImage:(UIImage *)image {
    _image = image;
    _imageView.image = image;
    _scrollView.maximumZoomScale = 2.5;
    CGFloat aspectRatio = image.size.width / (CGFloat)image.size.height;
    // 优化超宽图片的显示
    if (aspectRatio > 1.5) {
        self.scrollView.maximumZoomScale *= aspectRatio / 1.5;
    }
    
    [self resizeSubviews];
}

#pragma mark - getter
- (UIScrollView *)scrollView {
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc] init];
        _scrollView.bouncesZoom = YES;
        _scrollView.maximumZoomScale = 2.5;
        _scrollView.minimumZoomScale = 1.0;
        _scrollView.multipleTouchEnabled = YES;
        _scrollView.delegate = self;
        _scrollView.scrollsToTop = NO;
        _scrollView.showsHorizontalScrollIndicator = NO;
        _scrollView.showsVerticalScrollIndicator = YES;
        _scrollView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        _scrollView.delaysContentTouches = NO;
        _scrollView.canCancelContentTouches = YES;
        _scrollView.alwaysBounceVertical = NO;
        if (@available(iOS 11, *)) {
            _scrollView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        }
    }
    return _scrollView;
}

- (UIView *)imageContainerView {
    if (!_imageContainerView) {
        _imageContainerView = [[UIView alloc] init];
        _imageContainerView.clipsToBounds = YES;
        _imageContainerView.contentMode = UIViewContentModeScaleAspectFill;
    }
    return _imageContainerView;
}

- (UIImageView *)imageView {
    if (!_imageView) {
        _imageView = [[UIImageView alloc] init];
        _imageView.backgroundColor = [UIColor colorWithWhite:1.000 alpha:0.500];
        _imageView.contentMode = UIViewContentModeScaleAspectFill;
        _imageView.clipsToBounds = YES;
    }
    return _imageView;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
