//
//  ViewController.m
//  BLRefresh
//
//  Created by sxwyce on 15/5/29.
//  Copyright (c) 2015年 personal. All rights reserved.
//

#import "ViewController.h"


@interface ViewController ()

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *mainViewTopEdgeConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *refreshViewHeightConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *xiaoyunViewTrailingContraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *dayunViewTrailingConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *refreshViewTopEdgeConstraint;

@property (strong, nonatomic) IBOutlet UIPanGestureRecognizer *panGesture;

@property (weak, nonatomic) IBOutlet UIView *middleView;
@property (weak, nonatomic) IBOutlet UIView *refreshView;
@property (weak, nonatomic) IBOutlet UIImageView *refreshBannerView;

@property(nonatomic, getter=hasEnlargedBanner)BOOL enlargedBanner;
@property(nonatomic, getter=isDayunMoving)BOOL dayunMoving;


@property (nonatomic)float originMainViewTopEdge;
@property (nonatomic)float originXiaoyunViewTrailingEdge;
@property (nonatomic)float originDayunTrailingEdge;

@end

@implementation ViewController

#pragma mark - Life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    
    //set up
    self.originMainViewTopEdge = self.mainViewTopEdgeConstraint.constant;
    self.originXiaoyunViewTrailingEdge = self.xiaoyunViewTrailingContraint.constant;
    self.originDayunTrailingEdge = self.dayunViewTrailingConstraint.constant;
    [self.panGesture addTarget:self action:@selector(pan:)];
}

#pragma mark - Event response
-(void)pan:(UIPanGestureRecognizer *)Gesture
{
    if (Gesture.state == UIGestureRecognizerStateBegan) {
        
        //初始化refresh view位置
        self.refreshViewTopEdgeConstraint.constant = -self.refreshViewHeightConstraint.constant;
        //初始化小云的位置
        self.xiaoyunViewTrailingContraint.constant = -self.originXiaoyunViewTrailingEdge;
        
        [self.refreshView layoutIfNeeded];
        
        //开始大云的动画
        [self dayunAnimation];
        
    }else if (Gesture.state == UIGestureRecognizerStateChanged){
        
        //view随手指移动
        CGPoint translationPoint = [self.panGesture translationInView:self.view];
        self.mainViewTopEdgeConstraint.constant += translationPoint.y;
        [self.panGesture setTranslation:CGPointZero inView:self.view];
        
        //边移动边显示refresh view
        CGFloat scale = (self.mainViewTopEdgeConstraint.constant - self.originMainViewTopEdge) / self.refreshViewHeightConstraint.constant ;
        CGFloat alpha = scale * 1;
        self.refreshView.alpha = alpha;
        
        //下拉过程中 更新refresh view 和 小云的位置
        if (self.mainViewTopEdgeConstraint.constant < self.refreshViewHeightConstraint.constant) {
            self.refreshViewTopEdgeConstraint.constant += translationPoint.y;
            self.xiaoyunViewTrailingContraint.constant += translationPoint.y;
        }else{
            self.refreshViewTopEdgeConstraint.constant = 0;
        }
        
        //下拉超过200 放大refresh banner view
        if (self.mainViewTopEdgeConstraint.constant > 200  && !self.hasEnlargedBanner) {
            [self enlargeRefreshBannerView];
            self.enlargedBanner = YES;
        }
        
        [self.view layoutIfNeeded];
    }else if (Gesture.state == UIGestureRecognizerStateEnded) {
        
        //动画返回
        self.mainViewTopEdgeConstraint.constant = self.originMainViewTopEdge;
        [UIView animateWithDuration:.6f
                              delay:0
             usingSpringWithDamping:0.6f
              initialSpringVelocity:0
                            options:UIViewAnimationOptionAllowAnimatedContent animations:^{
                                [self.view layoutIfNeeded];
                            } completion:^(BOOL finished) {
                                
                            }];
        
        //结束大云动画
        [self stopDayunMoving];
        //reset enlarged
        self.enlargedBanner = NO;
        
    }}

#pragma mark - Private Method
-(void)dayunAnimation
{
    self.dayunMoving = YES;
    self.dayunViewTrailingConstraint.constant = self.originDayunTrailingEdge + (self.dayunViewTrailingConstraint.constant >= self.originDayunTrailingEdge ? -50 : 50 );
    [UIView animateWithDuration:1.0 animations:^{
        [self.refreshView layoutIfNeeded];
    } completion:^(BOOL finished) {
        if (finished) {
            if (self.isDayunMoving) {
                [self dayunAnimation];
            }else{
                self.dayunViewTrailingConstraint.constant = self.originDayunTrailingEdge;
                [UIView animateWithDuration:1.0 animations:^{
                    [self.refreshView layoutIfNeeded];
                }];
            }
        }
    }];
    
}
-(void)enlargeRefreshBannerView
{
    // Core Animation
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
    animation.duration = 0.5;
    animation.autoreverses = YES;
    animation.fillMode = kCAFillModeForwards;
    animation.removedOnCompletion = YES;
    animation.toValue = @(1.3);
    [self.refreshBannerView.layer addAnimation:animation forKey:nil];
}
-(void)stopDayunMoving
{
    self.dayunMoving = NO;
}
-(void)endEnlargeRefreshBannerView
{
    self.enlargedBanner = NO;
}

@end
