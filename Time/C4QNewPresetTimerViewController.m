//
//  C4QNewPresetTimerViewController.m
//  Time
//
//  Created by Michael Kavouras on 8/23/15.
//  Copyright (c) 2015 Mike Kavouras. All rights reserved.
//

#import "C4QNewPresetTimerViewController.h"
#import "C4QTimedEvent.h"
#import "UIColor+TimerColors.h"

@interface C4QNewPresetTimerViewController () <UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UIDatePicker *datePicker;
@property (weak, nonatomic) IBOutlet UITextField *nameTextField;
@property (weak, nonatomic) IBOutlet UIButton *deleteButton;

@end

@implementation C4QNewPresetTimerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.datePicker.datePickerMode = UIDatePickerModeCountDownTimer;
    self.datePicker.countDownDuration = 60;
    
    UIView *paddingView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 5, 20)];
    self.nameTextField.leftView = paddingView;
    self.nameTextField.leftViewMode = UITextFieldViewModeAlways;
    self.nameTextField.tintColor = [UIColor stopColor];
    
    self.navigationItem.leftBarButtonItem.tintColor = [UIColor stopColor];
    self.navigationItem.rightBarButtonItem.tintColor = [UIColor stopColor];
    
    if (self.timer) {
        self.nameTextField.text = self.timer.name;
        self.datePicker.countDownDuration = self.timer.timeInterval;
        [self.deleteButton setTitleColor:[UIColor stopColor] forState:UIControlStateNormal];
    } else {
        self.deleteButton.hidden = YES;
        self.navigationItem.title = @"New Timer";
    }
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.nameTextField becomeFirstResponder];
}

- (void)viewWillDisappear:(BOOL)animated {
    [self.nameTextField resignFirstResponder];
}

#pragma mark IBAction

- (IBAction)cancelButtonTapped:(UIBarButtonItem *)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)saveButtonTapped:(id)sender {
    if ([self.nameTextField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]].length == 0) {
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Womp womp" message:@"Your timer needs a name!" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleCancel handler:nil];
        [alertController addAction:defaultAction];
        [self presentViewController:alertController animated:YES completion:nil];
    } else {
        if (self.delegate) {
            if (self.timer) {
                self.timer.name = self.nameTextField.text;
                self.timer.timeInterval = self.datePicker.countDownDuration;
                [self.delegate presetTimerViewController:self didUpdateTimer:self.timer];
            } else {
                C4QTimedEvent *timer = [[C4QTimedEvent alloc] init];
                timer.timeInterval = self.datePicker.countDownDuration;
                timer.name = self.nameTextField.text;
                [self.delegate presetTimerViewController:self didCreateNewTimer:timer];
            }
        }
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}

- (IBAction)deleteButtonTapped:(UIButton *)sender {
    if (self.delegate) {
        [self.delegate presetTimerViewController:self didDeleteTimer:self.timer];
    }
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
