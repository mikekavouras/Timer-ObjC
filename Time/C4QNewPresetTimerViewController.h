//
//  C4QNewPresetTimerViewController.h
//  Time
//
//  Created by Michael Kavouras on 8/23/15.
//  Copyright (c) 2015 Mike Kavouras. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "C4QPresetTimerSelectionTableViewController.h"

@class C4QTimedEvent;

@interface C4QNewPresetTimerViewController : UITableViewController

@property (nonatomic, weak) id<C4QPresetTimerDelegate>delegate;
@property (nonatomic, weak) C4QTimedEvent *timer;

@end

