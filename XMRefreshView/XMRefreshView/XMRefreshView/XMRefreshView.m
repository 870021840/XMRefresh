//
//  XMRefreshView.m
//  XMRefreshView
//
//  Created by 谢满 on 15/5/7.
//  Copyright (c) 2015年 谢满. All rights reserved.
//

#import "XMRefreshView.h"
#import "XMRefreshConst.h"




@interface XMRefreshView() <UIScrollViewDelegate>

/**
 *  是否正在刷新
 */
@property(nonatomic,assign) BOOL isRefreshing;



/**
 *  进度
 */
@property(nonatomic,assign) CGFloat progress;



/**
 *  椭圆layer
 */
@property(nonatomic,strong) CAShapeLayer *ovalShapeLayer;

/**
 *  飞机layer
 */
@property(nonatomic,strong) CALayer *airplaneLayer;



@property(nonatomic,weak) UIScrollView   *scrollView;

@end

@implementation XMRefreshView


-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        UIImageView *bg = [[UIImageView alloc ] initWithImage:[UIImage imageNamed:@"refresh-view-bg"]];
        bg.frame = self.bounds;
        bg.contentMode = UIViewContentModeScaleAspectFill;
        bg.autoresizingMask = UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleWidth;
        bg.clipsToBounds = YES;
        [self addSubview:bg];
        
        
        
        CAShapeLayer *ovalShapeLayer = [CAShapeLayer layer];
        ovalShapeLayer.strokeColor = [UIColor whiteColor].CGColor;
        ovalShapeLayer.fillColor = [UIColor clearColor].CGColor;
        ovalShapeLayer.lineWidth = 4.0;
        ovalShapeLayer.lineDashPattern = @[@2,@3];
        [self.layer addSublayer:ovalShapeLayer];
        self.ovalShapeLayer = ovalShapeLayer;
        
        
        
        CALayer *airplaneLayer = [CALayer layer];
        UIImage *airplaneImage = [UIImage imageNamed:@"icon-plane"];
        airplaneLayer.contents =  (__bridge id)(airplaneImage.CGImage);
        airplaneLayer.bounds = CGRectMake(0, 0, airplaneImage.size.width, airplaneImage.size.height);
        airplaneLayer.opacity = 0.0;
        [self.layer addSublayer:airplaneLayer];
        self.airplaneLayer = airplaneLayer;
        
    }
    return self;
}



- (void)willMoveToSuperview:(UIView *)newSuperview
{
    [super willMoveToSuperview:newSuperview];
    
    
    
    if (newSuperview) { // 新的父控件
        
        self.frame = CGRectMake(0, -XMRefreshHeaderHeight, newSuperview.frame.size.width, XMRefreshHeaderHeight);
        
        
        CGFloat refreshRadius = self.frame.size.height / 2 *0.8;
        self.ovalShapeLayer.path =  [UIBezierPath bezierPathWithOvalInRect:CGRectMake(self.frame.size.width/2 - refreshRadius, self.frame.size.height /2 - refreshRadius, 2 * refreshRadius, 2 *refreshRadius)].CGPath;
        
        
        _airplaneLayer.position = CGPointMake(self.frame.size.width / 2 +XMRefreshHeaderHeight / 2*0.8, XMRefreshHeaderHeight / 2);
        
        // 记录UIScrollView
        self.scrollView = (UIScrollView *)newSuperview;
        self.scrollView.delegate = self;
        
        // 设置永远支持垂直弹簧效果
        self.scrollView.alwaysBounceVertical = YES;
    }
}



-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    

    CGFloat offsetY = MAX(-(scrollView.contentOffset.y + scrollView.contentInset.top),0.0);
    
    self.progress = MIN( MAX(offsetY / self.frame.size.height,0.0),1.0);
    
    if (!self.isRefreshing) {
        [self redrawFromProgress:self.progress];
    }
}

-(void)redrawFromProgress:(CGFloat)progress{
    
    self.ovalShapeLayer.strokeEnd = progress;
    self.airplaneLayer.opacity = progress;
}


-(void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    
    if (!self.isRefreshing && self.progress >= 1.0) {
        if (self.refreshingBlock) {
            self.refreshingBlock();
        }
        [self beginRefreshing];
    }
}


-(void)beginRefreshing{
    self.isRefreshing = YES;
    
    [UIView animateWithDuration:XMRefreshAnimationDuration animations:^{
        UIEdgeInsets newInsets = self.scrollView.contentInset;
        newInsets.top += self.frame.size.height;
        self.scrollView.contentInset = newInsets;
    }];
    
    CABasicAnimation *strokeStartAnimation = [CABasicAnimation animationWithKeyPath:@"strokeStart"];
    strokeStartAnimation.fromValue = @(-0.5);
    strokeStartAnimation.toValue = @(1);
    
    
    CABasicAnimation *strokeEndAnimation = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
    strokeEndAnimation.fromValue = @(0.0);
    strokeEndAnimation.toValue = @(1.0);
    
    CAAnimationGroup *strokeAnimationGroup = [CAAnimationGroup animation];
    strokeAnimationGroup.duration = 1.5;
    strokeAnimationGroup.repeatCount = MAXFLOAT;
    strokeAnimationGroup.animations = @[strokeStartAnimation,strokeEndAnimation];
    [self.ovalShapeLayer addAnimation:strokeAnimationGroup forKey:@"ovalShapeLayer"];
    
    CAKeyframeAnimation *flightAnimation = [CAKeyframeAnimation animationWithKeyPath:@"position"];
    flightAnimation.path = self.ovalShapeLayer.path;
    flightAnimation.calculationMode = kCAAnimationPaced;
    
    CABasicAnimation *airplaneOrientationAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation"];
    airplaneOrientationAnimation.fromValue = @(0);
    airplaneOrientationAnimation.toValue = @(2 * M_PI);
    
    CAAnimationGroup *flightAnimationGroup = [CAAnimationGroup animation];
    flightAnimationGroup.duration = 1.5;
    flightAnimationGroup.repeatCount = MAXFLOAT;
    flightAnimationGroup.animations = @[airplaneOrientationAnimation,flightAnimation];
    [self.airplaneLayer addAnimation:flightAnimationGroup forKey:@"airplaneLayer"];
}

-(void)endRefreshig{
    self.isRefreshing = NO;
    
    [UIView animateWithDuration:XMRefreshAnimationDuration delay:0 options:UIViewAnimationOptionCurveEaseOut   animations:^{
        
        UIEdgeInsets newInsets = self.scrollView.contentInset;
        newInsets.top -= self.frame.size.height;
        self.scrollView.contentInset = newInsets;
        
    } completion:^(BOOL finished) {
        
        [self.airplaneLayer removeAnimationForKey:@"airplaneLayer"];
        [self.ovalShapeLayer removeAnimationForKey:@"ovalShapeLayer"];
    }];
    
    
}

@end
