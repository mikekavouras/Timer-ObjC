//
//  C4QCountDownEvent.m
//  Time
//
//  Created by Michael Kavouras on 8/24/15.
//  Copyright © 2015 Mike Kavouras. All rights reserved.
//

#import "C4QCountdownEvent.h"
#import "C4QTimeFormatter.h"
#import "C4QTimer.h"

@interface C4QCountdownEvent() <C4QTimerDelegate>

@property (nonatomic, readwrite) NSTimeInterval timeLeft;

@end

@implementation C4QCountdownEvent

- (instancetype)init {
    if (self = [super init]) {
        self.timeLeft = [self.date timeIntervalSinceDate:[NSDate date]];
        [self startTimer];
        return self;
    }
    return nil;
}

+ (NSArray<C4QCountdownEvent *> *)defaultEvents {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    
    C4QCountdownEvent *event1 = [[C4QCountdownEvent alloc] init];
    event1.name = @"Christmas";
    event1.date = [formatter dateFromString:@"2015-12-25"];
    event1.image = [UIImage imageNamed:@"christmas"];
    
    C4QCountdownEvent *event2 = [[C4QCountdownEvent alloc] init];
    event2.name = @"Graduation";
    event2.date = [formatter dateFromString:@"2015-12-10"];
    event2.image = [UIImage imageNamed:@"graduation"];
    
    C4QCountdownEvent *event3 = [[C4QCountdownEvent alloc] init];
    event3.name = @"Mike's Birthday";
    event3.date = [formatter dateFromString:@"2015-09-26"];
    event3.image = [UIImage imageNamed:@"birthday"];
    
    C4QCountdownEvent *event4 = [[C4QCountdownEvent alloc] init];
    event4.name = @"Halloween";
    event4.date = [formatter dateFromString:@"2015-10-31"];
    event4.image = [UIImage imageNamed:@"halloween"];
    
    return @[event1, event2, event3, event4];
}

- (NSString *)dateFormatted {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"MMM d, Y"];
    return [formatter stringFromDate:self.date];
}

- (NSString *)timeLeftFormatted {
    
    return [C4QTimeFormatter timeIntervalFormattedForMonths:self.timeLeft];
}

- (void)startTimer {
    C4QTimer *timer = [[C4QTimer alloc] initWithTimeInterval:1.0];
    timer.delegate = self;
    [timer start];
}

- (void)timerDidFire:(C4QTimer *)timer {
    self.timeLeft = [self.date timeIntervalSinceDate:[NSDate date]];
    if (self.delegate) {
        [self.delegate countdownEventDidUpdateTimeLeft:self];
    }
}

@end
