//
//  WABouncingView.m
//  WABouncingMenuExample
//
//  Created by Wendy Abrantes on 26/11/2015.
//  Copyright © 2015 Wendy Abrantes. All rights reserved.
//

#import "WABouncingView.h"
#import "Pop.h"
@implementation WABouncingView
{
    UIView *topControlPoint;
    UIView *leftControlPoint;
    UIView *rightControlPoint;
    UIView *bottomControlPoint;
    
    CADisplayLink *displayLink;
    
    UIBezierPath *circleBezier;
    UIBezierPath *finalBezier;
    
    CAShapeLayer *circleLayer;
    CAShapeLayer *shapeLayer;
    
    CGRect circleFrame;
}

-(instancetype)initWithFrame:(CGRect)frame
             circleMenuFrame:(CGRect)paramCircleMenuFrame
{
    self = [super initWithFrame:frame];
    if(self){
        
        self.menuColor = [UIColor colorWithRed: 0.227 green: 0.569 blue: 1 alpha: 1];

        self.isOpen = false;

        circleFrame = paramCircleMenuFrame;
        
        CGFloat overflow = circleFrame.size.width/2.2;
        
        circleBezier = [UIBezierPath bezierPath];
        [circleBezier moveToPoint: CGPointMake(circleFrame.origin.x, circleFrame.origin.y)];
        [circleBezier addQuadCurveToPoint:CGPointMake(circleFrame.origin.x + circleFrame.size.width, circleFrame.origin.y) controlPoint:CGPointMake(circleFrame.origin.x + circleFrame.size.width/2, circleFrame.origin.y - overflow)];
        
        [circleBezier addQuadCurveToPoint:CGPointMake(circleFrame.origin.x + circleFrame.size.width, circleFrame.origin.y + circleFrame.size.height)
                             controlPoint:CGPointMake(circleFrame.origin.x + circleFrame.size.width + overflow, circleFrame.origin.y + circleFrame.size.height/2)];
        
        [circleBezier addQuadCurveToPoint:CGPointMake(circleFrame.origin.x, circleFrame.origin.y + circleFrame.size.height)
                             controlPoint:CGPointMake(circleFrame.origin.x + circleFrame.size.width/2, circleFrame.origin.y + circleFrame.size.height + overflow)];
        
        [circleBezier addQuadCurveToPoint:CGPointMake(circleFrame.origin.x, circleFrame.origin.y)
                             controlPoint:CGPointMake(circleFrame.origin.x - overflow, circleFrame.origin.y + circleFrame.size.height/2)];

        [circleBezier closePath];
        
        finalBezier = [UIBezierPath bezierPathWithRect:CGRectMake(0, 0, 375, 200)];
        
        circleLayer = [CAShapeLayer layer];
        circleLayer.fillColor = self.menuColor.CGColor;
        circleLayer.path = circleBezier.CGPath;
        
        [self.layer addSublayer:circleLayer];
        
        displayLink = [CADisplayLink displayLinkWithTarget:self selector:@selector(updateLoop)];
        displayLink.paused = true;
        [displayLink addToRunLoop:[NSRunLoop currentRunLoop]
                          forMode:NSRunLoopCommonModes];
        
        topControlPoint = [UIView new];
        leftControlPoint = [UIView new];
        rightControlPoint = [UIView new];
        bottomControlPoint = [UIView new];

        //control point
        for(UIView *controlView in @[topControlPoint, leftControlPoint, rightControlPoint, bottomControlPoint] ){
            controlView.frame = CGRectMake(0, 0, 1, 1);
            [self addSubview:controlView];
        }
        [self positionControlPoints];
        
        shapeLayer = [CAShapeLayer layer];
        shapeLayer.path = [self pathForControlPoints];
        shapeLayer.opacity = 0.0;
        shapeLayer.fillColor = self.menuColor.CGColor;
        [self.layer addSublayer:shapeLayer];
    }
    return self;
}

//////  circle to rect

