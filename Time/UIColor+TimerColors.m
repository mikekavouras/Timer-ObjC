//
//  UIColor+TimerColors.m
//  Time
//
//  Created by Michael Kavouras on 8/22/15.
//  Copyright © 2015 Mike Kavouras. All rights reserved.
//

#import "UIColor+TimerColors.h"

@implementation UIColor (TimerColors)

+ (UIColor *)startColor {
    int r = 125;
    int g = 205;
    int b = 140;
    return [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:1.0];
}

+ (UIColor *)stopColor {
    return [UIColor colorWithRed:249/255.0 green:91/255.0 blue:91/255.0 alpha:1.0];
}

@end
