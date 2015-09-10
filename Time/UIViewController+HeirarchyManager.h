//
//  UIViewController+HeirarchyManager.h
//  Time
//
//  Created by Michael Kavouras on 8/23/15.
//  Copyright (c) 2015 Mike Kavouras. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIViewController (HeirarchyManager)

- (void)addViewController:(UIViewController *)viewController toView:(UIView *)view;

@end