-(void)animateOpen{
    
    if(!self.isAnimating){

    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"path"];
    animation.fromValue = (id)circleBezier.CGPath;
    animation.toValue = (id)finalBezier.CGPath;
    animation.duration = 0.3;
    animation.delegate = self;
    circleLayer.path = finalBezier.CGPath;
    
    [circleLayer addAnimation:animation forKey:@"animateIn"];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.25 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self startUpdateLoop];
        [self animateControlPoints];
    });
        self.isOpen = true;
        self.isAnimating = true;
    }
}

-(void)animateClose{
    
    if(!self.isAnimating){
    displayLink.paused = true;

    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"path"];
    animation.fromValue = (id)finalBezier.CGPath;
    animation.toValue = (id)circleBezier.CGPath;
    animation.duration = 0.3;
    animation.delegate = self;
    circleLayer.path = circleBezier.CGPath;
        
    [circleLayer setValue:@"animateOut" forKey:@"animateOut"];
    [circleLayer addAnimation:animation forKey:@"animateOut"];
    
    self.isOpen = false;
    self.isAnimating = true;
    }
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    //positionControlPoints
}

-(void)updateLoop{
    circleLayer.path = [self pathForControlPoints];
}

-(void)startUpdateLoop{
    displayLink.paused = false;
}

-(void)stopUpdateLoop{
    displayLink.paused = true;
}

-(void)positionControlPoints{
    topControlPoint.center = CGPointMake(CGRectGetMidX(self.bounds), 0.0);
    leftControlPoint.center = CGPointMake(0.0, CGRectGetMidY(self.bounds));
    bottomControlPoint.center = CGPointMake(CGRectGetMidX(self.bounds), CGRectGetMaxY(self.bounds));
    rightControlPoint.center = CGPointMake(CGRectGetMaxX(self.bounds), CGRectGetMidY(self.bounds));
}

-(CGPathRef)pathForControlPoints{
    
    UIBezierPath *path = [UIBezierPath bezierPath];
    
    CGPoint top = [topControlPoint.layer.presentationLayer position];
    CGPoint left = [leftControlPoint.layer.presentationLayer position];
    CGPoint bottom = [bottomControlPoint.layer.presentationLayer position];
    CGPoint right = [rightControlPoint.layer.presentationLayer position];
    
    CGFloat width = self.frame.size.width;
    CGFloat height = self.frame.size.height;
    
    // 3
    [path moveToPoint:CGPointMake(0, 0)];
    [path addQuadCurveToPoint:CGPointMake(width, 0) controlPoint:top];
    [path addQuadCurveToPoint:CGPointMake(width, height) controlPoint:right];
    [path addQuadCurveToPoint:CGPointMake(0, height) controlPoint:bottom];
    [path addQuadCurveToPoint:CGPointMake(0, 0) controlPoint:left];
    
    return path.CGPath;
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [super touchesBegan:touches withEvent:event];
//    [self startUpdateLoop];
//    [self animateControlPoints];
    
}

-(void)animateControlPoints{
    
    CGFloat overshootAmount = 40.0;
    [UIView animateWithDuration:0.15
                          delay:0.0
         usingSpringWithDamping:1.0
          initialSpringVelocity:0.0
                        options:UIViewAnimationOptionCurveEaseIn
                     animations:^{

                         [topControlPoint setCenter:CGPointMake(topControlPoint.center.x, topControlPoint.center.y - overshootAmount)];
//                       [leftControlPoint setCenter:CGPointMake(leftControlPoint.center.x - overshootAmount, leftControlPoint.center.y)];
//                         [rightControlPoint setCenter:CGPointMake(rightControlPoint.center.x + overshootAmount, rightControlPoint.center.y)];
                         [bottomControlPoint setCenter:CGPointMake(bottomControlPoint.center.x, bottomControlPoint.center.y + overshootAmount)];
    }
                     completion:^(BOOL finished) {
       
                         [UIView animateWithDuration:0.8
                                               delay:0.0
                              usingSpringWithDamping:0.4
                               initialSpringVelocity:0.0
                                             options:UIViewAnimationOptionAllowAnimatedContent
                                          animations:^{
                                             [self positionControlPoints];
                                          }
                          completion:^(BOOL finished) {
                              self.isAnimating = false;
                              [self stopUpdateLoop];
                          }];
    }];
}

-(void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag
{
    if(flag && !self.isOpen){
        self.isAnimating = false;
    }
}





@end
