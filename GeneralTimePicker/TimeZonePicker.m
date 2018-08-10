//
//  TimeZonePicker.m
//  GeneralTimePicker
//
//  Created by xush on 2018/8/3.
//  Copyright © 2018年 Xush. All rights reserved.
//

#import "TimeZonePicker.h"

@interface TimeZonePicker () <UIPickerViewDataSource, UIPickerViewDelegate>
{
    NSInteger nDays;
}

@property (nonatomic, strong) NSCalendar *calendar;

@end

@implementation TimeZonePicker

#pragma mark - init

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (!self) {
        return nil;
    }
    self.minDate = [NSDate dateWithTimeIntervalSince1970:0];
    [self commonInit];
    
    return self;
}

- (void)commonInit {
    [self setBackgroundColor:[UIColor blackColor]];
    self.calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    self.picker = [[UIPickerView alloc] initWithFrame:self.bounds];
    self.picker.dataSource = self;
    self.picker.delegate = self;
    [self initDate];
    [self showDateOnPicker:self.date];
    [self addSubview:self.picker];
    [self.picker selectRow:0 inComponent:0 animated:YES];
}

- (id)initWithFrame:(CGRect)frame maxDate:(NSDate *)maxDate minDate:(NSDate *)minDate showValidDatesOnly:(BOOL)showValidDatesOnly {
    self = [super initWithFrame:frame];
    if (!self) {
        return nil;
    }
    NSAssert((((minDate) && (maxDate)) && ([minDate compare:maxDate] != NSOrderedDescending)), @"最小时间大于最大时间什么鬼？");
    self.minDate = minDate;
    self.maxDate = maxDate;
    self.showOnlyValidDates = showValidDatesOnly;
    
    [self commonInit];
    
    return self;
}

- (id)initWithCoder:(NSCoder *)coder {
    self = [super initWithCoder:coder];
    if (!self) {
        return nil;
    }
    [self commonInit];
    return self;
}

#pragma mark - lazy load

- (NSDate *)minDate {
    if (!_minDate) {
        _minDate = [NSDate dateWithTimeIntervalSince1970:0];
    }
    return _minDate;
}

- (NSDate *)maxDate {
    if (!_maxDate) {
        _maxDate = [NSDate dateWithTimeIntervalSinceNow:7*24*60*60];
    }
    return _maxDate;
}

#pragma mark - action

-(void)showDateOnPicker:(NSDate *)date {
    self.date = date;
    
    NSDateComponents *components = [self.calendar
                                    components:NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay
                                    fromDate:self.minDate];
    
    NSDate *fromDate = [self.calendar dateFromComponents:components];
    
    components = [self.calendar components:(NSCalendarUnitDay | NSCalendarUnitHour | NSCalendarUnitMinute)
                                  fromDate:fromDate
                                    toDate:date
                                   options:0];
    
    NSInteger hour = ([components hour]-self.minDayTime)*2; //+ 24 * (INT16_MAX / 120);
    NSInteger minute = [components minute]/30;
    NSInteger day = [components day];
    
    [self.picker selectRow:day inComponent:0 animated:YES];
    if (hour+minute<0) {
        [self.picker selectRow:0 inComponent:1 animated:YES];// 从10点开始
    }else if (hour+minute>20) {
        [self.picker selectRow:20 inComponent:1 animated:YES];
    }else {
        [self.picker selectRow:hour+minute inComponent:1 animated:YES];// 从10点开始
    }
}

