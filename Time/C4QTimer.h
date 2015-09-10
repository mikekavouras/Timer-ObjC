//
//  C4QTimer.h
//  Time
//
//  Created by Michael Kavouras on 8/22/15.
//  Copyright © 2015 Mike Kavouras. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol C4QTimerDelegate;

@interface C4QTimer : NSObject

@property (nonatomic, weak) id<C4QTimerDelegate>delegate;
@property (nonatomic, readonly) NSTimeInterval elapsedTime;
@property (nonatomic, readonly) NSTimeInterval lapTime;

- (instancetype)initWithTimeInterval:(NSTimeInterval)timeInterval;
- (void)start;
- (void)stop;
- (void)lap;
- (void)reset;

@end

@protocol C4QTimerDelegate <NSObject>

@optional
- (void)timerDidStart:(C4QTimer *)timer;
- (void)timerDidFire:(C4QTimer *)timer;
- (void)timerDidStop:(C4QTimer *)timer;
- (void)timerDidReset:(C4QTimer *)timer;

@end
