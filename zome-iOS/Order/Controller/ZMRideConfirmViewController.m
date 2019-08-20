//
//  ZMRideConfirmViewController.m
//  zome-iOS
//
//  Created by CFW on 2017/12/10.
//  Copyright © 2017年 KunagBing. All rights reserved.
//

#import "ZMRideConfirmViewController.h"
#import "ZMOrderConfirmCell.h"
#import "ZMHomeMenuViewController.h"

@interface ZMRideConfirmViewController ()<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic,strong) ZMHomeMenuViewController *menu;

@property (weak, nonatomic) IBOutlet UITableView *myTableView;

@end

@implementation ZMRideConfirmViewController

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    self.navigationController.navigationBarHidden = YES;
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = YES;
}

-(void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    self.navigationController.navigationBarHidden = NO;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupMyTableView];
}

- (IBAction)openEvent:(id)sender {
    if (!self.menu) {
        UIStoryboard *story = [UIStoryboard storyboardWithName:@"ZMHome" bundle:[NSBundle mainBundle]];
        self.menu = [story instantiateViewControllerWithIdentifier:@"HomeMenuVC"];
        
        CGRect frame = self.menu.view.frame;
        frame.origin.x = - CGRectGetWidth(self.view.frame);
        self.menu.view.frame = frame;
        self.menu.navigationController = self.navigationController;
        [[UIApplication sharedApplication].keyWindow addSubview:self.menu.view];
    }
    [self.menu showFromLeft];
}

-(void)setupMyTableView{
    self.myTableView.delegate = self;
    self.myTableView.dataSource = self;
    self.myTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
}

#pragma mark tableView delegage  dataSource
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 2;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    //    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    //    cell.textLabel.text = @"kkkkk";
    ZMOrderConfirmCell *cell = [ZMOrderConfirmCell cellWithTableView:tableView];
    cell.cellType = 2;
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 150;
}

-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    return [[UIView alloc] init];
}

- (IBAction)closeBtnAction:(UIButton *)sender {
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (IBAction)bottomBtnAction:(UIButton *)sender {
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
