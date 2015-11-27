//
//  WAMenuButton.h
//  WABouncingMenuExample
//
//  Created by Wendy Abrantes on 27/11/2015.
//  Copyright © 2015 Wendy Abrantes. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, WAMenuButtonState) {
    WAMenuButtonStateBurger,
    WAMenuButtonStateCross
};

//typedef NS_ENUM(NSUInteger, GIMenuButtonStyle) {
//    GIMenuButtonStyleWhite,
//    GIMenuButtonStyleGreen
//};

@interface WAMenuButton : UIButton

@property (nonatomic) WAMenuButtonState buttonState;
@property (nonatomic, strong) UIColor *buttonColor;

- (void)setButtonState:(WAMenuButtonState)buttonState animated:(BOOL)animated;

@end
