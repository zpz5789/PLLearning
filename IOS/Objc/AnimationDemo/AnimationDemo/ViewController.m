//
//  ViewController.m
//  AnimationDemo
//
//  Created by zpz on 2017/7/27.
//  Copyright © 2017年 zpzDev. All rights reserved.
//

#import "ViewController.h"
#import "PAGPPreViewBigImageView.h"
#import "PAGPImagePreviewView.h"
@interface ViewController ()<UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong)UITableView *tableView;
@property (nonatomic, strong) NSArray *dataSource;
@property (nonatomic, strong) LYPictureBrowseInteractiveAnimatedTransition *animatedTransition;
@end

@implementation ViewController

- (IBAction)btnClick:(id)sender {
    PAGPPreViewBigImageView *viewcontroller = [PAGPPreViewBigImageView new];
    [self presentViewController:viewcontroller animated:YES completion:nil];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    self.dataSource = @[
        @"WechatIMG306.jpeg",
        @"WechatIMG307.jpeg",
        @"WechatIMG308.jpeg",
        @"WechatIMG309.jpeg",
        @"WechatIMG310.jpeg",
        @"WechatIMG311.jpeg",
        @"xxxxxx1",
        @"xxxxxx2",
        @"xxxxxx3",
        @"xxxxxx4.png",
        @"xxxxxx5.png",

    ];
    [self.view addSubview:self.tableView];
    
    UIPanGestureRecognizer *interactiveTransitionRecognizer;
    interactiveTransitionRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(interactiveTransitionRecognizerAction:)];
    [self.view addGestureRecognizer:interactiveTransitionRecognizer];

}

//- (void)interactiveTransitionRecognizerAction:(UIPanGestureRecognizer *)gestureRecognizer {
//    CGPoint translation = [gestureRecognizer translationInView:gestureRecognizer.view];
//
//       CGFloat scale = 1 - (translation.y / SCREENHEIGHT);
//       scale = scale < 0 ? 0 : scale;
//       scale = scale > 1 ? 1 : scale;
//
//       switch (gestureRecognizer.state) {
//           case UIGestureRecognizerStatePossible:
//               break;
//           case UIGestureRecognizerStateBegan:{
//
//               [self setupBaseViewControllerProperty:self.animatedTransition.transitionParameter.transitionImgIndex];
////               self.collectionView.hidden = YES;
////               self.imgView.hidden = NO;
//
//               self.animatedTransition.transitionParameter.gestureRecognizer = gestureRecognizer;
//               [self dismissViewControllerAnimated:YES completion:nil];
//
//           }
//               break;
//           case UIGestureRecognizerStateChanged: {
//
//               _imgView.center = CGPointMake(self.transitionImgViewCenter.x + translation.x * scale, self.transitionImgViewCenter.y + translation.y);
//               _imgView.transform = CGAffineTransformMakeScale(scale, scale);
//
//               break;
//           }
//           case UIGestureRecognizerStateFailed:
//           case UIGestureRecognizerStateCancelled:
//           case UIGestureRecognizerStateEnded: {
//
//               if (scale > 0.95f) {
//                   [UIView animateWithDuration:0.2 animations:^{
//                       self.imgView.center = self.transitionImgViewCenter;
//                       _imgView.transform = CGAffineTransformMakeScale(1, 1);
//
//                   } completion:^(BOOL finished) {
//                       _imgView.transform = CGAffineTransformIdentity;
//                   }];
//                   NSLog(@"secondevc取消");
//                   self.collectionView.hidden = NO;
//                   self.imgView.hidden = YES;
//               }else{
//               }
//               self.animatedTransition.transitionParameter.transitionImage = _imgView.image;
//               self.animatedTransition.transitionParameter.currentPanGestImgFrame = _imgView.frame;
//
//               self.animatedTransition.transitionParameter.gestureRecognizer = nil;
//           }
//       }
//}

//- (void)setupBaseViewControllerProperty:(NSInteger)cellIndex{
//
//    LYPictureBrowserCell *cell = (LYPictureBrowserCell *)[_collectionView cellForItemAtIndexPath:[NSIndexPath indexPathForItem:cellIndex inSection:0]];
//
//    self.animatedTransition.transitionParameter.transitionImage = cell.pictureImageScrollView.zoomImageView.image;
//    self.animatedTransition.transitionParameter.transitionImgIndex = cellIndex;
//
//    self.imgView.frame = cell.pictureImageScrollView.zoomImageView.frame;
//    self.imgView.image = cell.pictureImageScrollView.zoomImageView.image;
//    self.imgView.hidden = YES;
//    self.transitionImgViewCenter = _imgView.center;
//}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSource.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *ID = @"cellID";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
    }
    cell.imageView.image = [UIImage imageNamed:self.dataSource[indexPath.row]];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    PAGPImagePreviewView *previewView = [[PAGPImagePreviewView alloc] initWithFrame:self.view.bounds];
    
//    [self.view showsLargeContentViewer];
    
//    PAGPPreViewBigImageView *imageview  = [[PAGPPreViewBigImageView alloc] init];
//    LYPictureBrowseTransitionParameter *transitionParameter = [[LYPictureBrowseTransitionParameter alloc] init];
//    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
//    transitionParameter.transitionImage = cell.imageView.image;
//
//    CGRect rect = [cell convertRect:cell.imageView.frame toView:nil];
//
//    NSValue *value = [NSValue valueWithCGRect:rect];
//    transitionParameter.firstVCImgFrames = @[value];
//    transitionParameter.transitionImgIndex = 0;
//    self.animatedTransition.transitionParameter = transitionParameter;
//
//
//    imageview.animatedTransition = self.animatedTransition;
//    imageview.transitioningDelegate = self.animatedTransition;
//    imageview.image = [UIImage imageNamed:_dataSource[indexPath.row]];
//    imageview.modalPresentationStyle = UIModalPresentationFullScreen;
//    [self presentViewController:imageview animated:YES completion:nil];
}


- (LYPictureBrowseInteractiveAnimatedTransition *)animatedTransition{
    if (!_animatedTransition) {
        _animatedTransition = [[LYPictureBrowseInteractiveAnimatedTransition alloc] init];
    }
    return _animatedTransition;
}


#pragma mark - UITableView

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height)];
        _tableView.delegate = self;
        _tableView.dataSource = self;
    }
    return _tableView;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
