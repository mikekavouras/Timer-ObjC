//
//  C4QTimerViewController.m
//  Time
//
//  Created by Michael Kavouras on 8/22/15.
//  Copyright © 2015 Mike Kavouras. All rights reserved.
//

#import "C4QTimerViewController.h"
#import "C4QTimer.h"
#import "UIColor+TimerColors.h"
#import "UIViewController+HeirarchyManager.h"
#import "C4QTimedEvent.h"
#import "C4QPresetTimerSelectionTableViewController.h"
#import <AudioToolbox/AudioServices.h>
#import "C4QTimeFormatter.h"

// enum to keep track of state
typedef enum TimerState {
    TimerStateDefault,
    TimerStateStarted,
    TimerStatePaused
} TimerState;

@interface C4QTimerViewController () <C4QTimerDelegate, C4QPresetTimerDelegate>

@property (weak, nonatomic) IBOutlet UILabel *timerLabel;
@property (weak, nonatomic) IBOutlet UIDatePicker *datePicker;
@property (weak, nonatomic) IBOutlet UIButton *timerButton;
@property (weak, nonatomic) IBOutlet UIButton *stateButton;
@property (weak, nonatomic) IBOutlet UIView *presetsView;
@property (weak, nonatomic) IBOutlet UILabel *timerNameLabel;

@property (weak, nonatomic) IBOutlet UIView *contentView;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *contentViewWidthConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *contentViewHeightConstraint;
@property (weak, nonatomic) IBOutlet UIView *bottomView;

@property (nonatomic) C4QTimer *countDownTimer;

// state
@property (nonatomic) NSTimeInterval countDownDuration;
@property (nonatomic) TimerState state;

@end

@implementation C4QTimerViewController

#pragma mark Life cycle

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
    [self resetUI];
    
    [self embedPresetTimerTableViewController];
}

- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    
    self.contentViewWidthConstraint.constant = self.view.frame.size.width * 2.0;
    self.contentViewHeightConstraint.constant = self.bottomView.frame.size.height;
}

#pragma mark Setup

- (void)setup {
    [self setupTabBarItem];
    [self setupNavigationItem];
}

- (void)setupUI {
    self.timerLabel.adjustsFontSizeToFitWidth = YES;
    self.stateButton.layer.cornerRadius = 40.0;
    self.timerButton.layer.cornerRadius = 40.0;
    
    self.datePicker.datePickerMode = UIDatePickerModeCountDownTimer;
    self.datePicker.countDownDuration = 60;
    
    self.timerLabel.alpha = 0.0;
    self.datePicker.alpha = 1.0;
}

