//
//  C4QTimer.m
//  Time
//
//  Created by Michael Kavouras on 8/22/15.
//  Copyright © 2015 Mike Kavouras. All rights reserved.
//

#import "C4QTimer.h"
#import "C4QTimeFormatter.h"

@interface C4QTimer()

@property (nonatomic) NSTimeInterval timeInterval;
@property (nonatomic) NSTimer *internalTimer;

// timer functionality
@property (nonatomic) NSDate *previousTime;
@property (nonatomic, readwrite) NSTimeInterval elapsedTime;

// lapping functionality
@property (nonatomic) NSDate *previousLapTime;
@property (nonatomic, readwrite) NSTimeInterval lapTime;

@end

@implementation C4QTimer

- (instancetype)init {
    if (self = [super init]) {
        // default self.timeInterval to 1 / 60.0
        self.timeInterval = 1 / 60.0;
        [self reset];
        return self;
    }
    return nil;
}

- (instancetype)initWithTimeInterval:(NSTimeInterval)timeInterval {
    if (self = [self init]) {
        // allow initialization with a provided timeInterval
        self.timeInterval = timeInterval;
        return self;
    }
    return nil;
}

- (void)start {
    // set the initial "previous times" when the timer starts
    self.previousTime = [[NSDate alloc] init];
    self.previousLapTime = [[NSDate alloc] init];
    
    // create a timer
    self.internalTimer = [NSTimer timerWithTimeInterval:self.timeInterval target:self selector:@selector(timerFired:) userInfo:nil repeats:YES];
    [[NSRunLoop currentRunLoop] addTimer:self.internalTimer forMode:NSRunLoopCommonModes];
    
    // let the delegate know that we've started
    if (self.delegate && [self.delegate respondsToSelector:@selector(timerDidStart:)]) {
        [self.delegate timerDidStart:self];
    }
}

- (void)lap {
    // update the previous last time to right now
    self.previousLapTime = [[NSDate alloc] init];
    
    // reset the lap time
    self.lapTime = 0;
}

- (void)stop {
    // stop the timer
    [self.internalTimer invalidate];
    
    // let the delegate know we've stopped
    if (self.delegate && [self.delegate respondsToSelector:@selector(timerDidStop:)]) {
        [self.delegate timerDidStop:self];
    }
}

- (void)reset {
    // stop the timer
    [self.internalTimer invalidate];
    
    // reset the elapsed time
    self.elapsedTime = 0.0;
    
    // let the delegate know we've reset
    if (self.delegate && [self.delegate respondsToSelector:@selector(timerDidReset:)]) {
        [self.delegate timerDidReset:self];
    }
}

- (void)timerFired:(NSTimer *)timer {
    // get the current date/time
    NSDate *now = [NSDate date];
    
    // compare to the previous time
    NSTimeInterval elapsed = fabs([self.previousTime timeIntervalSinceDate:now]);
    
    // update the amount of time elapsed
    self.elapsedTime += elapsed;
    self.lapTime += elapsed;
    
    // update the previous time to now
    self.previousTime = now;
    
    // let the delgate know that the timer fired
    if (self.delegate && [self.delegate respondsToSelector:@selector(timerDidFire:)]) {
        [self.delegate timerDidFire:self];
    }
}


@end

