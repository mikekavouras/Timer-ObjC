//
//  C4QPresetTimerSelectionTableViewController.m
//  Time
//
//  Created by Michael Kavouras on 8/23/15.
//  Copyright (c) 2015 Mike Kavouras. All rights reserved.
//

#import "C4QPresetTimerSelectionTableViewController.h"
#import "C4QNewPresetTimerViewController.h"
#import "C4QTimedEvent.h"
#import "C4QTimer.h"
#import "C4QTimeFormatter.h"
#import "UIColor+TimerColors.h"
#import "C4QPresetTimerTableViewCell.h"

@interface C4QPresetTimerSelectionTableViewController () <C4QPresetTimerDelegate>

@property (nonatomic, readwrite) NSMutableArray<C4QTimedEvent *> *timers;

@end

@implementation C4QPresetTimerSelectionTableViewController

- (NSMutableArray<C4QTimedEvent *> *)timers {
    if (!_timers) {
        _timers = [[NSMutableArray alloc] init];
    }
    return _timers;
}

#pragma mark Life cycle

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super initWithCoder:aDecoder]) {
        [self setup];
        return self;
    }
    return nil;
}

#pragma mark Setup

- (void)setup {
    [self setupDefaultTimers];
}

- (void)setupDefaultTimers {
    for (C4QTimedEvent *timer in [C4QTimedEvent defaultPresetTimers]) {
        [self.timers addObject:timer];
    }
}

#pragma mark Declarative

- (void)addTimer:(C4QTimedEvent *)timer {
    [self.timers insertObject:timer atIndex:0];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.timers.count + 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0 ) {
        return 44.0;
    }
    return 60.0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        C4QPresetTimerTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"NewPresetTimerCellIdentifer" forIndexPath:indexPath];
        cell.nameTextLabel.textColor = [UIColor startColor];
        cell.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.8];
        return cell;
    } else {
        C4QPresetTimerTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"PresetTimerCellIdentifier" forIndexPath:indexPath];
        C4QTimedEvent *timer = self.timers[indexPath.row - 1];
        [cell setSelected:NO];
        cell.nameTextLabel.text = timer.name;
        cell.timeTextLabel.text = [C4QTimeFormatter timeIntervalFormattedForHoursAndMinutes:timer.timeInterval];
        return cell;
    }
}

#pragma mark Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    if (indexPath.row != 0) {
        if (self.delegate) {
            C4QTimedEvent *timer = self.timers[indexPath.row - 1];
            [self.delegate presetTimerSelectionViewController:self didSelectPresetTimer:timer];
            [cell setSelected:NO animated:YES];
        }
    }
    [cell setSelected:NO animated:YES];
}

- (void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath {
    C4QNewPresetTimerViewController *viewController = [self.storyboard instantiateViewControllerWithIdentifier:@"PresetTimerController"];
    viewController.delegate = self;
    viewController.timer = self.timers[indexPath.row - 1];
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:viewController];
    [self presentViewController:nav animated:YES completion:nil];
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    [cell setSelected:NO animated:YES];
}

#pragma mark Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    UINavigationController *navController = segue.destinationViewController;
    C4QNewPresetTimerViewController *viewController = navController.viewControllers[0];
    viewController.delegate = self;
}


#pragma mark Preset timer delegate

- (void)presetTimerViewController:(C4QNewPresetTimerViewController *)viewController didCreateNewTimer:(C4QTimedEvent *)timer {
    __weak typeof(self) weakSelf = self;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 0.4 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
        [weakSelf addTimer:timer];
        NSArray *indexPaths = @[
           [NSIndexPath indexPathForRow:1 inSection:0]
        ];
        [weakSelf.tableView insertRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationTop];
    });
}

- (void)presetTimerViewController:(C4QNewPresetTimerViewController *)viewController didUpdateTimer:(C4QTimedEvent *)timer {
    [self.tableView reloadData];
}

- (void)presetTimerViewController:(C4QNewPresetTimerViewController *)viewController didDeleteTimer:(C4QTimedEvent *)timer {
    __weak typeof(self) weakSelf = self;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 0.4 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
        NSInteger index = [self.timers indexOfObject:timer];
        [self.timers removeObject:timer];
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:index + 1 inSection:0];
        [weakSelf.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationTop];
    });
}

@end
