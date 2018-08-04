//
//  DemoMainView.h
//  GeneralTimePicker
//
//  Created by xush on 2018/8/3.
//  Copyright © 2018年 Xush. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "TimeZonePicker.h"

@interface DemoMainView : UIView

@property (nonatomic, strong) UILabel *dateLab;
@property (nonatomic, strong) TimeZonePicker *timeZonePiker;
@property (nonatomic, strong) UITableView *tableV;

@property (nonatomic, copy) NSArray *cellDataArr;
@property (nonatomic, copy) NSArray *cellDetailArr1;
@property (nonatomic, copy) NSArray *cellDetailArr2;

@end
