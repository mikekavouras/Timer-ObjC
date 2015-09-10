//
//  C4QPresetTimerSelectionTableViewController.h
//  Time
//
//  Created by Michael Kavouras on 8/23/15.
//  Copyright (c) 2015 Mike Kavouras. All rights reserved.
//


#import <UIKit/UIKit.h>

@class C4QTimedEvent;
@class C4QNewPresetTimerViewController;

@protocol C4QPresetTimerDelegate;

@interface C4QPresetTimerSelectionTableViewController : UITableViewController

@property (nonatomic, readonly) NSMutableArray<C4QTimedEvent *> *timers;
@property (nonatomic, weak) id<C4QPresetTimerDelegate>delegate;

- (void)addTimer:(C4QTimedEvent *)timer;

@end

@protocol C4QPresetTimerDelegate <NSObject>

@optional
- (void)presetTimerViewController:(C4QNewPresetTimerViewController *)viewController
                didCreateNewTimer:(C4QTimedEvent *)timer;
- (void)presetTimerViewController:(C4QNewPresetTimerViewController *)viewController
                didUpdateTimer:(C4QTimedEvent *)timer;
- (void)presetTimerViewController:(C4QNewPresetTimerViewController *)viewController
                didDeleteTimer:(C4QTimedEvent *)timer;
- (void)presetTimerSelectionViewController:(C4QPresetTimerSelectionTableViewController *)viewController
                      didSelectPresetTimer:(C4QTimedEvent *)timer;

@end
