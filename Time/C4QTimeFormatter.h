//
//  C4QTimeFormatter.h
//  Time
//
//  Created by Michael Kavouras on 9/1/15.
//  Copyright © 2015 Mike Kavouras. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface C4QTimeFormatter : NSObject

+ (NSString *)timeIntervalFormattedForMinutesAndSeconds:(NSTimeInterval)timeInterval;
+ (NSString *)timeIntervalFormattedForHoursAndMinutes:(NSTimeInterval)timeInterval;
+ (NSString *)timeIntervalFormattedForDaysHoursAndMinutes:(NSTimeInterval)timeInterval;
+ (NSString *)timeIntervalFormattedForMonths:(NSTimeInterval)timeInterval;

@end
