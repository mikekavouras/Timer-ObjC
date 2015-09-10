//
//  C4QEventCountdownTableViewCell.m
//  Time
//
//  Created by Michael Kavouras on 8/24/15.
//  Copyright © 2015 Mike Kavouras. All rights reserved.
//

#import "C4QEventCountdownTableViewCell.h"
#import "C4QCountdownEvent.h"

@interface C4QEventCountdownTableViewCell() <C4QCountdownEventDelegate>

@end

@implementation C4QEventCountdownTableViewCell

- (void)setEvent:(C4QCountdownEvent *)event {
    event.delegate = self;
    self.nameTextLabel.text = event.name;
    self.dateTextLabel.text = [event dateFormatted];
    self.countdownTextLabel.text = [event timeLeftFormatted];
    self.backgroundImageView.image = event.image;
    _event = event;
}

- (void)countdownEventDidUpdateTimeLeft:(C4QCountdownEvent *)event {
    self.countdownTextLabel.text = [event timeLeftFormatted];
}

@end
