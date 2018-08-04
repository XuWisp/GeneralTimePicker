//
//  ViewController.m
//  GeneralTimePicker
//
//  Created by xush on 2018/8/3.
//  Copyright © 2018年 Xush. All rights reserved.
//

#import "ViewController.h"
#import "DemoMainView.h"

@interface ViewController ()

@property (nonatomic, strong) DemoMainView *mainV;

@end

@implementation ViewController

#pragma mark - life cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"时区选择器";
    [self.view addSubview:self.mainV];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - lazy load

- (DemoMainView *)mainV {
    if (!_mainV) {
        float top = self.navigationController.navigationBar.frame.origin.y+self.navigationController.navigationBar.frame.size.height;
        _mainV = [[DemoMainView alloc] initWithFrame:(CGRectMake(0, top, [UIScreen mainScreen].bounds.size.width, self.view.frame.size.height-top))];
    }
    return _mainV;
}

#pragma mark - action



#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
}

#pragma mark - network


@end
