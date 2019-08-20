//
//  ZMForgotPasswordController.m
//  zome-iOS
//
//  Created by CFW on 2017/12/3.
//  Copyright © 2017年 KunagBing. All rights reserved.
//

#import "ZMForgotPasswordController.h"
#import "ZMCommonPromptController.h"
#import "NSString+ZMUtil.h"

@interface ZMForgotPasswordController ()<UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITextField *emailTextField;

@property (weak, nonatomic) IBOutlet UIButton *sendBtn;

@end

@implementation ZMForgotPasswordController

- (void)viewDidLoad {
    [super viewDidLoad];
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"back"] style:UIBarButtonItemStyleDone target:self action:@selector(backAction:)];
    self.navigationItem.leftBarButtonItem = backItem;
    self.navigationItem.title = @"Forgot Password";
    //    self.navigationController.interactivePopGestureRecognizer.delegate = nil;
    
    // Do any additional setup after loading the view.
    self.emailTextField.delegate = self;
}

-(void)textFieldDidEndEditing:(UITextField *)textField{
    self.sendBtn.enabled = !IsStrEmpty(self.emailTextField.text);
}

-(void)backAction:(UIButton *)btn{
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)sendAction:(id)sender {
    if(IsStrEmpty(self.emailTextField.text)){
        [ZMProgressHUD showErrorWithStatus:NSLocalizedString(@"EmailCan'tBeEmpty", nil)];
        return;
    }
    
    if (![NSString validateEmail:self.emailTextField.text]) {
        [ZMProgressHUD showErrorWithStatus:NSLocalizedString(@"IncorrectMailboxFormat", nil)];
        return;
    }
    
    NSDictionary *paramsDic = @{
                                @"email":self.emailTextField.text
                                };
    [ZMHttpTool postWithPath:kApi_userForgotpwd params:paramsDic success:^(NSDictionary *result) {
        ZMLog(@"%@",result);
        NSInteger status = [result[@"status"] integerValue];
        NSString *message = result[@"message"];
        if(status == 0){
            UIStoryboard *styoryBoard = [UIStoryboard storyboardWithName:@"ZMLoginReg" bundle:nil];
            ZMCommonPromptController *commonPromptVC = [styoryBoard instantiateViewControllerWithIdentifier:@"CommonPromptVC"];
            commonPromptVC.email = self.emailTextField.text;
            [self.navigationController pushViewController:commonPromptVC animated:YES];
        }else{
            [ZMProgressHUD showErrorWithStatus:message];
        }
        
        
    } failure:^(NSError *error) {
        ZMLog(@"%@",error);
    }];
    
    
    
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
