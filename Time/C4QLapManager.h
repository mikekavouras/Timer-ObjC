//
//  C4QLapManager.h
//  Time
//
//  Created by Michael Kavouras on 8/22/15.
//  Copyright © 2015 Mike Kavouras. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@class C4QTimedEvent;

@interface C4QLapManager : NSObject <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, readonly) NSMutableArray<C4QTimedEvent *> *laps;

- (void)addLap:(C4QTimedEvent *)lap;
- (void)reset;

@end
