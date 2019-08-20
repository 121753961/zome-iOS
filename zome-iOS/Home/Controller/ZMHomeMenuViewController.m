//
//  ZMHomeMenuViewController.m
//  zome-iOS
//
//  Created by CFW on 2017/12/14.
//  Copyright © 2017年 KunagBing. All rights reserved.
//

#import "ZMHomeMenuViewController.h"
#import "UIViewController+LeftSlide.h"
#import "ZMHomeMenuCell.h"
#import "ZMHomeMenuCell_1.h"
#import "ZMHomeMenuCell_2.h"
#import "ZMDriverProfileController.h"
#import "ZMPayMentListController.h"
#import "ZMWalletViewController.h"
#import "ZMMyTripViewController.h"
#import "LXAlertView.h"
#import "ZMPushTool.h"
#import "ZMLoginViewController.h"
#import "ZMUserInfo.h"
#import "ZMCarTool.h"
#import "ZMDriveProfileModel.h"
#import "ZMLoginViewController.h"
#import "ZMNavigationController.h"

@interface ZMHomeMenuViewController ()

@property (weak, nonatomic) IBOutlet UITableView *mytableView;

@property (nonatomic,strong) NSArray *tableViewItems;

@property (nonatomic, strong) ZMUserInfo *userInfo;

@property (weak, nonatomic) IBOutlet UIImageView *avatarImage;

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;

@property (weak, nonatomic) IBOutlet UILabel *emailLabel;

@property (nonatomic, strong) ZMDriveProfileModel *driverProfile;

@end

@implementation ZMHomeMenuViewController



-(void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    self.navigationController.navigationBarHidden = NO;
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    self.navigationController.navigationBarHidden = NO;
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = YES;
    if (![[ZMAppInfomationSingleton sharedInstance] getoginCode]) {
        UIStoryboard *styoryBoard = [UIStoryboard storyboardWithName:@"ZMLoginReg" bundle:nil];
        ZMLoginViewController *loginView = [styoryBoard instantiateViewControllerWithIdentifier:@"LoginVC"];
        [self.navigationController pushViewController:loginView animated:YES];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _tableViewItems = @[
                        @{@"imageName":@"menu_add",@"itemName":@"Schedule A Ride"},
//                        @{@"imageName":@"menu_email",@"itemName":@"Messages"},
                        @{@"imageName":@"menu_location",@"itemName":@"My Trips"},
                        @{@"imageName":@"menu_payment",@"itemName":@"Payments"},
                        @{@"imageName":@"menu_lists",@"itemName":@"Zome Wallet"},
                        @{@"imageName":@"menu_profile",@"itemName":@"Driver Profile"},
                        @{@"imageName":@"menu_birthday",@"itemName":@"Promotion Code"},
                        ];
    
    
    self.mytableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    // 添加从左划入的功能
    [self initSlideFoundation];
    
    [self getDriverProfile];
    
    
    ZMLog(@"%@",self.userInfo);
}

-(void)setupUI{
    self.userInfo = [[ZMAppInfomationSingleton sharedInstance] getUserDefault];
    self.emailLabel.text = self.userInfo.email;
    self.nameLabel.text = [NSString stringWithFormat:@"%@ %@",self.userInfo.firstName,self.userInfo.lastName];
    if (!IsStrEmpty(self.userInfo.avatar)) {
        NSURL *url = [NSURL URLWithString:self.userInfo.avatar];
        [_avatarImage sd_setImageWithURL:url];
    }
}

-(void)getDriverProfile{
    BJWeakSelf
    [ZMCarTool getDriverProfileSuccess:^(ZMCommonResult *result) {
        if ([result.data isKindOfClass:[NSDictionary class]]) {
            weakSelf.driverProfile = [ZMDriveProfileModel mj_objectWithKeyValues:result.data];
        }
    } failure:^(NSError *error) {
        
    }];
}


#pragma mark -- show or hide
- (void)showFromLeft
{
    [self setupUI];
    [self show];
}

- (IBAction)hideFromLeft:(id)sender {
    [self hide];
}


- (IBAction)logoutAction:(id)sender {
    ZMLog(@"clearAllInformation");
    LXAlertView *alert = [[LXAlertView alloc] initWithTitle:@"Prompt" message:@"Be sure to go out" cancelBtnTitle:@"Cancel" otherBtnTitle:@"Logout" clickIndexBlock:^(NSInteger clickIndex) {
        NSLog(@"点击index====%ld",clickIndex);
        if (clickIndex == 1) {
            [[ZMAppInfomationSingleton sharedInstance] clearAllInformation];
            [self hide];
//            UIStoryboard *styoryBoard = [UIStoryboard storyboardWithName:@"ZMLoginReg" bundle:nil];
//            ZMLoginViewController *loginView = [styoryBoard instantiateViewControllerWithIdentifier:@"LoginVC"];
//            [self.navigationController pushViewController:loginView animated:YES];
            [self tabRootController];
        }
    }];
    [alert showLXAlertView];
    
}

#pragma mark -- TableView Delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _tableViewItems.count;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    return [UIView new];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 60;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    /*
    if (indexPath.row == 1) {
        NSDictionary *dic = self.tableViewItems[indexPath.row];
        static NSString *CellIdentifier = @"ZMHomeMenuCell_1";
        ZMHomeMenuCell_1 *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        cell.title.text = dic[@"itemName"];
        cell.icon.image = [UIImage imageNamed:dic[@"imageName"]];
        return cell;
    }else if (indexPath.row == 5){
        NSDictionary *dic = self.tableViewItems[indexPath.row];
        static NSString *CellIdentifier = @"ZMHomeMenuCell_2";
        ZMHomeMenuCell_2 *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        cell.title.text = dic[@"itemName"];
        cell.icon.image = [UIImage imageNamed:dic[@"imageName"]];
        return cell;
    }else{
        NSDictionary *dic = self.tableViewItems[indexPath.row];
        static NSString *CellIdentifier = @"ZMHomeMenuCell";
        ZMHomeMenuCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (indexPath.row == 0) {
            cell.title.textColor = [UIColor colorWithHex:0xFF3366];
        }
        cell.title.text = dic[@"itemName"];
        cell.icon.image = [UIImage imageNamed:dic[@"imageName"]];
        return cell;
    }*/
    
    NSDictionary *dic = self.tableViewItems[indexPath.row];
    static NSString *CellIdentifier = @"ZMHomeMenuCell";
    ZMHomeMenuCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (indexPath.row == 0) {
        cell.title.textColor = [UIColor colorWithHex:0xFF3366];
    }
    cell.title.text = dic[@"itemName"];
    cell.icon.image = [UIImage imageNamed:dic[@"imageName"]];
    return cell;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [self hide];
    switch (indexPath.row) {
        case 1:
            [self gotoMyTripVC];
            break;
            
        case 2:
            [self gotoPaymentVC];
            break;
            
        case 3:
            [self gotoWalletVC];
            break;
            
        case 4:
            [self gotoDriverProfileVC];
            break;
            
        default:
            break;
    }

}