- (void)setupTabBarItem {
    UIImage *defaultImage = [[UIImage imageNamed:@"timer"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    UIImage *selectedImage = [[UIImage imageNamed:@"timer_filled"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    
    self.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"Timer" image:defaultImage selectedImage:selectedImage];
}

- (void)setupNavigationItem {
    self.navigationItem.title = @"Timer";
}

#pragma mark IBAction

- (IBAction)timerButtonTapped:(UIButton *)sender {
    switch (self.state) {
        case TimerStateDefault:
            [self newTimer:self.datePicker.countDownDuration];
            break;
        case TimerStatePaused:
            [self cancelTimer];
            break;
        case TimerStateStarted:
            [self cancelTimer];
            break;
        default:
            return;
    }
}

- (IBAction)stateButtonTapped:(UIButton *)sender {
    switch (self.state) {
        case TimerStateDefault:
            break;
        case TimerStatePaused:
            [self startTimer];
            return;
        case TimerStateStarted:
            [self pauseTimer];
            break;
        default:
            break;
    }
}

- (IBAction)datePickerTouched:(UIDatePicker *)sender {
    [self.scrollView setContentOffset:CGPointMake(0, 0) animated:YES];
}

#pragma mark State

- (void)newTimer:(NSTimeInterval)timeInterval {
    [UIView animateWithDuration:0.3 animations:^{
        self.timerLabel.alpha = 1.0;
        self.datePicker.alpha = 0.0;
    }];
    
    self.countDownDuration = timeInterval;
    self.timerLabel.text = [C4QTimeFormatter timeIntervalFormattedForHoursAndMinutes:self.countDownDuration];
    
    [self startTimer];
}

- (void)startTimer {
    self.countDownTimer = [[C4QTimer alloc] initWithTimeInterval:1.0];
    self.countDownTimer.delegate = self;
    [self.countDownTimer start];
    
    [self.timerButton setTitle:@"Cancel" forState:UIControlStateNormal];
    [self.timerButton setTitleColor:[UIColor stopColor] forState:UIControlStateNormal];
    
    [self.stateButton setTitle:@"Pause" forState:UIControlStateNormal];
    [self.stateButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self.stateButton setBackgroundColor:[UIColor whiteColor]];
    
    self.stateButton.enabled = YES;
    self.state = TimerStateStarted;
}

- (void)pauseTimer {
    self.state = TimerStatePaused;
    [self.countDownTimer stop];
    [self.stateButton setTitle:@"Resume" forState:UIControlStateNormal];
}

- (void)cancelTimer {
    [self reset];
}

- (void)timerDone {
    __weak typeof(self) weakSelf = self;
    UIAlertAction *defaultAction = [UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
        [weakSelf dismissViewControllerAnimated:YES completion:nil];
    }];
    NSString *title = [NSString stringWithFormat:@"%@ timer done!", self.timerNameLabel.text];
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:title message:@"" preferredStyle:UIAlertControllerStyleAlert];
    [alertController addAction:defaultAction];
    [self presentViewController:alertController animated:YES completion:nil];
    [self reset];
    
    AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
}

#pragma mark Reset

- (void)reset {
    
    [self resetState];
    [self resetTimer];
    [self resetUI];
    
    self.stateButton.enabled = NO;
    [UIView animateWithDuration:0.3 animations:^{
        self.datePicker.alpha = 1.0;
        self.timerLabel.alpha = 0.0;
    } completion:^(BOOL finished) {
        self.timerLabel.text = @"00:00:00";
    }];
    
}

- (void)resetState {
    self.state = TimerStateDefault;
}

- (void)resetTimer {
    [self.countDownTimer stop];
}

- (void)resetUI {
    [self.timerButton setTitle:@"Start" forState:UIControlStateNormal];
    [self.timerButton setTitleColor:[UIColor startColor] forState:UIControlStateNormal];
    [self.stateButton setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    [self.stateButton setBackgroundColor:[[UIColor whiteColor] colorWithAlphaComponent:0.6]];
    self.timerNameLabel.text = @"";
}

#pragma mark Declarative

- (void)embedPresetTimerTableViewController {
    C4QPresetTimerSelectionTableViewController *viewController = [self.storyboard instantiateViewControllerWithIdentifier:@"PresetTimerTableController"];
    viewController.delegate = self;
    [self addViewController:viewController toView:self.presetsView];
}

#pragma mark C4QTimer delegate

- (void)timerDidFire:(C4QTimer *)timer {
    self.countDownDuration--;
    self.timerLabel.text = [C4QTimeFormatter timeIntervalFormattedForHoursAndMinutes:self.countDownDuration];
    
    if (self.countDownDuration == 0) {
        [self.countDownTimer reset];
        [self timerDone];
    }
}

#pragma mark C4QPresetTimer delegate

- (void)presetTimerSelectionViewController:(C4QPresetTimerSelectionTableViewController *)viewController didSelectPresetTimer:(C4QTimedEvent *)timer {

    [self resetTimer];
    
    [self newTimer:timer.timeInterval];
    
    [self.scrollView setContentOffset:CGPointMake(0, 0) animated:YES];
    
    self.timerNameLabel.text = timer.name;
}

@end
