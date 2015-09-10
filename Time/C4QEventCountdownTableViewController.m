//
//  C4QEventCountDownTableViewController.m
//  Time
//
//  Created by Michael Kavouras on 8/24/15.
//  Copyright © 2015 Mike Kavouras. All rights reserved.
//

#import "C4QEventCountdownTableViewController.h"
#import "C4QCountdownEvent.h"
#import "C4QEventCountdownTableViewCell.h"
#import "UIColor+TimerColors.h"

typedef enum CountdownState {
    EventName,
    CountdownTimer
} CountdownState;

@interface C4QEventCountdownTableViewController ()

@property (nonatomic) NSMutableSet<C4QCountdownEvent *> *events;
@property (nonatomic) CountdownState countdownState;

@end

@implementation C4QEventCountdownTableViewController

- (NSMutableSet<C4QCountdownEvent *> *)events {
    if (!_events) {
        _events = [[NSMutableSet alloc] init];
    }
    return _events;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super initWithCoder:aDecoder]) {
        [self setup];
        return self;
    }
    return nil;
}

#pragma mark Setup

- (void)setup {
    self.countdownState = EventName;
    [self setupNavigationItem];
    [self setupTabBarItem];
    [self setupDefaultEvents];
}

- (void)setupNavigationItem {
    self.navigationItem.rightBarButtonItem.tintColor = [UIColor stopColor];
}

- (void)setupTabBarItem {
    UIImage *defaultImage = [[UIImage imageNamed:@"event"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    UIImage *selectedImage = [[UIImage imageNamed:@"event_filled"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    
    self.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"Events" image:defaultImage selectedImage:selectedImage];
    
    self.navigationItem.title = @"Events Countdown";
}

- (void)setupDefaultEvents {
    for (C4QCountdownEvent *event in [C4QCountdownEvent defaultEvents]) {
        [self addEvent: event];
    }
}

- (void)addEvent:(C4QCountdownEvent *)event {
    [self.events addObject:event];
}

#pragma mark Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.events allObjects].count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 140.0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    C4QEventCountdownTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"EventCellIdentifier" forIndexPath:indexPath];
    
    C4QCountdownEvent *event = [[self.events allObjects] objectAtIndex:indexPath.row];
    cell.event = event;
    
    if (self.countdownState == CountdownTimer) {
        cell.countdownTextLabel.hidden = NO;
        cell.nameTextLabel.hidden = YES;
        cell.dateTextLabel.hidden = YES;
    } else {
        cell.countdownTextLabel.hidden = YES;
        cell.nameTextLabel.hidden = NO;
        cell.dateTextLabel.hidden = NO;
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    self.countdownState = self.countdownState == EventName ? CountdownTimer : EventName;
    [self.tableView reloadData];
}


@end
