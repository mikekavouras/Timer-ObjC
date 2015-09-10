//
//  C4QEventCountdownTableViewCell.h
//  Time
//
//  Created by Michael Kavouras on 8/24/15.
//  Copyright © 2015 Mike Kavouras. All rights reserved.
//

#import <UIKit/UIKit.h>

@class C4QCountdownEvent;

@interface C4QEventCountdownTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *nameTextLabel;
@property (weak, nonatomic) IBOutlet UILabel *dateTextLabel;
@property (weak, nonatomic) IBOutlet UILabel *countdownTextLabel;
@property (weak, nonatomic) IBOutlet UIImageView *backgroundImageView;

@property (nonatomic, weak) C4QCountdownEvent *event;

@end