-(void)initDate {
    NSInteger startDayIndex = 0;
    NSInteger startHourIndex = 0;
    NSInteger startMinuteIndex = 0;
    
    if ((self.minDate) && (self.maxDate) && self.showOnlyValidDates) {
        NSDateComponents *components = [self.calendar components:NSCalendarUnitDay
                                                        fromDate:self.minDate
                                                          toDate:self.maxDate
                                                         options:0];
        
        nDays = components.day + 1;
    } else {
        nDays = INT16_MAX;
    }
    NSDate *dateToPresent;
    
    if ([self.minDate compare:[NSDate date]] == NSOrderedDescending) {
        dateToPresent = self.minDate;
    } else if ([self.maxDate compare:[NSDate date]] == NSOrderedAscending) {
        dateToPresent = self.maxDate;
    } else {
        dateToPresent = [NSDate date];
    }
    
    NSDateComponents *todaysComponents = [self.calendar components:NSCalendarUnitDay | NSCalendarUnitHour | NSCalendarUnitMinute
                                                          fromDate:self.minDate
                                                            toDate:dateToPresent
                                                           options:0];
    
    startDayIndex = todaysComponents.day;
    startHourIndex = todaysComponents.hour;
    startMinuteIndex = todaysComponents.minute;
    
    self.date = [NSDate dateWithTimeInterval:startDayIndex*24*60*60+startHourIndex*60*60+startMinuteIndex*60 sinceDate:self.minDate];
}

#pragma mark - UIPickerViewDataSource

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 2;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    if (component == 0) {
        return nDays;
    } else if (component == 1) {
        if (self.timeInterval) {
            return (self.maxDayTime-self.minDayTime)/self.timeInterval;
        }else {
            return (self.maxDayTime-self.minDayTime);
        }
    } else {
        return INT16_MAX;
    }
}

#pragma mark - UIPickerViewDelegate