-(void)gotoDriverProfileVC{
    UIStoryboard *styoryBoard = [UIStoryboard storyboardWithName:@"ZMLoginReg" bundle:nil];
    ZMDriverProfileController *driverProfileVC = [styoryBoard instantiateViewControllerWithIdentifier:@"DriverProfileVC"];
    driverProfileVC.driverProfile = self.driverProfile;
    [self.navigationController pushViewController:driverProfileVC animated:YES];
}

-(void)gotoPaymentVC{
    UIStoryboard *styoryBoard = [UIStoryboard storyboardWithName:@"ZMPayment" bundle:nil];
    ZMPayMentListController *paymentListVC = [styoryBoard instantiateViewControllerWithIdentifier:@"PayMentList"];
    [self.navigationController pushViewController:paymentListVC animated:YES];
}

-(void)gotoWalletVC{
    UIStoryboard *styoryBoard = [UIStoryboard storyboardWithName:@"ZMPayment" bundle:nil];
    ZMWalletViewController *walletVC = [styoryBoard instantiateViewControllerWithIdentifier:@"WalletVC"];
    [self.navigationController pushViewController:walletVC animated:YES];
}

-(void)gotoMyTripVC{
    UIStoryboard *styoryBoard = [UIStoryboard storyboardWithName:@"ZMMyTrip" bundle:nil];
    ZMMyTripViewController *myTripVC = [styoryBoard instantiateViewControllerWithIdentifier:@"MyTripVC"];
    [self.navigationController pushViewController:myTripVC animated:YES];
}


-(void)tabRootController{
    self.window = [UIApplication sharedApplication].keyWindow;
    UIStoryboard *styoryBoard = [UIStoryboard storyboardWithName:@"ZMLoginReg" bundle:nil];
    ZMLoginViewController *loginView = [styoryBoard instantiateViewControllerWithIdentifier:@"LoginVC"];
    ZMNavigationController *navVC = [[ZMNavigationController alloc] initWithRootViewController:loginView];
    self.window.rootViewController = navVC;
    [self.window makeKeyAndVisible];
    
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
