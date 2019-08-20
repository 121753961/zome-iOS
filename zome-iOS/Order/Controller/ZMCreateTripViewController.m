//
//  ZMCreateTripViewController.m
//  zome-iOS
//
//  Created by CFW on 2017/12/10.
//  Copyright © 2017年 KunagBing. All rights reserved.
//

#import "ZMCreateTripViewController.h"
#import "ZMRideConfirmViewController.h"

@interface ZMCreateTripViewController ()

@end

@implementation ZMCreateTripViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (IBAction)closeBtnAction:(UIButton *)sender {
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (IBAction)tipsTimeAction:(UIButton *)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)confitmAction:(UIButton *)sender {
    UIStoryboard *styoryBoard = [UIStoryboard storyboardWithName:@"ZMOrder" bundle:nil];
    ZMRideConfirmViewController *rideConfirmVC = [styoryBoard instantiateViewControllerWithIdentifier:@"RideConfirmVC"];
    [self.navigationController pushViewController:rideConfirmVC animated:YES];
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
