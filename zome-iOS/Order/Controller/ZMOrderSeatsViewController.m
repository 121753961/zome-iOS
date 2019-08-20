//
//  ZMOrderSeatsViewController.m
//  zome-iOS
//
//  Created by CFW on 2017/12/10.
//  Copyright © 2017年 KunagBing. All rights reserved.
//

#import "ZMOrderSeatsViewController.h"
#import "ZMOrderRetureViewController.h"
#import "ZMOrderConfirmViewController.h"

@interface ZMOrderSeatsViewController ()

@property (weak, nonatomic) IBOutlet UILabel *seatLabel;

@property (nonatomic, assign) NSInteger seatNum;

@property (weak, nonatomic) IBOutlet UIButton *minusBtn;

@property (weak, nonatomic) IBOutlet UIButton *plusBtn;

@end

@implementation ZMOrderSeatsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    // 修改
    if (self.goTripType == 3) {
        self.seatNum = self.gotripDetail.seats;
        self.gotripDetail.seats = self.gotripDetail.seats;
    }else{
        self.seatNum = 1;
        self.gotripDetail.seats = 1;
    }
    
    self.seatLabel.text = [NSString stringWithFormat:@"%ld",(long)self.seatNum];
    self.minusBtn.enabled = self.seatNum > 1 ? true:false;
    
    ZMLog(@"%@",self.gotripDetail);
    
}
- (IBAction)backAction:(id)sender {
    if (self.goTripType == 3){
        if ([_delegate respondsToSelector:@selector(orderSeatsView:gotripDetail:)]) {
            [_delegate orderSeatsView:self gotripDetail:self.gotripDetail];
        }
    }
    
    [self.navigationController popViewControllerAnimated:YES];
    
}
- (IBAction)closeAction:(id)sender {
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (IBAction)minusAction:(UIButton *)sender {
    if (self.seatNum == 1) {
        sender.enabled = NO;
        return;
    }
    
    self.seatNum --;
    self.gotripDetail.seats = self.seatNum;
    self.seatLabel.text = [NSString stringWithFormat:@"%ld",(long)self.seatNum];
    self.plusBtn.enabled = YES;
}

- (IBAction)plusAction:(UIButton *)sender {
    if (self.seatNum == 4) {
        sender.enabled = NO;
        return;
    }
    self.seatNum ++;
    self.gotripDetail.seats = self.seatNum;
    self.seatLabel.text = [NSString stringWithFormat:@"%ld",(long)self.seatNum];
    self.minusBtn.enabled = YES;
}

- (IBAction)barBtnAction:(id)sender {
    UIStoryboard *styoryBoard = [UIStoryboard storyboardWithName:@"ZMOrder" bundle:nil];
    ZMOrderRetureViewController *orderRetureVC = [styoryBoard instantiateViewControllerWithIdentifier:@"OrderRetureVC"];
    if (!orderRetureVC.orderTripReqParams) {
        orderRetureVC.orderTripReqParams = [[ZMOrderTripReqParams alloc] init];
    }
    if(self.goTripType == 1){
        orderRetureVC.orderTripReqParams.goTripDetailVO = self.gotripDetail;
        orderRetureVC.goTripType = self.goTripType;
        [self.navigationController pushViewController:orderRetureVC animated:YES];
    }else if (self.goTripType == 2){
        UIStoryboard *styoryBoard = [UIStoryboard storyboardWithName:@"ZMOrder" bundle:nil];
        ZMOrderConfirmViewController *orderConfirmVC = [styoryBoard instantiateViewControllerWithIdentifier:@"OrderConfirmVC"];
        orderConfirmVC.orderTripReqParams = self.orderTripReqParams;
        orderConfirmVC.orderTripReqParams.returnTripDetailVO = self.gotripDetail;
        orderConfirmVC.goTripType = self.goTripType;
        [self.navigationController pushViewController:orderConfirmVC animated:YES];
    }else if (self.goTripType == 3){
        if ([_delegate respondsToSelector:@selector(orderSeatsView:gotripDetail:)]) {
            [_delegate orderSeatsView:self gotripDetail:self.gotripDetail];
        }
        [self.navigationController popViewControllerAnimated:YES];
    }
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
