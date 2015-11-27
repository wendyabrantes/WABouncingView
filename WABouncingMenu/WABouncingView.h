//
//  WABouncingView.h
//  WABouncingMenuExample
//
//  Created by Wendy Abrantes on 26/11/2015.
//  Copyright © 2015 Wendy Abrantes. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WAMenuButton.h"

@interface WABouncingView : UIView

@property (nonatomic, strong) UIColor *menuColor;
@property (nonatomic, assign) BOOL isAnimating;
@property (nonatomic, assign) BOOL isOpen;
@property (nonatomic, strong) WAMenuButton *menuButton;

-(void)animateOpen;
-(void)animateClose;

-(instancetype)initWithFrame:(CGRect)frame
             circleMenuFrame:(CGRect)paramCircleMenuFrame;
    
@end
