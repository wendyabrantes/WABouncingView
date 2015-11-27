//
//  WAMenuButton.m
//  WABouncingMenuExample
//
//  Created by Wendy Abrantes on 27/11/2015.
//  Copyright © 2015 Wendy Abrantes. All rights reserved.
//

#import "WAMenuButton.h"

#define DEGREES_TO_RADIANS(angle) ((angle) / 180.0 * M_PI)


static CGFloat kLineLayerWidth = 25.0f;
static CGFloat kLineLayerHeight = 3.5f;
static CGFloat kLineLayerVerticalSpacing = 5.0f;

@interface WAMenuButton () {
    CALayer *_firstLineLayer;
    CALayer *_secondLineLayer;
    CALayer *_thirdLineLayer;
    
    CGColorRef layerBackgroundColor;
}

@end

@implementation WAMenuButton


#pragma mark -
#pragma mark Constructors
-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if(self){
        [self setupLayers];
    }
    return self;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        [self setupLayers];
    }
    return self;
}

-(void)setupLayers
{
    self.buttonColor = [UIColor whiteColor];
    layerBackgroundColor = self.buttonColor.CGColor;
    
    _firstLineLayer = [[CALayer alloc] init];
    _firstLineLayer.anchorPoint = CGPointMake(0.0f, 0.5f);
    _firstLineLayer.backgroundColor = layerBackgroundColor; // TODO: Proper color
    [self.layer addSublayer:_firstLineLayer];
    
    _secondLineLayer = [[CALayer alloc] init];
    _secondLineLayer.backgroundColor = layerBackgroundColor;
    [self.layer addSublayer:_secondLineLayer];
    
    _thirdLineLayer = [[CALayer alloc] init];
    _thirdLineLayer.anchorPoint = CGPointMake(0.0f, 0.5f);
    _thirdLineLayer.backgroundColor = layerBackgroundColor;
    [self.layer addSublayer:_thirdLineLayer];
}


#pragma mark -
#pragma mark Setters

- (void)setButtonState:(WAMenuButtonState)buttonState {
    [self setButtonState:buttonState animated:NO];
}

- (void)setButtonState:(WAMenuButtonState)buttonState animated:(BOOL)animated {
    if (_buttonState == buttonState) {
        return;
    }
    
    _buttonState = buttonState;
    
    __block void(^interfaceUpdates)();
    
    if (buttonState == WAMenuButtonStateBurger) {
        interfaceUpdates = ^() {
            _firstLineLayer.transform = CATransform3DMakeRotation(DEGREES_TO_RADIANS(0.0f), 0.0f, 0.0f, 1.0f);
            _secondLineLayer.opacity = 1.0f;
            _thirdLineLayer.transform = CATransform3DMakeRotation(DEGREES_TO_RADIANS(0.0f), 0.0f, 0.0f, 1.0f);
        };
    } else if (buttonState == WAMenuButtonStateCross) {
        interfaceUpdates = ^() {
            _firstLineLayer.position = CGPointMake(_firstLineLayer.position.x + 4.0f, _firstLineLayer.position.y);
            _thirdLineLayer.position = CGPointMake(_thirdLineLayer.position.x + 4.0f, _thirdLineLayer.position.y + 0.5f);
            
            _firstLineLayer.transform = CATransform3DMakeRotation(DEGREES_TO_RADIANS(45.0f), 0.0f, 0.0f, 1.0f);
            _secondLineLayer.opacity = 0.0f;
            _thirdLineLayer.transform = CATransform3DMakeRotation(DEGREES_TO_RADIANS(-45.0f), 0.0f, 0.0f, 1.0f);
        };
    }
    
    if (animated) {
        interfaceUpdates();
    } else {
        [CATransaction begin];
        [CATransaction setValue:(__bridge id)kCFBooleanTrue forKey:kCATransactionDisableActions];
        interfaceUpdates();
        [CATransaction commit];
    }
}

#pragma mark -
#pragma mark Layout

- (void)layoutSubviews {
    [super layoutSubviews];
    
    CGFloat lineLayerX = floorf((self.bounds.size.width - kLineLayerWidth) / 2.0f);
    CGFloat lineLayerY = floorf((self.bounds.size.height - kLineLayerHeight * 3.0f - kLineLayerVerticalSpacing * 2.0f) / 2.0f);
    
    if (_buttonState == WAMenuButtonStateBurger) {
        _firstLineLayer.frame = CGRectMake(lineLayerX, lineLayerY, kLineLayerWidth, kLineLayerHeight);
        _secondLineLayer.frame = CGRectOffset(_firstLineLayer.frame, 0.0f, kLineLayerHeight + kLineLayerVerticalSpacing);
        _thirdLineLayer.frame = CGRectOffset(_firstLineLayer.frame, 0.0f, kLineLayerHeight * 2.0f + kLineLayerVerticalSpacing * 2.0f);
    }
}

@end
