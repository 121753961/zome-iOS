//
//  ZMPaymentDetailsController.m
//  zome-iOS
//
//  Created by CFW on 2017/12/16.
//  Copyright © 2017年 KunagBing. All rights reserved.
//

#import "ZMPaymentDetailsController.h"
#import "ZMEditCardController.h"
#import "ZMPaymentCardModel.h"
#import "ZMStrpePayTool.h"
#import "LXAlertView.h"

@interface ZMPaymentDetailsController ()

@end

@implementation ZMPaymentDetailsController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor navigationbarColor];
    
    if (self.cardModel) {
        [self setupUI];
    }
}

-(void)setupUI{
    _cardNumberLabel.text = [NSString stringWithFormat:@"**** **** **** %@",self.cardModel.lastFour?self.cardModel.lastFour:@""];
    
    _dateLabel.text = [NSString stringWithFormat:@"%@/%@",self.cardModel.expMonth,self.cardModel.expYear];
}

- (IBAction)backAction:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)editAction:(id)sender {
    UIStoryboard *styoryBoard = [UIStoryboard storyboardWithName:@"ZMPayment" bundle:nil];
    ZMEditCardController *editCardVC = [styoryBoard instantiateViewControllerWithIdentifier:@"EditCard"];
    editCardVC.titleStr = @"Edit Card";
    editCardVC.cardModel = self.cardModel;
    [self.navigationController pushViewController:editCardVC animated:YES];
}

- (IBAction)delAction:(id)sender {
    BJWeakSelf
    LXAlertView *alert = [[LXAlertView alloc] initWithTitle:@"Prompt" message:@"Delete Card" cancelBtnTitle:@"Cancel" otherBtnTitle:@"Delete" clickIndexBlock:^(NSInteger clickIndex) {
        NSLog(@"点击index====%ld",clickIndex);
        if (clickIndex == 1) {
            [weakSelf setUserDefaultCard:weakSelf.cardModel.Id];
        }
    }];
    [alert showLXAlertView];
}

-(void)setUserDefaultCard:(NSString *)cardId{
    [ZMProgressHUD show];
    BJWeakSelf
    [ZMStrpePayTool setStripeDefaultCard:cardId Success:^(ZMCommonResult *resultModel) {
        [ZMProgressHUD dismiss];
        if (resultModel.status == 0) {
            [ZMProgressHUD showSuccessWithStatus:resultModel.message];
            [weakSelf.navigationController popViewControllerAnimated:YES];
        }else{
            [ZMProgressHUD showErrorWithStatus:resultModel.message];
        }
    } failure:^(NSError *error) {
        [ZMProgressHUD dismiss];
    }];
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
