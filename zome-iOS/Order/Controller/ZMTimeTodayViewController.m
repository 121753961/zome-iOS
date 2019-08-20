//
//  ZMTimeTodayViewController.m
//  zome-iOS
//
//  Created by CFW on 2017/12/9.
//  Copyright © 2017年 KunagBing. All rights reserved.
//

#import "ZMTimeTodayViewController.h"
#import "ZMTodayViewController.h"
#import "ZMTomorrowViewController.h"
#import "ZMPickDateViewController.h"
#import "ZMOrderSeatsViewController.h"
#import "ZJUsefulPickerView.h"
#import "NSDate+ZM.h"
#import "NSDate+Escort.h"

@interface ZMTimeTodayViewController ()<UIScrollViewDelegate,ZMTodayViewDelegate,ZMPickDateViewDelegate>


@property (weak, nonatomic) IBOutlet UIButton *todayBtn;
@property (weak, nonatomic) IBOutlet UIButton *tomorrowBtn;
@property (weak, nonatomic) IBOutlet UIButton *pickDateBtn;
@property (weak, nonatomic) IBOutlet UIButton *currSelectBtn;

@property (weak, nonatomic) IBOutlet UIView *timeDataView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;

@property (nonatomic, strong) UIButton *barBtn;

@property (nonatomic, strong) UITextField *csText;

@property (weak, nonatomic) IBOutlet UILabel *startTimeLable;
@property (weak, nonatomic) IBOutlet UIButton *startTimeBtn;

@property (weak, nonatomic) IBOutlet UILabel *endTimeLable;
@property (weak, nonatomic) IBOutlet UIButton *endTimeBtn;

@property (nonatomic, copy) NSString *requestTimeYMD;


@end

@implementation ZMTimeTodayViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    [self setupChildViewContollers];
    [self setupScrollView];
    // 默认添加子控制器的view
    [self addChildVcView];
    
    if (self.goTripType == 3) {
        self.todayBtn.selected = NO;
        NSDate *startDate = [NSDate dateWithString:self.gotripDetail.requestTimeStartOrig format:@"yyyy-MM-dd HH:mm:ss"];
        self.startTimeLable.text = [NSDate getHourMinString:startDate];
        
        NSDate *endDate = [NSDate dateWithString:self.gotripDetail.requestTimeEndOrig format:@"yyyy-MM-dd HH:mm:ss"];
        self.endTimeLable.text = [NSDate getHourMinString:endDate];
        
        if ([startDate isToday]) {
            [self moveScrollViewWithIndex:0];
            self.requestTimeYMD = [self getRequestTimeYMD:0];
            self.todayBtn.selected = YES;
            self.currSelectBtn = self.todayBtn;
        }else if ([startDate isTomorrow]){
            [self moveScrollViewWithIndex:1];
            self.requestTimeYMD = [self getRequestTimeYMD:1];
            self.tomorrowBtn.selected = YES;
            self.currSelectBtn = self.tomorrowBtn;
        }else{
            [self moveScrollViewWithIndex:2];
            self.pickDateBtn.selected = YES;
            self.currSelectBtn = self.pickDateBtn;
        }
        
    }else{
        self.currSelectBtn = self.todayBtn;
        self.startTimeLable.text = [NSDate getHourMinString:[NSDate date]];
        self.endTimeLable.text = [NSDate getHourMinString:[NSDate date]];
        
        self.requestTimeYMD = [self getRequestTimeYMD:0];
        self.gotripDetail.requestTimeStartOrig = [NSString stringWithFormat:@"%@ %@:00",self.requestTimeYMD,self.startTimeLable.text];
        self.gotripDetail.requestTimeEndOrig = [NSString stringWithFormat:@"%@ %@:00",self.requestTimeYMD,self.endTimeLable.text];
    }
    
    
    
    UIButton *barBtn = [[UIButton alloc] init];
    self.barBtn = barBtn;
    [self.barBtn setImage:[UIImage imageNamed:@"action_bar"] forState:UIControlStateNormal];
    [self.barBtn addTarget:self action:@selector(barBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.barBtn];
    [self.barBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view.mas_centerX);
        make.bottom.equalTo(self.view.mas_bottom).offset(-20);
        make.width.equalTo(@(55));
        make.height.equalTo(@(55));
    }];
    
}

