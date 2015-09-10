//
//  C4QLapManager.m
//  Time
//
//  Created by Michael Kavouras on 8/22/15.
//  Copyright © 2015 Mike Kavouras. All rights reserved.
//

#import "C4QLapManager.h"
#import "C4QTimeFormatter.h"
#import "C4QTimedEvent.h"
#import "UIColor+TimerColors.h"

@interface C4QLapManager()

@property (nonatomic, readwrite) NSMutableArray *laps;
@property (nonatomic, readwrite) NSInteger fastestLapIndex;
@property (nonatomic, readwrite) NSInteger slowestLapIndex;

@end

@implementation C4QLapManager

- (NSMutableArray<C4QTimedEvent *> *)laps {
    if (!_laps) {
        _laps = [[NSMutableArray alloc] init];
    }
    return _laps;
}

- (void)addLap:(C4QTimedEvent *)lap {
    [self.laps addObject:lap];
    
    NSArray *sortedArray = [self.laps sortedArrayUsingSelector:@selector(compare:)];
    self.fastestLapIndex = [self.laps indexOfObject:[sortedArray firstObject]];
    self.slowestLapIndex = [self.laps indexOfObject:[sortedArray lastObject]];
}

- (void)reset {
    self.laps = [NSMutableArray new];
}

# pragma mark <UITableViewDataSource>

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.laps.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"LapCellIdentifier" forIndexPath:indexPath];
    
    C4QTimedEvent *lap = self.laps[indexPath.row];
    NSString *formattedLap = [C4QTimeFormatter timeIntervalFormattedForMinutesAndSeconds:lap.timeInterval];
    
    cell.textLabel.text = lap.name;
    cell.detailTextLabel.text = formattedLap;
    
    cell.detailTextLabel.textColor = [UIColor grayColor];
    cell.textLabel.textColor = [UIColor grayColor];
    
    if (indexPath.row == self.fastestLapIndex) {
        cell.textLabel.textColor = [UIColor startColor];
        cell.detailTextLabel.textColor = [UIColor startColor];
    } else if (indexPath.row == self.slowestLapIndex) {
        cell.textLabel.textColor = [UIColor stopColor];
        cell.detailTextLabel.textColor = [UIColor stopColor];
    }
    
    return cell;
}

@end
