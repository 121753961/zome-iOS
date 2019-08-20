//
//  ZMWalletViewController.m
//  zome-iOS
//
//  Created by CFW on 2017/12/17.
//  Copyright © 2017年 KunagBing. All rights reserved.
//

#import "ZMWalletViewController.h"
#import "ZMHomeMenuViewController.h"
#import "ZMWallerListController.h"

@interface ZMWalletViewController ()

@property(nonatomic, strong) ZMHomeMenuViewController *menu;

@end

@implementation ZMWalletViewController

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [UIColor whiteColor];
    self.navigationController.navigationBarHidden = YES;
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = YES;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
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

- (IBAction)closeBtnAction:(id)sender {
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (IBAction)gotoBtnAction:(id)sender {
    UIStoryboard *styoryBoard = [UIStoryboard storyboardWithName:@"ZMPayment" bundle:nil];
    ZMWallerListController *wallerListVC = [styoryBoard instantiateViewControllerWithIdentifier:@"WallerListVC"];
    [self.navigationController pushViewController:wallerListVC animated:YES];
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
