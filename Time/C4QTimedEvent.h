//
//  C4QTimedEvent.h
//  Time
//
//  Created by Michael Kavouras on 9/1/15.
//  Copyright © 2015 Mike Kavouras. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface C4QTimedEvent : NSObject

@property (nonatomic) NSTimeInterval timeInterval;
@property (nonatomic) NSString *name;

- (instancetype)initWithTimeInterval:(NSTimeInterval)timeInterval;

+ (NSArray <C4QTimedEvent *> *)defaultPresetTimers;

@end
