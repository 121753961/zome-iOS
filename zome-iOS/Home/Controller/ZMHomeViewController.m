//
//  ZMHomeViewController.m
//  zome-iOS
//
//  Created by CFW on 2017/12/4.
//  Copyright © 2017年 KunagBing. All rights reserved.
//

#import "ZMHomeViewController.h"
#import "ZMLoginViewController.h"
#import "ZMUtilityTools.h"
#import "NSString+ZMUtil.h"
#import "ZMMapsViewController.h"
#import "ZMTimeTodayViewController.h"
#import "ZMHomeMenuViewController.h"
#import "ZMVehicleInfoViewController.h"
#import "ZMDriveProfileModel.h"
#import "ZMDriverCarinfoModel.h"

#import "ZMSelectRoleViewController.h"
#import "NSDate+ZM.h"
#import "ZMCarTool.h"
#import "ZMLocation.h"

@interface ZMHomeViewController ()

@property(nonatomic, strong) ZMHomeMenuViewController *menu;

@property (nonatomic, strong) ZMDriveProfileModel *driverProfile;

@property (nonatomic, strong) ZMDriverCarinfoModel *driverCarInfo;

@end

@implementation ZMHomeViewController

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = YES;
    
    if (![[ZMAppInfomationSingleton sharedInstance] getoginCode]) {
        UIStoryboard *styoryBoard = [UIStoryboard storyboardWithName:@"ZMLoginReg" bundle:nil];
        ZMLoginViewController *loginView = [styoryBoard instantiateViewControllerWithIdentifier:@"LoginVC"];
        [self.navigationController pushViewController:loginView animated:YES];
    }else{
        [self getDriverProfile];
    }
}

-(void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    self.navigationController.navigationBarHidden = NO;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSString *getDefaultProfileId = [[ZMAppInfomationSingleton sharedInstance] getDefaultProfileId];
    NSString *token = [[ZMAppInfomationSingleton sharedInstance] getAccessToken];
    
    NSString *userid = [[ZMAppInfomationSingleton sharedInstance] getUserId];
    ZMLog(@"getDefaultProfileId:%@",getDefaultProfileId);
    ZMLog(@"userid:%@",userid);
    ZMLog(@"token:%@",token);
//    NSString *dateStr = [[NSDate date] stringWithISOFormat];
//
//    NSDate *date = [NSDate dateWithISOFormatString:dateStr];
//
//    ZMLog(@"%@",date);
    
//    [self getDriverCarinfo];
    
    
    

}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
//    UIStoryboard *styoryBoard = [UIStoryboard storyboardWithName:@"ZMLoginReg" bundle:nil];
//    ZMLoginViewController *loginView = [styoryBoard instantiateViewControllerWithIdentifier:@"LoginVC"];
//    [self.navigationController pushViewController:loginView animated:YES];
    
}

- (IBAction)riderBtnAction:(UIButton *)sender {
    if ([ZMLocation isLocationServicesEnabled]) {
        UIStoryboard *styoryBoard = [UIStoryboard storyboardWithName:@"ZMOrder" bundle:nil];
        ZMMapsViewController *mapsView = [styoryBoard instantiateViewControllerWithIdentifier:@"MapsVC"];
        mapsView.goTripType = 1;
        [self.navigationController pushViewController:mapsView animated:YES];
    }else{
        [self alertViewWithMessage];
    }
}


- (IBAction)driverBtnAction:(UIButton *)sender {
    UIStoryboard *styoryBoard = [UIStoryboard storyboardWithName:@"ZMLoginReg" bundle:nil];
    if (self.driverProfile) {
        ZMVehicleInfoViewController *vehicleInfoVC =  [styoryBoard instantiateViewControllerWithIdentifier:@"VehicleInfoVC"];
        vehicleInfoVC.driverCarInfo = self.driverCarInfo;
        [self.navigationController pushViewController:vehicleInfoVC animated:YES];
    }else{
        ZMSelectRoleViewController *vc = [styoryBoard instantiateViewControllerWithIdentifier:@"SelectRoleVC"];
        [self.navigationController pushViewController:vc animated:YES];
    }
}

- (IBAction)openEvent:(id)sender {
//    if (![[ZMAppInfomationSingleton sharedInstance] getoginCode]) {
//        [self gotoLoginVC];
//        return;
//    }else{
//
//    }
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


-(void)getDriverCarinfo{
    BJWeakSelf
    [ZMCarTool getDriverCarInfoSuccess:^(ZMCommonResult *result) {
        NSArray *data = result.data;
        if ([[data lastObject] isKindOfClass:[NSDictionary class]]) {
            weakSelf.driverCarInfo = [ZMDriverCarinfoModel mj_objectWithKeyValues:[data lastObject]];
            
        }
    } failure:^(NSError *error) {
        
    }];
}

-(void)getDriverProfile{
    BJWeakSelf
    [ZMCarTool getDriverProfileSuccess:^(ZMCommonResult *result) {
        if ([result.data isKindOfClass:[NSDictionary class]]) {
            weakSelf.driverProfile = [ZMDriveProfileModel mj_objectWithKeyValues:result.data];
            [weakSelf getDriverCarinfo];
        }
    } failure:^(NSError *error) {
        
    }];
}

-(void)gotoSelectRoleVC{
    UIStoryboard *styoryBoard = [UIStoryboard storyboardWithName:@"ZMLoginReg" bundle:nil];
    ZMSelectRoleViewController *vc = [styoryBoard instantiateViewControllerWithIdentifier:@"SelectRoleVC"];
    [self.navigationController pushViewController:vc animated:YES];
}

-(void)gotoLoginVC{
    UIStoryboard *styoryBoard = [UIStoryboard storyboardWithName:@"ZMLoginReg" bundle:nil];
    ZMLoginViewController *loginView = [styoryBoard instantiateViewControllerWithIdentifier:@"LoginVC"];
    [self.navigationController pushViewController:loginView animated:YES];
}

-(void)isLogin{
    if (![[ZMAppInfomationSingleton sharedInstance] getoginCode]) {
        [self gotoLoginVC];
        return;
    }
}

-(void)alertViewWithMessage {
    // LocationServiceSubMsg Setting
    UIAlertView *alter = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"LocationServiceMsg", nil) message:NSLocalizedString(@"LocationServiceSubMsg", nil) delegate:self cancelButtonTitle:@"No" otherButtonTitles:NSLocalizedString(@"Setting", nil), nil];
    [alter show];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 0){
        
    }
    else{
        //进入系统设置页面，APP本身的权限管理页面
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]];
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
