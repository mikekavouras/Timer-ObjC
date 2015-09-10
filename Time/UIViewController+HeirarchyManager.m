//
//  UIViewController+HeirarchyManager.m
//  Time
//
//  Created by Michael Kavouras on 8/23/15.
//  Copyright (c) 2015 Mike Kavouras. All rights reserved.
//

#import "UIViewController+HeirarchyManager.h"

@implementation UIViewController (HeirarchyManager)

- (void)addViewController:(UIViewController *)viewController toView:(UIView *)view {
    [self addChildViewController:viewController];
    [view addSubview:viewController.view];
    viewController.view.frame = view.bounds;
    [viewController willMoveToParentViewController:self];
}

@end
