//
//  ZMTodayViewController.m
//  zome-iOS
//
//  Created by CFW on 2017/12/9.
//  Copyright © 2017年 KunagBing. All rights reserved.
//

#import "ZMTodayViewController.h"
#import "ZMTimeDayCollectionViewCell.h"
#import "ZMTimeDayViewCell.h"

@interface ZMTodayViewController ()<UICollectionViewDelegate,UICollectionViewDataSource>

@property (weak, nonatomic) IBOutlet UIButton *leftBtn;

@property (weak, nonatomic) IBOutlet UIButton *rightBtn;

@property (strong, nonatomic) UICollectionView *collectionView;

@property (nonatomic, assign) NSInteger selectTime;

@property (nonatomic, strong) NSArray *dates;

@end


@implementation ZMTodayViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor clearColor];
    self.selectTime = 0;
    
    [self setupLeftRigthBtn];
    
    [self setupCollectionView];
    
    // 
    if (self.timeType == 1) {
        [self fillDatesWithCalendarUnit:NSCalendarUnitYear];
    }else if (self.timeType == 2){
        [self fillDatesTomorrowWithCalendarUnit:NSCalendarUnitYear];
    }

    
    [_collectionView reloadData];
}

-(void)setupLeftRigthBtn{
    UIButton *leftBtn = [[UIButton alloc] init];
//    leftBtn.backgroundColor = kRandomColor;
    [self.view addSubview:leftBtn];
    self.leftBtn = leftBtn;
    if (self.timeType == 1) {
        self.leftBtn.tag = 11;
    }else if(self.timeType == 2){
        self.leftBtn.tag = 13;
    }
    
    [self.leftBtn addTarget:self action:@selector(leftAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.leftBtn setImage:[UIImage imageNamed:@"left_btn_icon"] forState:UIControlStateNormal];
    [self.leftBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@(22));
        make.width.equalTo(@(14));
        make.left.equalTo(self.view.mas_left).offset(20);;
        make.centerY.equalTo(self.view.mas_centerY);
    }];
    

    UIButton *rightBtn = [[UIButton alloc] init];
    self.rightBtn = rightBtn;
    if (self.timeType == 1) {
        self.rightBtn.tag = 12;
    }else if(self.timeType == 2){
        self.rightBtn.tag = 14;
    }
    [self.rightBtn setImage:[UIImage imageNamed:@"right_btn_icon"] forState:UIControlStateNormal];
    [self.rightBtn addTarget:self action:@selector(rigthAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.rightBtn];
    [self.rightBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@(22));
        make.width.equalTo(@(14));
        make.right.equalTo(self.view.mas_right).offset(-20);
        make.centerY.equalTo(self.view.mas_centerY);
    }];
    
}

-(void)leftAction:(UIButton *)btn{
    if ([_delegate respondsToSelector:@selector(todayView:leftBtnAction:)]) {
        [_delegate todayView:self leftBtnAction:btn];
    }
}

-(void)rigthAction:(UIButton *)btn{
    if ([_delegate respondsToSelector:@selector(todayView:rigthBtnAction:)]) {
        [_delegate todayView:self rigthBtnAction:btn];
    }
}

-(void)setupCollectionView{
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    [layout setItemSize:CGSizeMake(200, 100)];
    [layout setScrollDirection:UICollectionViewScrollDirectionHorizontal];
    [layout setSectionInset:UIEdgeInsetsMake(0, 15, 0, 15)];
//    [layout setMinimumLineSpacing:15.f];
    
    _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(50, 0, self.view.frame.size.width - 100, self.view.frame.size.height) collectionViewLayout:layout];
//    [UINib nibw];
    [_collectionView registerClass:[ZMTimeDayCollectionViewCell class] forCellWithReuseIdentifier:[ZMTimeDayCollectionViewCell ID]];
    [_collectionView setBackgroundColor:[UIColor clearColor]];
    [_collectionView setShowsHorizontalScrollIndicator:NO];
    [_collectionView setAllowsMultipleSelection:YES];
    _collectionView.pagingEnabled = NO;
    _collectionView.scrollEnabled = NO;
//    self.collectionView.pagingEnabled = YES;
    _collectionView.dataSource = self;
    _collectionView.delegate = self;
    [self.view addSubview:_collectionView];
    [_collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.equalTo(self.leftBtn.mas_right).offset(10);
//        make.right.equalTo(self.rightBtn.mas_left).offset(-10);
        make.width.equalTo(@(200));
        make.centerX.equalTo(self.view.mas_centerX).offset(-10);
        make.top.equalTo(self.view.mas_top);
        make.bottom.equalTo(self.view.mas_bottom);
    }];
}




#pragma mark - UICollectionView Delegate
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.dates.count;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    ZMTimeDayCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:[ZMTimeDayCollectionViewCell ID] forIndexPath:indexPath];
    cell.date = [self.dates objectAtIndex:indexPath.item];
    return cell;
}

- (void)fillDatesWithCalendarUnit:(NSCalendarUnit)unit
{
    NSDate *today = [NSDate date];
    NSCalendar *calendar = [NSCalendar currentCalendar];
    
    NSDate *beginning;
    NSTimeInterval length;
    [calendar rangeOfUnit:unit startDate:&beginning interval:&length forDate:today];
    NSDate *end = [beginning dateByAddingTimeInterval:length-1];
    
    [self fillDatesFromDate:today toDate:end];
}

-(void)fillDatesTomorrowWithCalendarUnit:(NSCalendarUnit)unit{
    NSDate *aDate = [NSDate date];
    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDateComponents *components = [gregorian components:NSCalendarUnitWeekday | NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay fromDate:aDate];
    [components setDay:([components day]+1)];
    
    NSDate *beginningOfWeek = [gregorian dateFromComponents:components];
    
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDate *beginning;
    NSTimeInterval length;
    [calendar rangeOfUnit:unit startDate:&beginning interval:&length forDate:aDate];
    NSDate *end = [beginning dateByAddingTimeInterval:length-1];
    [self fillDatesFromDate:beginningOfWeek toDate:end];
}



- (void)fillDatesFromDate:(NSDate *)fromDate toDate:(NSDate *)toDate
{
    NSAssert([fromDate compare:toDate] == NSOrderedAscending, @"toDate must be after fromDate");
    
    NSMutableArray *dates = [[NSMutableArray alloc] init];
    NSDateComponents *days = [[NSDateComponents alloc] init];
    NSCalendar *calendar = [NSCalendar currentCalendar];
    
    NSInteger dayCount = 0;
    while(YES){
        [days setDay:dayCount++];
        NSDate *date = [calendar dateByAddingComponents:days toDate:fromDate options:0];
        
        if([date compare:toDate] == NSOrderedDescending) break;
        [dates addObject:date];
    }
    
    self.dates = dates;
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
