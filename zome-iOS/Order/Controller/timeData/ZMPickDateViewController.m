//
//  ZMPickDateViewController.m
//  zome-iOS
//
//  Created by CFW on 2017/12/9.
//  Copyright © 2017年 KunagBing. All rights reserved.
//

#import "ZMPickDateViewController.h"
#import "NSDate+ZM.h"

@interface ZMPickDateViewController ()<FSCalendarDelegate>

@end

@implementation ZMPickDateViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
//    self.view.backgroundColor = [UIColor colorWithHex:0x228EE2];
    FSCalendar *calendar = [[FSCalendar alloc] init];
    calendar.dataSource = self;
    calendar.delegate = self;
//    calendar.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:calendar];
    self.calendar = calendar;
    [self.calendar mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left);
        make.right.equalTo(self.view.mas_right);
        make.top.equalTo(self.view.mas_top);
        make.bottom.equalTo(self.view.mas_bottom);
    }];
    
    self.calendar.placeholderType = FSCalendarPlaceholderTypeNone;
    self.calendar.appearance.headerTitleColor = [UIColor whiteColor];
    self.calendar.appearance.weekdayTextColor = [UIColor whiteColor];
    self.calendar.appearance.titleDefaultColor = [UIColor whiteColor];
    
    // 今天
    self.calendar.appearance.todayColor = [UIColor whiteColor];
    self.calendar.appearance.titleTodayColor = [UIColor blueColor];
    
    // 选中
    self.calendar.appearance.selectionColor = kColor(255, 51, 102);
//    self.calendar.appearance.borderSelectionColor = kColor(255, 51, 102);
    
//    self.calendar.appearance.todayColor = kColor(255, 51, 102);
    
}

//-(NSDate *)minimumDateForCalendar:(FSCalendar *)calendar{
//    //[calendar tomorrowOfDate:[NSDate date]];
//}


#pragma mark FSCalendarDelegate
- (void)calendar:(FSCalendar *)calendar didSelectDate:(NSDate *)date {
    //    NSLog(@"did select date %@",[calendar stringFromDate:date format:@"yyyy/MM/dd"]);
    NSString *dateStr = [NSDate stringWithYMD:date];
    if ([_delegate respondsToSelector:@selector(pickDateView:didSelectDate:timeStr:)]) {
        [_delegate pickDateView:self didSelectDate:date timeStr:dateStr];
    }
    
}

//-(NSDate *)minimumDateForCalendar:(FSCalendar *)calendar {
//    return [calendar tomorrowOfDate:[NSDate date]];
//
//}
-(NSDate *)minimumDateForCalendar:(FSCalendar *)calendar{
    return [NSDate date];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
