//
//  C4QCountDownEvent.h
//  Time
//
//  Created by Michael Kavouras on 8/24/15.
//  Copyright © 2015 Mike Kavouras. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@protocol C4QCountdownEventDelegate;

@interface C4QCountdownEvent : NSObject

@property (nonatomic) NSString *name;
@property (nonatomic) NSDate *date;
@property (nonatomic, readonly) NSTimeInterval timeLeft;
@property (nonatomic) UIImage *image;

@property (nonatomic, weak) id<C4QCountdownEventDelegate>delegate;

- (NSString *)dateFormatted;
- (NSString *)timeLeftFormatted;

+ (NSArray<C4QCountdownEvent *> *)defaultEvents;

@end

@protocol C4QCountdownEventDelegate <NSObject>

- (void)countdownEventDidUpdateTimeLeft:(C4QCountdownEvent *)event;

@end
