//
//  C4QTimeFormatter.m
//  Time
//
//  Created by Michael Kavouras on 9/1/15.
//  Copyright © 2015 Mike Kavouras. All rights reserved.
//

#import "C4QTimeFormatter.h"

static NSString* pad(NSInteger number) {
    return number < 10 ? [NSString stringWithFormat:@"0%d", (int)number] : [NSString stringWithFormat:@"%d", (int)number];
}

@implementation C4QTimeFormatter

+ (NSString *)timeIntervalFormattedForMinutesAndSeconds:(NSTimeInterval)timeInterval {
    NSTimeInterval seconds = fmod(timeInterval, 60);
    NSString *paddedSeconds = seconds < 10 ? [NSString stringWithFormat:@"0%.2f", seconds] : [NSString stringWithFormat:@"%.2f", seconds];
    NSInteger minutes = floor(timeInterval / 60);
    NSString *paddedMinutes = minutes < 10 ? [NSString stringWithFormat:@"0%ld", (long)minutes] : [NSString stringWithFormat:@"%ld", (long)minutes];
    return [NSString stringWithFormat:@"%@:%@", paddedMinutes, paddedSeconds];
}

+ (NSString *)timeIntervalFormattedForHoursAndMinutes:(NSTimeInterval)timeInterval {
    NSTimeInterval seconds = fmod(timeInterval, 60);
    NSString *paddedSeconds = seconds < 10 ? [NSString stringWithFormat:@"0%d", (int)seconds] : [NSString stringWithFormat:@"%d", (int)seconds];
    NSTimeInterval rawMinutes = floor(timeInterval / 60.0);
    NSInteger minutes = fmod(rawMinutes, 60);
    NSString *paddedMinutes = minutes < 10 ? [NSString stringWithFormat:@"0%ld", (long)minutes] : [NSString stringWithFormat:@"%ld", (long)minutes];
    NSInteger hours = floor(rawMinutes / 60);
    NSString *paddedHours = hours < 10 ? [NSString stringWithFormat:@"0%ld", (long)hours] : [NSString stringWithFormat:@"%ld", (long)hours];
    if (!!!hours || hours < 0) {
        return [NSString stringWithFormat:@"%@:%@", paddedMinutes, paddedSeconds];
    } else {
        return [NSString stringWithFormat:@"%@:%@:%@", paddedHours, paddedMinutes, paddedSeconds];
    }
}

+ (NSString *)timeIntervalFormattedForDaysHoursAndMinutes:(NSTimeInterval)timeInterval {
    NSTimeInterval seconds = fmod(timeInterval, 60);
    NSTimeInterval rawMinutes = floor(timeInterval / 60.0);
    NSTimeInterval minutes = fmod(rawMinutes, 60);
    NSTimeInterval rawHours = floor(rawMinutes / 60);
    NSTimeInterval hours = fmod(rawHours, 24);
    NSTimeInterval days = floor(rawHours / 24);
    NSString *paddedSeconds = pad(seconds);
    NSString *paddedMinutes = pad(minutes);
    NSString *paddedHours = pad(hours);
    NSString *paddedDays = pad(days);
    
    if (days < 0) {
        return [NSString stringWithFormat:@"%@hours %@minutes %@seconds", paddedHours, paddedMinutes, paddedSeconds];
    } else if (hours < 0) {
        return [NSString stringWithFormat:@"%@minutes %@seconds", paddedMinutes, paddedSeconds];
    } else {
        return [NSString stringWithFormat:@"%@d %@h %@m %@s", paddedDays, paddedHours, paddedMinutes, paddedSeconds];
    }
}

// http://stackoverflow.com/questions/1237778/how-do-i-break-down-an-nstimeinterval-into-year-months-days-hours-minutes-an
+ (NSString *)timeIntervalFormattedForMonths:(NSTimeInterval)timeInterval {
    
    // Create the NSDates
    NSDate *date1 = [[NSDate alloc] init];
    NSDate *date2 = [[NSDate alloc] initWithTimeInterval:timeInterval sinceDate:date1];
    
    // Get conversion to months, days, hours, minutes
    NSCalendarUnit unitFlags = NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitSecond;
    
    NSDateComponents *breakdownInfo = [[NSCalendar currentCalendar] components:unitFlags fromDate:date1 toDate:date2  options:0];
    
    NSString *month = pad([breakdownInfo month]);
    NSString *day = pad([breakdownInfo day]);
    NSString *hour = pad([breakdownInfo hour]);
    NSString *minute = pad([breakdownInfo minute]);
    NSString *second = pad([breakdownInfo second]);
    
    return [NSString stringWithFormat:@"%@mo %@d %@h %@m %@s", month, day, hour, minute, second];
}

@end
