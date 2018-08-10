//
//  TimeZonePicker.h
//  GeneralTimePicker
//
//  Created by xush on 2018/8/3.
//  Copyright © 2018年 Xush. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol TimeZonePickerDelegate <NSObject>

@optional

-(void)dateChanged:(id)sender;

@end

@interface TimeZonePicker : UIControl

@property (nonatomic, strong) UIPickerView *picker;

@property (nonatomic, strong) id<TimeZonePickerDelegate> delegate;
@property (nonatomic, strong) NSDate *date;
@property (nonatomic, strong) NSDate *minDate;
@property (nonatomic, strong) NSDate *maxDate;
@property (nonatomic, assign) float minDayTime;
@property (nonatomic, assign) float maxDayTime;
@property (nonatomic, assign) float timeInterval;

@property (nonatomic) BOOL showOnlyValidDates;

- (id)initWithFrame:(CGRect)frame maxDate:(NSDate *)maxDate minDate:(NSDate *)minDate showValidDatesOnly:(BOOL)showValidDatesOnly;
-(void)showDateOnPicker:(NSDate *)date;

@end
