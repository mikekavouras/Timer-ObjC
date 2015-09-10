//
//  C4QNewCountdownEventTableViewController.m
//  Time
//
//  Created by Michael Kavouras on 8/24/15.
//  Copyright © 2015 Mike Kavouras. All rights reserved.
//

#import "C4QNewCountdownEventTableViewController.h"
#import "UIColor+TimerColors.h"

@interface C4QNewCountdownEventTableViewController ()

@property (weak, nonatomic) IBOutlet UITextField *nameLabel;

@end

@implementation C4QNewCountdownEventTableViewController

#pragma mark Life cycle

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super initWithCoder:aDecoder]) {
        [self setup];
        return self;
    }
    return nil;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.nameLabel becomeFirstResponder];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.nameLabel resignFirstResponder];
}

#pragma mark Setup

- (void)setup {
    [self setupNavigationItem];
}

- (void)setupNavigationItem {
    self.navigationItem.rightBarButtonItem.tintColor = [UIColor stopColor];
    self.navigationItem.leftBarButtonItem.tintColor = [UIColor stopColor];
}

#pragma mark IBAction

- (IBAction)cancelButtonTapped:(UIBarButtonItem *)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)saveButtonTapped:(UIBarButtonItem *)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}


@end
