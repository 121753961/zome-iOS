//
//  ZMOrderConfirmViewController.m
//  zome-iOS
//
//  Created by CFW on 2017/12/10.
//  Copyright © 2017年 KunagBing. All rights reserved.
//

#import "ZMOrderConfirmViewController.h"
#import "ZMOrderConfirmCell.h"
#import "ZMCreateTripViewController.h"
#import "ZMTripTool.h"

#import "ZMOrderSeatsViewController.h"
#import "ZMTimeTodayViewController.h"
#import "ZMMapsViewController.h"

@interface ZMOrderConfirmViewController ()
<
    UITableViewDelegate,
    UITableViewDataSource,
    ZMOrderConfirmCellDelegate,
    ZMOrderSeatsViewDelegate,
    ZMTimeTodayViewDelegate,
    ZMMapsViewDelegate
>
@property (weak, nonatomic) IBOutlet UITableView *myTableView;

@property (nonatomic, assign) NSInteger modifyState;

@end

@implementation ZMOrderConfirmViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupMyTableView];
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
//    ZMLog(@"%@",self.orderTripReqParams);
//    if(self.orderTripReqParams.hasReturn){
//
//    }
    return [self.orderTripReqParams.hasReturn isEqualToString:@"Y"] ? 2 : 1;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    ZMOrderConfirmCell *cell = [ZMOrderConfirmCell cellWithTableView:tableView];
    cell.delegate = self;
    if(indexPath.row == 0){
        cell.tripDetailModel = self.orderTripReqParams.goTripDetailVO;
        cell.hasReturn = false;
    }else{
        cell.tripDetailModel = self.orderTripReqParams.returnTripDetailVO;
        cell.hasReturn = true;
    }
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 150;
}

-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    return [[UIView alloc] init];
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            
        }else if (indexPath.row == 1){
            
        }else if (indexPath.row == 2){
            
        }
    }
}






- (IBAction)confirmAction:(UIButton *)sender {
    [self postTripReq];
//    UIStoryboard *styoryBoard = [UIStoryboard storyboardWithName:@"ZMOrder" bundle:nil];
//    ZMCreateTripViewController *createTripVC = [styoryBoard instantiateViewControllerWithIdentifier:@"CreateTripVC"];
//
//    [self.navigationController pushViewController:createTripVC animated:YES];
    
}

-(void)postTripReq{
    NSDictionary *paramsDic = [self.orderTripReqParams mj_keyValues];
    ZMLog(@"%@",paramsDic);
    [ZMTripTool postTripReqWithParams:paramsDic success:^(ZMCommonResult *result) {
        ZMLog(@"%@",result);
    } failure:^(NSError *error) {

    }];
}


#pragma mark ZMOrderConfirmCellDelegate
// 人数
-(void)orderConfirmCell:(ZMOrderConfirmCell *)cell modifySeat:(ZMOrderGotripDetail *)model{
    UIStoryboard *styoryBoard = [UIStoryboard storyboardWithName:@"ZMOrder" bundle:nil];
    ZMOrderSeatsViewController *orderSeatsVC = [styoryBoard instantiateViewControllerWithIdentifier:@"OrderSeatsVC"];
    orderSeatsVC.orderTripReqParams = self.orderTripReqParams;
    if (cell.hasReturn) {
        self.modifyState = 1;
        orderSeatsVC.gotripDetail = self.orderTripReqParams.returnTripDetailVO;
    }else{
        self.modifyState = 2;
        orderSeatsVC.gotripDetail = self.orderTripReqParams.goTripDetailVO;
    }
    orderSeatsVC.delegate = self;
    orderSeatsVC.goTripType = 3;
    [self.navigationController pushViewController:orderSeatsVC animated:YES];
}

// 时间
-(void)orderConfirmCell:(ZMOrderConfirmCell *)cell modifyTime:(ZMOrderGotripDetail *)model{
    UIStoryboard *styoryBoard = [UIStoryboard storyboardWithName:@"ZMOrder" bundle:nil];
    ZMTimeTodayViewController *timeTodayVC =  [styoryBoard instantiateViewControllerWithIdentifier:@"TimeTodayVC"];
    if (cell.hasReturn) {
        self.modifyState = 1;
        timeTodayVC.gotripDetail = self.orderTripReqParams.returnTripDetailVO;
    }else{
        self.modifyState = 2;
        timeTodayVC.gotripDetail = self.orderTripReqParams.goTripDetailVO;
    };
    timeTodayVC.orderTripReqParams = self.orderTripReqParams;
    timeTodayVC.goTripType = 3;
    timeTodayVC.delegate = self;
    [self.navigationController pushViewController:timeTodayVC animated:YES];
}

// 地址
-(void)orderConfirmCell:(ZMOrderConfirmCell *)cell modifyAddess:(ZMOrderGotripDetail *)model{
    UIStoryboard *styoryBoard = [UIStoryboard storyboardWithName:@"ZMOrder" bundle:nil];
    ZMMapsViewController *mapsView = [styoryBoard instantiateViewControllerWithIdentifier:@"MapsVC"];
    if (cell.hasReturn) {
        self.modifyState = 1;
        mapsView.gotripDetail = self.orderTripReqParams.returnTripDetailVO;
    }else{
        self.modifyState = 2;
        mapsView.gotripDetail = self.orderTripReqParams.goTripDetailVO;
    }
    mapsView.orderTripReqParams = self.orderTripReqParams;
    mapsView.goTripType = 3;
    mapsView.delegate = self;
    [self.navigationController pushViewController:mapsView animated:YES];
}

#pragma mark ZMOrderSeatsViewDelegate
-(void)orderSeatsView:(ZMOrderSeatsViewController *)vc gotripDetail:(ZMOrderGotripDetail *)detail{
    ZMLog(@"%@",detail);
    if (self.modifyState == 1) {
        self.orderTripReqParams.returnTripDetailVO = detail;
    }else if (self.modifyState == 2){
        self.orderTripReqParams.goTripDetailVO = detail;
    }
    [self.myTableView reloadData];
}

#pragma mark ZMTimeTodayViewDelegate
-(void)timeTodayView:(ZMTimeTodayViewController *)vc gotripDetail:(ZMOrderGotripDetail *)detail{
    if (self.modifyState == 1) {
        self.orderTripReqParams.returnTripDetailVO = detail;
    }else if (self.modifyState == 2){
        self.orderTripReqParams.goTripDetailVO = detail;
    }
    [self.myTableView reloadData];
}

#pragma mark ZMMapsViewDelegate
-(void)mapsView:(ZMMapsViewController *)vc gotripDetail:(ZMOrderGotripDetail *)detail{
    if (self.modifyState == 1) {
        self.orderTripReqParams.returnTripDetailVO = detail;
    }else if (self.modifyState == 2){
        self.orderTripReqParams.goTripDetailVO = detail;
    }
    [self.myTableView reloadData];
}


- (IBAction)backAction:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)closeAction:(id)sender {
    [self.navigationController popToRootViewControllerAnimated:YES];
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
