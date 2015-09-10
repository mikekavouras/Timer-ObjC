//
//  C4QStopWatchViewController.m
//  Time
//
//  Created by Michael Kavouras on 8/22/15.
//  Copyright © 2015 Mike Kavouras. All rights reserved.
//

#import "C4QStopWatchViewController.h"
#import "C4QTimer.h"
#import "UIColor+TimerColors.h"
#import "C4QLapManager.h"
#import "C4QTimedEvent.h"
#import "C4QTimeFormatter.h"

// enum for managing state
typedef enum StopWatchState {
    StopWatchStateDefault,
    StopWatchStateStarted,
    StopWatchStateStopped
} StopWatchState;

// conform to C4QTimerDelegate protocol
@interface C4QStopWatchViewController () <C4QTimerDelegate>

// IBOutlet
@property (weak, nonatomic) IBOutlet UILabel *mainTimerLabel;
@property (weak, nonatomic) IBOutlet UILabel *lapTimerLabel;
@property (weak, nonatomic) IBOutlet UIButton *timerButton;
@property (weak, nonatomic) IBOutlet UIButton *lapButton;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic) C4QTimer *timer;
@property (nonatomic) C4QLapManager *lapManager;

// State
@property (nonatomic) StopWatchState state;

@end

@implementation C4QStopWatchViewController

#pragma mark Life cycle

// Lazy instantiation of self.lapManager
- (C4QLapManager *)lapManager {
    if (!_lapManager) {
        _lapManager = [[C4QLapManager alloc] init];
    }
    return _lapManager;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super initWithCoder:aDecoder]) {
        [self setup];
        return self;
    }
    return nil;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupUI];
    [self reset];
}

#pragma mark Setup

- (void)setup {
    [self setupTabBarItem];
    [self setupNavigationItem];
}

- (void)setupTabBarItem {
    UIImage *defaultImage = [[UIImage imageNamed:@"stopwatch"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    UIImage *selectedImage = [[UIImage imageNamed:@"stopwatch_filled"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    
    self.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"Stopwatch" image:defaultImage selectedImage:selectedImage];
}

- (void)setupNavigationItem {
    self.navigationItem.title = @"Stopwatch";
}

- (void)setupUI {
    self.mainTimerLabel.adjustsFontSizeToFitWidth = YES;
    self.timerButton.layer.cornerRadius = 40.0;
    self.lapButton.layer.cornerRadius = 40.0;
    self.tableView.delegate = self.lapManager;
    self.tableView.dataSource = self.lapManager;
}

#pragma mark IBAction

- (IBAction)startStopButtonTapped:(UIButton *)sender {
    switch (self.state) {
        case StopWatchStateDefault:
            [self startTimer];
            break;
        case StopWatchStateStarted:
            [self stopTimer];
            break;
        case StopWatchStateStopped:
            [self startTimer];
            break;
        default:
            return;
    }
}

- (IBAction)lapButtonTapped:(UIButton *)sender {
    if (self.state == StopWatchStateStopped) {
        [self reset];
    } else {
        [self lap];
    }
}

#pragma mark Imperative (state)

- (void)startTimer {
    [UIApplication sharedApplication].idleTimerDisabled = YES;
    self.state = StopWatchStateStarted;
    
    [self.timer start];
//    [self.lapTimer start];
    
    [self.timerButton setTitle:@"Stop" forState:UIControlStateNormal];
    [self.timerButton setTitleColor:[UIColor stopColor] forState:UIControlStateNormal];
    
    [self.lapButton setTitle:@"Lap" forState:UIControlStateNormal];
}

- (void)stopTimer {
    [UIApplication sharedApplication].idleTimerDisabled = NO;
    self.state = StopWatchStateStopped;
    [self.timer stop];
//    [self.lapTimer stop];
    
    [self.timerButton setTitle:@"Start" forState:UIControlStateNormal];
    [self.timerButton setTitleColor:[UIColor startColor] forState:UIControlStateNormal];
    
    [self.lapButton setTitle:@"Reset" forState:UIControlStateNormal];
}

- (void)lap {
    if (self.state != StopWatchStateDefault) {
        
        // add lap
        NSTimeInterval time = self.timer.lapTime;
        
        C4QTimedEvent *lap = [[C4QTimedEvent alloc] initWithTimeInterval:time];
        lap.name = [NSString stringWithFormat:@"Lap %ld", (long)(self.lapManager.laps.count + 1)];
        [self.lapManager addLap:lap];
        
        // reset lap timer
        [self.timer lap];
        
        // reload table
        
        [self.tableView reloadData];
        [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:self.lapManager.laps.count - 1 inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:YES];
        
    }
}

#pragma mark Imperative (reset)

- (void)reset {
    [self resetState];
    [self resetUI];
    [self resetMainTimer];
    [self.lapManager reset];
    [self.tableView reloadData];
}

- (void)resetState {
    self.state = StopWatchStateDefault;
}

- (void)resetUI {
    self.mainTimerLabel.text = @"00:00.00";
    self.lapTimerLabel.text = @"00:00.00";
    [self.lapButton setTitle:@"Lap" forState:UIControlStateNormal];
    [self.timerButton setTitle:@"Start" forState:UIControlStateNormal];
    
    [self.timerButton setTitleColor:[UIColor startColor] forState:UIControlStateNormal];
}

- (void)resetMainTimer {
    self.timer = [[C4QTimer alloc] init];
    self.timer.delegate = self;
}

# pragma mark Timer delegate

- (void)timerDidFire:(C4QTimer *)timer {
    self.mainTimerLabel.text = [C4QTimeFormatter timeIntervalFormattedForMinutesAndSeconds:timer.elapsedTime];
    self.lapTimerLabel.text = [C4QTimeFormatter timeIntervalFormattedForMinutesAndSeconds:timer.lapTime];
}

@end