- (IBAction)tabBtnAction:(UIButton *)sender {
    if (sender == self.currSelectBtn) {
        return;
    }
    self.currSelectBtn.selected = !self.currSelectBtn.selected;
    sender.selected = YES;
    self.currSelectBtn = sender;
    
    NSUInteger index = sender.tag - 10;
    // 让UIScrollView滚动到对应位置
    CGPoint offset = self.scrollView.contentOffset;
    offset.x = index * self.scrollView.frame.size.width;
    [self.scrollView setContentOffset:offset animated:YES];
    
    self.requestTimeYMD = [self getRequestTimeYMD:index];
}


- (IBAction)closeAction:(id)sender {
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (IBAction)backAction:(id)sender {
    self.gotripDetail.requestTimeStartOrig = [NSString stringWithFormat:@"%@ %@:00",self.requestTimeYMD,self.startTimeLable.text];
    self.gotripDetail.requestTimeEndOrig = [NSString stringWithFormat:@"%@ %@:00",self.requestTimeYMD,self.endTimeLable.text];
    if (self.goTripType == 3) {
        if ([_delegate respondsToSelector:@selector(timeTodayView:gotripDetail:)]) {
            [_delegate timeTodayView:self gotripDetail:self.gotripDetail];
        }
    }
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)barBtnAction:(UIButton *)btn{
    self.gotripDetail.requestTimeStartOrig = [NSString stringWithFormat:@"%@ %@:00",self.requestTimeYMD,self.startTimeLable.text];
    self.gotripDetail.requestTimeEndOrig = [NSString stringWithFormat:@"%@ %@:00",self.requestTimeYMD,self.endTimeLable.text];
    
    if (self.goTripType == 3) {
        [self backAction:btn];
    }else{
        UIStoryboard *styoryBoard = [UIStoryboard storyboardWithName:@"ZMOrder" bundle:nil];
        ZMOrderSeatsViewController *orderSeatsVC = [styoryBoard instantiateViewControllerWithIdentifier:@"OrderSeatsVC"];
        orderSeatsVC.gotripDetail = self.gotripDetail;
        orderSeatsVC.orderTripReqParams = self.orderTripReqParams;
        orderSeatsVC.goTripType = self.goTripType;
        [self.navigationController pushViewController:orderSeatsVC animated:YES];
    }
}

-(void)setupChildViewContollers{
    ZMTodayViewController *todayVC = [[ZMTodayViewController alloc] init];
    todayVC.timeType = 1;
    todayVC.delegate = self;
    [self addChildViewController:todayVC];
    
    ZMTodayViewController *tomorrowVC = [[ZMTodayViewController alloc] init];
    tomorrowVC.timeType = 2;
    tomorrowVC.delegate = self;
    [self addChildViewController:tomorrowVC];
    
    ZMPickDateViewController *pickDateVC = [[ZMPickDateViewController alloc] init];
    pickDateVC.delegate = self;
    [self addChildViewController:pickDateVC];
}

-(void)setupScrollView{
    // 不允许自动调整scrollView的内边距
    self.automaticallyAdjustsScrollViewInsets = NO;
    UIScrollView *scrollView = [[UIScrollView alloc] init];
    scrollView.backgroundColor = [UIColor clearColor];
    scrollView.frame = self.timeDataView.bounds;
    scrollView.pagingEnabled = YES;
    scrollView.scrollEnabled = NO;
    scrollView.showsHorizontalScrollIndicator = NO;
    scrollView.showsVerticalScrollIndicator = NO;
    scrollView.delegate = self;
    // 添加所有子控制器的view到scrollView中
    scrollView.contentSize = CGSizeMake(3 * scrollView.frame.size.width, 0);
    [self.timeDataView addSubview:scrollView];
    self.scrollView = scrollView;
}

-(void)addChildVcView{
    NSUInteger index = self.scrollView.contentOffset.x / self.scrollView.frame.size.width;
    UIViewController *childVC = self.childViewControllers[index];
    if ([childVC isViewLoaded]) {
        return;
    }
    childVC.view.frame = self.scrollView.bounds;
    [self.scrollView addSubview:childVC.view];
}



#pragma mark ZMTodayViewController Delegate
-(void)todayView:(ZMTodayViewController *)vc leftBtnAction:(UIButton *)btn{
    self.currSelectBtn.selected = !self.currSelectBtn.selected;
    if (btn.tag - 10 == 1) {
        self.pickDateBtn.selected = YES;
        self.currSelectBtn = self.pickDateBtn;
        [self moveScrollViewWithIndex:2];
    }else if (btn.tag - 10 == 3){
        self.todayBtn.selected = YES;
        self.currSelectBtn = self.todayBtn;
        [self moveScrollViewWithIndex:0];
    }
}

-(void)todayView:(ZMTodayViewController *)vc rigthBtnAction:(UIButton *)btn{
    self.currSelectBtn.selected = !self.currSelectBtn.selected;
    if (btn.tag - 10 == 4) {
        self.pickDateBtn.selected = YES;
        self.currSelectBtn = self.pickDateBtn;
        [self moveScrollViewWithIndex:2];
    }else if (btn.tag - 10 == 2){
        self.tomorrowBtn.selected = YES;
        self.currSelectBtn = self.tomorrowBtn;
        [self moveScrollViewWithIndex:1];
    }
}

-(void)moveScrollViewWithIndex:(NSInteger)index{
    // 让UIScrollView滚动到对应位置
    CGPoint offset = self.scrollView.contentOffset;
    offset.x = index * self.scrollView.frame.size.width;
    [self.scrollView setContentOffset:offset animated:YES];
}



- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView
{
    [self addChildVcView];
}

/**
 * 在scrollView滚动动画结束时, 就会调用这个方法
 * 前提: 人为拖拽scrollView产生的滚动动画
 */
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    [self addChildVcView];
}

