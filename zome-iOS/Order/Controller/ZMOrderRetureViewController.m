//
//  ZMOrderRetureViewController.m
//  zome-iOS
//
//  Created by CFW on 2017/12/10.
//  Copyright © 2017年 KunagBing. All rights reserved.
//

#import "ZMOrderRetureViewController.h"
#import "ZMOrderConfirmViewController.h"
#import "ZMTripTool.h"
#import "ZMOrderGotripDetail.h"
#import "ZMMapsViewController.h"

@interface ZMOrderRetureViewController ()

@end

@implementation ZMOrderRetureViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    ZMLog(@"%@",self.orderTripReqParams);
}
- (IBAction)gotoConfirmAction:(UIButton *)sender {
    self.orderTripReqParams.hasReturn = @"N";
    self.orderTripReqParams.userType = @"rider";
//    ZMOrderGotripDetail *returnDetail = [[ZMOrderGotripDetail alloc] init];
//    returnDetail.toAddr = @"";
//    returnDetail.toLatitude = @"";
//    returnDetail.toLongitude = @"";
//    returnDetail.fromAddr = @"";
//    returnDetail.fromLatitude = @"";
//    returnDetail.fromLongitude = @"";
//    returnDetail.requestTimeEndOrig = @"";
//    returnDetail.requestTimeStartOrig = @"";
//    returnDetail.seats = 0;
//    returnDetail.status = 0;
//    returnDetail.tripType = 0;
//
//    self.orderTripReqParams.returnTripDetailVO = returnDetail;
    self.orderTripReqParams.userId = [[ZMAppInfomationSingleton sharedInstance] getUserId];
    [self gotoOrderConfirmVC];
}




-(void)gotoOrderConfirmVC{
    UIStoryboard *styoryBoard = [UIStoryboard storyboardWithName:@"ZMOrder" bundle:nil];
    ZMOrderConfirmViewController *orderConfirmVC = [styoryBoard instantiateViewControllerWithIdentifier:@"OrderConfirmVC"];
    orderConfirmVC.orderTripReqParams = self.orderTripReqParams;
    orderConfirmVC.goTripType = self.goTripType;
    [self.navigationController pushViewController:orderConfirmVC animated:YES];
}

- (IBAction)buttomBtnAction:(id)sender {
    UIStoryboard *styoryBoard = [UIStoryboard storyboardWithName:@"ZMOrder" bundle:nil];
    ZMMapsViewController *mapsView = [styoryBoard instantiateViewControllerWithIdentifier:@"MapsVC"];
    mapsView.goTripType = 2;
    mapsView.tripDetail = self.orderTripReqParams.goTripDetailVO;
    self.orderTripReqParams.hasReturn = @"Y";
    mapsView.orderTripReqParams = self.orderTripReqParams;
    [self.navigationController pushViewController:mapsView animated:YES];
}


- (IBAction)backAction:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)closeBtnAction:(id)sender {
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
