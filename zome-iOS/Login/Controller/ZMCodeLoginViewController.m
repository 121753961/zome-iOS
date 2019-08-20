//
//  ZMCodeLoginViewController.m
//  zome-iOS
//
//  Created by CFW on 2017/11/27.
//  Copyright © 2017年 KunagBing. All rights reserved.
//

#import "ZMCodeLoginViewController.h"
#import "ZMBuidPhoneViewController.h"
#import "ZMSignUpViewController.h"
#import "ZMForgotPasswordController.h"
#import <CocoaSecurity/CocoaSecurity.h>
#import "ZMHomeViewController.h"
#import "ZMNavigationController.h"


@interface ZMCodeLoginViewController ()<UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UIView *topView;

@property (weak, nonatomic) IBOutlet UITextField *emailTextField;
@property (weak, nonatomic) IBOutlet UITextField *passWordTextField;

@property (weak, nonatomic) IBOutlet UILabel *line_2;
@property (weak, nonatomic) IBOutlet UILabel *line_1;
@property (weak, nonatomic) IBOutlet UIButton *signinBtn;

@end

@implementation ZMCodeLoginViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    self.topView.backgroundColor = [UIColor navigationbarColor];
    
    [self setNavView];
    
    // 如果产品需要当键盘弹起时，点击背景收起键盘
    [IQKeyboardManager sharedManager].shouldResignOnTouchOutside = YES;
    
    [self setUI];
    
//    self.navigationController.interactivePopGestureRecognizer.delegate = nil;
}

-(void)setNavView{
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"back"] style:UIBarButtonItemStyleDone target:self action:@selector(backAction:)];
    self.navigationItem.leftBarButtonItem = backItem;
}

-(void)backAction:(UIButton *)btn{
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)signinActiion:(id)sender {
    if (![self verificationParam]) {
        return;
    }
    
    NSString *email = self.emailTextField.text;
    CocoaSecurityResult *csResult = [CocoaSecurity md5:self.passWordTextField.text];
    NSString *passWord = csResult.hexLower;
    NSDictionary *params = @{
                             @"loginaName":email,
                             @"password":passWord
                             };
    ZMLog(@"%@",params);
    [ZMProgressHUD show];
    [ZMHttpTool postWithPath:kApi_userLogin params:params success:^(NSDictionary *result) {
        ZMLog(@"%@",result);
        NSInteger status = [result[@"status"] integerValue];
        NSString *message = result[@"message"];
        [ZMProgressHUD dismiss];
        if(status == 0){
            ZMUserInfo *userInfo = [ZMUserInfo mj_objectWithKeyValues:result[@"data"]];
            [[ZMAppInfomationSingleton sharedInstance] setUserDefault:userInfo];
            [ZMProgressHUD showSuccessWithStatus:NSLocalizedString(@"LOGIN_SUCCESS", nil)];
//            [self.navigationController popToRootViewControllerAnimated:YES];
            [self tabRootController];
        }else{
            [ZMProgressHUD showErrorWithStatus:message];
        }
    } failure:^(NSError *error) {
        [ZMProgressHUD dismiss];
        ZMLog(@"%@",error);
    }];
    
//    [self gotoBuidPhoneVC];
}

-(void)tabRootController{
    self.window = [UIApplication sharedApplication].keyWindow;
    UIStoryboard *styoryBoard = [UIStoryboard storyboardWithName:@"ZMHome" bundle:nil];
    ZMHomeViewController *homeVC = [styoryBoard instantiateViewControllerWithIdentifier:@"HomeVC"];
    ZMNavigationController *navVC = [[ZMNavigationController alloc] initWithRootViewController:homeVC];
    self.window.rootViewController = navVC;
    [self.window makeKeyAndVisible];
}


- (IBAction)signupAction:(id)sender {
    UIStoryboard *styoryBoard = [UIStoryboard storyboardWithName:@"ZMLoginReg" bundle:nil];
    ZMSignUpViewController *signUpView = [styoryBoard instantiateViewControllerWithIdentifier:@"SignupVC"];
    signUpView.isReg = YES;
    [self.navigationController pushViewController:signUpView animated:YES];
}

- (IBAction)helpAction:(id)sender {
    UIStoryboard *styoryBoard = [UIStoryboard storyboardWithName:@"ZMLoginReg" bundle:nil];
    ZMForgotPasswordController *forgotPasswordVC = [styoryBoard instantiateViewControllerWithIdentifier:@"ForgotPasswordVC"];
    [self.navigationController pushViewController:forgotPasswordVC animated:YES];
}

-(void)gotoBuidPhoneVC{
    UIStoryboard *styoryBoard = [UIStoryboard storyboardWithName:@"ZMLoginReg" bundle:nil];
    ZMBuidPhoneViewController *buidPhoneView = [styoryBoard instantiateViewControllerWithIdentifier:@"BuidPhoneVC"];
    [self.navigationController pushViewController:buidPhoneView animated:YES];
}

#pragma mark  textFieldDelegate
//返回一个BOOL值，指明是否允许在按下回车键时结束编辑
-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    //如果允许要调用resignFirstResponder 方法，这回导致结束编辑，而键盘会被收起
    [self removeResignFirstResponder];
    return YES;
}
/**
 * @brief  文本输入框已经开始编辑代理方法
 */
- (void)textFieldDidBeginEditing:(UITextField *)textField{
    [self lineColor:textField color:[UIColor inputLineSelectdColor]];
}

-(void)textFieldDidEndEditing:(UITextField *)textField{
    [self lineColor:textField color:[UIColor inputLineColor]];
    self.signinBtn.enabled = !IsStrEmpty(self.emailTextField.text) && !IsStrEmpty(self.passWordTextField.text);
}

-(void)lineColor:(UITextField *)textField color:(UIColor *)color{
    NSInteger tag = textField.tag;
    switch (tag) {
        case 1:
            self.line_1.backgroundColor = color;
            break;
        case 2:
            self.line_2.backgroundColor = color;
            break;
            
        default:
            break;
    }
}



-(void)removeResignFirstResponder{
    [self.emailTextField resignFirstResponder];
    [self.passWordTextField resignFirstResponder];
    
}

-(void)setUI{
    [self.passWordTextField setValue:[UIColor lightGrayColor]
                  forKeyPath:@"_placeholderLabel.textColor"];
    self.passWordTextField.delegate = self;
    
    [self.emailTextField setValue:[UIColor lightGrayColor] forKeyPath:@"_placeholderLabel.textColor"];
    self.emailTextField.delegate = self;
}

-(BOOL)verificationParam{
    if(IsStrEmpty(self.emailTextField.text)){
        [ZMProgressHUD showErrorWithStatus:NSLocalizedString(@"LoginaNameCan'tBeEmpty", nil)];
        return NO;
    }
    
    if(IsStrEmpty(self.passWordTextField.text)){
        [ZMProgressHUD showErrorWithStatus:NSLocalizedString(@"PasswordCan'tBeEmpty", nil)];
        return NO;
    }
    return YES;
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
