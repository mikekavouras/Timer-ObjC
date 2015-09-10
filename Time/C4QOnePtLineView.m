//
//  C4QOnePtLineView.m
//  Time
//
//  Created by Michael Kavouras on 8/23/15.
//  Copyright © 2015 Mike Kavouras. All rights reserved.
//

#import "C4QOnePtLineView.h"

@interface C4QOnePtLineView()

@property (nonatomic, weak) IBOutlet NSLayoutConstraint *heightConstraint;

@end

@implementation C4QOnePtLineView

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.heightConstraint.constant = 0.5;
}

@end
