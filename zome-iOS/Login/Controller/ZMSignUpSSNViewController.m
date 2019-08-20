//
//  ZMSignUpSSNViewController.m
//  zome-iOS
//
//  Created by CFW on 2017/11/28.
//  Copyright © 2017年 KunagBing. All rights reserved.
//

#import "ZMSignUpSSNViewController.h"
#import "ZMHttpTool.h"

@interface ZMSignUpSSNViewController ()
@property (weak, nonatomic) IBOutlet UITextField *nnsTextField;

@end

@implementation ZMSignUpSSNViewController

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    self.navigationController.navigationBarHidden = YES;
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = YES;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    //    self.navigationController.interactivePopGestureRecognizer.delegate = nil;
    
    // Do any additional setup after loading the view.
    if (!IsStrEmpty(self.driverProfileParams.ssn)) {
        self.nnsTextField.text = self.driverProfileParams.ssn;
    }
}

- (IBAction)submitAction:(UIButton *)sender {
    if(IsStrEmpty(self.nnsTextField.text)){
        [ZMProgressHUD showErrorWithStatus:NSLocalizedString(@"NnsCan'tBeEmpty", nil)];
        return;
    }
    self.driverProfileParams.ssn = self.nnsTextField.text;
    
    NSDictionary *paramsDic = [self.driverProfileParams mj_keyValues];
    [ZMProgressHUD show];
    [ZMHttpTool postWithPath:kApi_driverProfile params:paramsDic success:^(NSDictionary *result) {
        [ZMProgressHUD dismiss];
        ZMCommonResult *resultModel = [[ZMCommonResult alloc] init];
        resultModel = [ZMCommonResult mj_objectWithKeyValues:result];
        if (resultModel.status == 0) {
            [ZMProgressHUD showSuccessWithStatus:resultModel.message];
            [self.navigationController popToRootViewControllerAnimated:YES];
        }else{
            [ZMProgressHUD showErrorWithStatus:resultModel.message];
        }
    } failure:^(NSError *error) {
        [ZMProgressHUD showErrorWithStatus:NSLocalizedString(@"NetworkError", nil)];
    }];
}

-(void)backAction:(UIButton *)btn{
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)closeAction:(id)sender {
    [self.navigationController popToRootViewControllerAnimated:YES];
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
