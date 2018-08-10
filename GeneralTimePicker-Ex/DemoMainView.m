//
//  DemoMainView.m
//  GeneralTimePicker
//
//  Created by xush on 2018/8/3.
//  Copyright © 2018年 Xush. All rights reserved.
//

#import "DemoMainView.h"

#define UIColorFromHex(hexValue)        [UIColor colorWithRed:(((hexValue & 0xFF0000) >> 16))/255.0f green:(((hexValue & 0xFF00) >> 8))/255.0f blue:((hexValue & 0xFF))/255.0f alpha:1.0f]

@interface DemoMainView () <UITableViewDelegate, UITableViewDataSource, TimeZonePickerDelegate>

@end

@implementation DemoMainView

#pragma mark - init

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = UIColorFromHex(0xf1f1f1);
        [self initView];
    }
    return self;
}

- (void)initView {
    [self addSubview:self.dateLab];
    [self addSubview:self.timeZonePiker];
    [self addSubview:self.tableV];
}

#pragma mark - lazyload

- (UILabel *)dateLab {
    if (!_dateLab) {
        _dateLab = [[UILabel alloc] initWithFrame:(CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 100))];
        _dateLab.textAlignment = NSTextAlignmentCenter;
    }
    return _dateLab;
}

- (TimeZonePicker *)timeZonePiker {
    if (!_timeZonePiker) {
        //_timeZonePiker = [[TimeZonePicker alloc] initWithFrame:(CGRectMake(0, 100, [UIScreen mainScreen].bounds.size.width, 100))];
        _timeZonePiker = [[TimeZonePicker alloc] initWithFrame:CGRectMake(0, 100, [UIScreen mainScreen].bounds.size.width, 200)
                                                   maxDate:[NSDate dateWithTimeIntervalSinceNow:7*24*60*60]
                                                   minDate:[NSDate dateWithTimeIntervalSinceNow:60*60]// 最早提货时间要延后1小时
                                        showValidDatesOnly:YES];
        _timeZonePiker.showOnlyValidDates = YES;
        _timeZonePiker.minDayTime = 10;
        _timeZonePiker.maxDayTime = 20;
        _timeZonePiker.timeInterval = 0.5;
        _timeZonePiker.backgroundColor = [UIColor whiteColor];
        _timeZonePiker.delegate = self;
     }
    return _timeZonePiker;
}

- (UITableView *)tableV {
    if (!_tableV) {
        _tableV = [[UITableView alloc] initWithFrame:(CGRectMake(0, 300, [UIScreen mainScreen].bounds.size.width, self.frame.size.height-300)) style:(UITableViewStylePlain)];
        _tableV.dataSource = self;
        _tableV.delegate = self;
    }
    return _tableV;
}

- (NSArray *)cellDataArr {
    if (!_cellDataArr) {
        _cellDataArr = @[@[@"minDate", @"maxDate", @"minDayTime", @"maxDayTime", @"timeInterval"]];
    }
    return _cellDataArr;
}

- (NSArray *)cellDetailArr1 {
    if (!_cellDetailArr1) {
        _cellDetailArr1 = @[@[@"NowTime+0.5hour", @"NowTime+7days", @"10 o'clock", @"20 o'clock", @"0.5 hour"]];
    }
    return _cellDetailArr1;
}

- (NSArray *)cellDetailArr2 {
    if (!_cellDetailArr2) {
        _cellDetailArr2 = @[@[@"1970+0hour", @"1970+0hour", @"0 o'clock", @"0 o'clock", @"0 hour"]];
    }
    return _cellDetailArr2;

}

#pragma mark - action


#pragma mark - TimeZonePickerDelegate

- (void)dateChanged:(TimeZonePicker *)sender {
    self.dateLab.text = [self timeIntervalToHalfHourZoneWithDate:sender.date];
}

#pragma mark - UITableViewDelegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return ((NSArray *)self.cellDataArr[section]).count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *HomeMapIdentifier = @"mainCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:HomeMapIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:HomeMapIdentifier];
    }
    cell.textLabel.text = self.cellDataArr[indexPath.section][indexPath.row];
    cell.detailTextLabel.text = self.cellDetailArr1[indexPath.section][indexPath.row];
    return cell;
}

#pragma mark - UITableViewDataSource

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 10.0f;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *view = [[UIView alloc] initWithFrame:(CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 5))];
    view.backgroundColor = UIColorFromHex(0xf1f1f1);
    return view;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(    NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    BOOL isNormal = [cell.detailTextLabel.text isEqualToString:self.cellDetailArr1[indexPath.section][indexPath.row]];
    if (isNormal) {
        cell.detailTextLabel.text = self.cellDetailArr2[indexPath.section][indexPath.row];
    }else {
        cell.detailTextLabel.text = self.cellDetailArr1[indexPath.section][indexPath.row];
    }
    switch (indexPath.section) {
        case 0: { //
            switch (indexPath.row) {
                case 0: {
                    if (isNormal) {
                        self.timeZonePiker.minDate = [NSDate date];
                    }else {
                        self.timeZonePiker.minDate = [NSDate dateWithTimeIntervalSinceNow:60*60];
                    }
                    break;}
                case 1: {
                    if (isNormal) {
                        self.timeZonePiker.maxDate = [NSDate date];
                    }else {
                        self.timeZonePiker.maxDate = [NSDate dateWithTimeIntervalSinceNow:3600*24*7];
                    }
                    break;}
                case 2: {
                    if (isNormal) {
                        self.timeZonePiker.minDayTime = 0;
                    }else {
                        self.timeZonePiker.minDayTime = 10;
                    }
                    break;}
                case 3: {
                    if (isNormal) {
                        self.timeZonePiker.maxDayTime = 20;
                    }else {
                        self.timeZonePiker.maxDayTime = 0;
                    }
                    break;}
                case 4: {
                    if (isNormal) {
                        self.timeZonePiker.timeInterval = 0.5;
                    }else {
                        self.timeZonePiker.timeInterval = 0;
                    }
                    break;}

                default:
                    break;
            }
            break;}
        default:
            break;
    }
    [self.timeZonePiker.picker reloadAllComponents];

}

#pragma mark - other

- (NSString *)timeIntervalToHalfHourZoneWithDate:(NSDate *)date {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"MM月dd日 HH mm"];
    NSString *dateStr = [dateFormatter stringFromDate:date];
    NSArray *array = [dateStr componentsSeparatedByString:@" "]; //从字符A中分隔成2个元素的数组
    NSInteger hour = [(NSString *)array[1] integerValue];
    NSInteger minute = [(NSString *)array[2] integerValue];
    if (minute < 30) {
        return [NSString stringWithFormat:@"%@ %ld:00-%ld:30 ", array[0], (long)hour, (long)hour];
    }else {
        return [NSString stringWithFormat:@"%@ %ld:30-%ld:00 ", array[0], (long)hour, (long)hour+1];
    }
}

#pragma mark - data set


@end
