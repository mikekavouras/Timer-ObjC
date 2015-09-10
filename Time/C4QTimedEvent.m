//
//  C4QTimedEvent.m
//  Time
//
//  Created by Michael Kavouras on 9/1/15.
//  Copyright © 2015 Mike Kavouras. All rights reserved.
//

#import "C4QTimedEvent.h"

@implementation C4QTimedEvent

- (instancetype)initWithTimeInterval:(NSTimeInterval)timeInterval {
    if (self = [super init]) {
        self.timeInterval = timeInterval;
        return self;
    }
    return nil;
}

- (NSComparisonResult)compare:(C4QTimedEvent *)otherTimedObject {
    return self.timeInterval > otherTimedObject.timeInterval;
}

+ (NSArray<C4QTimedEvent *> *)defaultPresetTimers {
    C4QTimedEvent *timer1 = [[C4QTimedEvent alloc] init];
    timer1.name = @"Popcorn";
    timer1.timeInterval = 60 * 3.0;
    
    C4QTimedEvent *timer2 = [[C4QTimedEvent alloc] init];
    timer2.name = @"Baked Potato";
    timer2.timeInterval = 60 * 5.0;
    
    C4QTimedEvent *timer3 = [[C4QTimedEvent alloc] init];
    timer3.name = @"Running";
    timer3.timeInterval = 60 * 15.0;
    
    C4QTimedEvent *timer4 = [[C4QTimedEvent alloc] init];
    timer4.name = @"Nap";
    timer4.timeInterval = 60 * 20.0;
    
    return @[ timer1, timer2, timer3, timer4 ];
}

@end