-(CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component
{
    switch (component) {
        case 0:
            return self.frame.size.width/2;
            break;
        case 1:
            return self.frame.size.width/2;
            break;
        case 2:
            return 60;
            break;
        default:
            return 0;
            break;
    }
}

-(CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component {
    return 35;
}

-(UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view
{
    UILabel *lblDate = [[UILabel alloc] init];
    [lblDate setFont:[UIFont systemFontOfSize:25.0]];
    [lblDate setTextColor:[UIColor blackColor]];
    [lblDate setBackgroundColor:[UIColor clearColor]];
    
    if (component == 0) // Date
    {
        NSDate *aDate = [NSDate dateWithTimeInterval:row*24*60*60 sinceDate:self.minDate];
        
        NSDateComponents *components = [self.calendar components:(NSCalendarUnitEra|NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay) fromDate:[NSDate date]];
        NSDate *today = [self.calendar dateFromComponents:components];
        components = [self.calendar components:(NSCalendarUnitEra|NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay) fromDate:aDate];
        NSDate *otherDate = [self.calendar dateFromComponents:components];
        
        if ([self isSameDay:today date2:otherDate]) {
            [lblDate setText:@"今天"];
        }else if([self isSameDay:[today dateByAddingTimeInterval:24*3600] date2:otherDate]) {
            [lblDate setText:@"明天"];
        } else {
            NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
            formatter.locale = [NSLocale currentLocale];
            formatter.dateFormat = @"MMMd日 E";
            
            [lblDate setText:[formatter stringFromDate:aDate]];
        }
        lblDate.textAlignment = NSTextAlignmentCenter;
    }
    else if (component == 1) // Hour
    {
        float time = self.minDayTime+self.timeInterval*row;
        
        NSInteger day = [pickerView selectedRowInComponent:0];

        if ([self selectedIsTodayByDayRow:day] && // 选中的是今天
            (self.showOnlyValidDates)) {
            NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
            NSDateComponents *components = [gregorian components:NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond fromDate:self.minDate];
            float mintime = components.hour+components.minute/60+0.5;
            if (mintime>time) {
                lblDate.hidden = YES;
            }
        }else {
//            lblDate.backgroundColor = [UIColor clearColor];
        }
        [lblDate setText:[NSString stringWithFormat:@"%@-%@", [self timeStrFromFloat:time], [self timeStrFromFloat:time+self.timeInterval]]]; // 02d = pad with leading zeros to 2 digits
//        int max = (int)[self.calendar maximumRangeOfUnit:NSCalendarUnitHour].length;
//        [lblDate setText:[NSString stringWithFormat:@"%02ld:%02ld-%02ld:%02ld",(long)(row % max)/2+10, row%2*30, (long)((row+1) % max)/2+10, (row+1)%2*30]]; // 02d = pad with leading zeros to 2 digits
        lblDate.textAlignment = NSTextAlignmentCenter;
    }
    //    else if (component == 2) // Minutes
    //    {
    //        int max = (int)[self.calendar maximumRangeOfUnit:NSCalendarUnitMinute].length;
    //        [lblDate setText:[NSString stringWithFormat:@"%02ld",(row % max)]];
    //        lblDate.textAlignment = NSTextAlignmentLeft;
    //    }
    return lblDate;
}

-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    if (component == 0) {
        [pickerView reloadComponent:1];
    }
    NSInteger daysFromStart;
    NSDate *chosenDate;
    daysFromStart = [pickerView selectedRowInComponent:0];
    chosenDate = [NSDate dateWithTimeInterval:daysFromStart*24*60*60 sinceDate:self.minDate];
    //    NSInteger hour = [pickerView selectedRowInComponent:1]+10;
    //    NSInteger minute = [pickerView selectedRowInComponent:2];
    // Build date out of the components we got
    NSDateComponents *components = [self.calendar components:(NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay) fromDate:chosenDate];
    
    components.hour = [self getHourForHalfHour];
    components.minute = [self getMinitesForHalfHour];
    
    self.date = [self.calendar dateFromComponents:components];
    
    if ([self.date compare:self.minDate] == NSOrderedAscending) {
        [self showDateOnPicker:self.minDate];
    } else if ([self.date compare:self.maxDate] == NSOrderedDescending) {
        [self showDateOnPicker:self.maxDate];
    }
    
    if ((self.delegate) && ([self.delegate respondsToSelector:@selector(dateChanged:)])) {
        [self.delegate dateChanged:self];
    }
}

#pragma mark - other

- (NSInteger)getHourForHalfHour {
    return [self.picker selectedRowInComponent:1]/2+self.minDayTime/1;
    //    NSInteger minite = [self.picker selectedRowInComponent:1]%2*30;
}

- (NSInteger)getMinitesForHalfHour {
    //    return [self.picker selectedRowInComponent:1]/2+10;
    return [self.picker selectedRowInComponent:1]%2*30;
}

- (BOOL)isSameDay:(NSDate*)date1 date2:(NSDate*)date2 {
    NSCalendar* calendar = [NSCalendar currentCalendar];
    
    unsigned unitFlags = NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay;
    NSDateComponents* comp1 = [calendar components:unitFlags fromDate:date1];
    NSDateComponents* comp2 = [calendar components:unitFlags fromDate:date2];
    
    return [comp1 day]   == [comp2 day] &&
    [comp1 month] == [comp2 month] &&
    [comp1 year]  == [comp2 year];
}

- (NSString *)timeStrFromFloat:(float)timeF {
    int hour = timeF;
    int minite = (timeF-hour)*60;
    return [NSString stringWithFormat:@"%02d:%02d", hour, minite];
}

// 选中的是今天
- (BOOL)selectedIsTodayByDayRow:(NSInteger)row {
    NSDate *aDate = [NSDate dateWithTimeInterval:row*24*60*60 sinceDate:self.minDate];
    NSDateComponents *components = [self.calendar components:(NSCalendarUnitEra|NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay) fromDate:[NSDate date]];
    NSDate *today = [self.calendar dateFromComponents:components];
    components = [self.calendar components:(NSCalendarUnitEra|NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay) fromDate:aDate];
    NSDate *otherDate = [self.calendar dateFromComponents:components];
    return [self isSameDay:today date2:otherDate];
}

@end
