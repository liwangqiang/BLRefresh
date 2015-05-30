//
//  ViewController.m
//  BLRefresh
//
//  Created by sxwyce on 15/5/29.
//  Copyright (c) 2015年 personal. All rights reserved.
//

#import "ViewController.h"


@interface ViewController ()

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *middleViewTopEdgeConstraint;
@property (strong, nonatomic) IBOutlet UIPanGestureRecognizer *panGesture;
@property (weak, nonatomic) IBOutlet UIView *middleView;
@property (nonatomic)float originTopEdge;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.originTopEdge = self.middleViewTopEdgeConstraint.constant;
    [self.panGesture addTarget:self action:@selector(pan:)];
}

-(void)pan:(UIGestureRecognizer *)Gesture
{
    if (Gesture.state == UIGestureRecognizerStateEnded) {
        //动画返回
        
        self.middleViewTopEdgeConstraint.constant = self.originTopEdge;
        [UIView animateWithDuration:.6f
                              delay:0
             usingSpringWithDamping:0.6f
              initialSpringVelocity:0
                            options:UIViewAnimationOptionAllowAnimatedContent animations:^{
                                [self.view layoutIfNeeded];
        } completion:^(BOOL finished) {
            
        }];
    }
    
    //view随手指移动
    CGPoint translationPoint = [self.panGesture translationInView:self.view];
    self.middleViewTopEdgeConstraint.constant += translationPoint.y;
    [self.panGesture setTranslation:CGPointZero inView:self.view];
    [self.view layoutIfNeeded];
}

@end