- (IBAction)startTimeBtnAction:(id)sender {
    ZJDatePickerStyle *style = [ZJDatePickerStyle new];
    style.datePickerMode = UIDatePickerModeTime;
    style.minimumDate = [NSDate date];
    [ZJUsefulPickerView showDatePickerWithToolBarText:@"" withStyle:style withCancelHandler:^{
        NSLog(@"quxiaole -----");
    } withDoneHandler:^(NSDate *selectedDate) {
        NSLog(@"%@---", selectedDate);
        self.startTimeLable.text = [NSDate getHourMinString:selectedDate];
        NSString *ymd = @"";
        switch (self.currSelectBtn.tag - 10) {
            case 0:
                ymd = [self getRequestTimeYMD:0];
                break;
            case 1:
                ymd = [self getRequestTimeYMD:1];
                break;
                
            default:
                break;
        }
        self.requestTimeYMD = ymd;
        self.gotripDetail.requestTimeStartOrig = [NSString stringWithFormat:@"%@ %@:00",self.requestTimeYMD,self.startTimeLable.text];
        
    }];
}

- (IBAction)endTimeBtnAction:(id)sender {
    ZJDatePickerStyle *style = [ZJDatePickerStyle new];
    style.datePickerMode = UIDatePickerModeTime;
    [ZJUsefulPickerView showDatePickerWithToolBarText:@"" withStyle:style withCancelHandler:^{
        NSLog(@"quxiaole -----");
    } withDoneHandler:^(NSDate *selectedDate) {
        NSLog(@"%@---", selectedDate);
        self.endTimeLable.text = [NSDate getHourMinString:selectedDate];
        NSString *ymd = @"";
        switch (self.currSelectBtn.tag - 10) {
            case 0:
                ymd = [self getRequestTimeYMD:0];
                break;
            case 1:
                ymd = [self getRequestTimeYMD:1];
                break;
            case 2:
                ymd = [self getRequestTimeYMD:0];
                break;
            default:
                break;
        }
        self.requestTimeYMD = ymd;
        self.gotripDetail.requestTimeEndOrig = [NSString stringWithFormat:@"%@ %@:00",self.requestTimeYMD,self.endTimeLable.text];
    }];
}


-(NSString *)getRequestTimeYMD:(NSInteger)day{
    NSDate *aDate = [NSDate date];
    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDateComponents *components = [gregorian components:NSCalendarUnitWeekday | NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay fromDate:aDate];
    [components setDay:([components day] + day)];
    
    NSDate *beginningOfWeek = [gregorian dateFromComponents:components];
    static NSDateFormatter *formatter = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        formatter = [[NSDateFormatter alloc] init];
//        formatter.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US_POSIX"];
        formatter.dateFormat = @"yyyy-MM-dd";
    });
    return [formatter stringFromDate:beginningOfWeek];
}

#pragma  mark ZMPickDateViewDelegate
-(void)pickDateView:(ZMPickDateViewController *)VC didSelectDate:(NSDate *)date timeStr:(NSString *)time{
    self.requestTimeYMD = time;
}



-(UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleLightContent;
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
