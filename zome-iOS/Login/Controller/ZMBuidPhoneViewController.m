//
//  ZMBuidPhoneViewController.m
//  zome-iOS
//
//  Created by CFW on 2017/11/28.
//  Copyright © 2017年 KunagBing. All rights reserved.
//

#import "ZMBuidPhoneViewController.h"
#import "ZMSelectRoleViewController.h"
#import "ZMCodeLoginViewController.h"
#import "ZMUserInfo.h"


@interface ZMBuidPhoneViewController ()<UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITextField *verificationCodeTextField;
@property (weak, nonatomic) IBOutlet UITextField *phoneTextField;

@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *line_1;
@property (weak, nonatomic) IBOutlet UILabel *line_2;

@property (weak, nonatomic) IBOutlet UIButton *signUpBtn;

@end

@implementation ZMBuidPhoneViewController

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
//    self.navigationController.navigationBarHidden = YES;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setNavView];
    
    self.phoneTextField.delegate = self;
    self.verificationCodeTextField.delegate = self;
}

-(void)setNavView{
    self.navigationItem.title = @"Phone Number";
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"back"] style:UIBarButtonItemStyleDone target:self action:@selector(backAction:)];
    self.navigationItem.leftBarButtonItem = backItem;
}

-(void)backAction:(UIButton *)btn{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark ---- UserRegister
-(void)postUserRegister:(ZMRegisterParamModel *)param{
    [ZMProgressHUD show];
    NSDictionary *paramsDic = [self.registerParamModel mj_keyValues];
    [ZMHttpTool postWithPath:kApi_userRegister params:paramsDic success:^(NSDictionary *result) {
        [ZMProgressHUD dismiss];
        ZMLog(@"%@",result);
        NSInteger status = [result[@"status"] integerValue];
        NSString *message = result[@"message"];
        if(status == 0){
            ZMUserInfo *userInfo = [ZMUserInfo mj_objectWithKeyValues:result[@"data"]];
            [[ZMAppInfomationSingleton sharedInstance] setUserDefault:userInfo];
            UIStoryboard *styoryBoard = [UIStoryboard storyboardWithName:@"ZMLoginReg" bundle:nil];
            ZMSelectRoleViewController *selectRoleVC = [styoryBoard instantiateViewControllerWithIdentifier:@"SelectRoleVC"];
            [self.navigationController pushViewController:selectRoleVC animated:YES];
        }else{
            [ZMProgressHUD dismiss];
            [ZMProgressHUD showErrorWithStatus:message];
        }
        
        
    } failure:^(NSError *error) {
        ZMLog(@"%@",error);
    }];
}

-(void)setUserDefault:(ZMUserInfo *)userInfo{
    // 持久化操作者
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setValue:userInfo.accessToken forKey:@"ACCESSTOKEN"];
    [userDefaults setValue:userInfo.userId forKey:@"USERID"];
    [userDefaults setValue:userInfo.status forKey:@"status"];
    [userDefaults setValue:userInfo.userType forKey:@"userType"];
    [userDefaults synchronize];
}


#pragma mark ---- SendSMS
-(void)postSendSMS:(NSString *)iphone{
    // @"debug":@(1),
    NSDictionary *paramsDic = @{
//                                @"debug":@(1),
                                @"phone":[NSString stringWithFormat:@"+1%@",iphone]
                                };
    [ZMHttpTool postWithPath:kApi_userSendsms params:paramsDic success:^(NSDictionary *result) {
        ZMLog(@"%@",result);
        NSInteger status = [result[@"status"] integerValue];
        if (status == 0) {
         }else{
             NSString *message = result[@"message"];
             [ZMProgressHUD showErrorWithStatus:message];
         }
    } failure:^(NSError *error) {
        ZMLog(@"%@",error);
    }];
}

- (IBAction)resendAction:(id)sender {
    if(IsStrEmpty(self.phoneTextField.text)){
        [ZMProgressHUD showErrorWithStatus:NSLocalizedString(@"PhoneCan'tBeEmpty", nil)];
        return;
    }
    [self postSendSMS:self.phoneTextField.text];
    UIButton *button = (UIButton *)sender;
    __block int timeout = 60; //倒计时时间
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_source_t timeNew = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
    dispatch_source_set_timer(timeNew, dispatch_walltime(NULL, 0), 1.0 * NSEC_PER_SEC, 0); //每秒执行
    dispatch_source_set_event_handler(timeNew, ^{
        if (timeout <= 0) { //倒计时结束，关闭
            dispatch_source_cancel(timeNew);
            dispatch_async(dispatch_get_main_queue(), ^{
                [button setTitle:@"Resend" forState:UIControlStateNormal];
                button.userInteractionEnabled = YES;
                button.hidden = NO;
                self.timeLabel.hidden = YES;
                
            });
        } else {
            NSString *strTime = [NSString stringWithFormat:@"%.2d", timeout];
            dispatch_async(dispatch_get_main_queue(), ^{
                self.timeLabel.hidden = NO;
                button.userInteractionEnabled = NO;
                self.timeLabel.text = [NSString stringWithFormat:@"%@s", strTime];
                button.hidden = YES;
            });
            timeout--;
        }
    });
    dispatch_resume(timeNew);
}

- (IBAction)signUpAction:(id)sender {
    self.registerParamModel.phone = [NSString stringWithFormat:@"+1%@",self.phoneTextField.text];
    self.registerParamModel.verifySmsCode = self.verificationCodeTextField.text;
    if([self verificationParam:self.registerParamModel]){
        [self postUserRegister:self.registerParamModel];
    }
}

- (IBAction)signInAction:(id)sender {
    UIStoryboard *styoryBoard = [UIStoryboard storyboardWithName:@"ZMLoginReg" bundle:nil];
    ZMCodeLoginViewController *codeLoginVC = [styoryBoard instantiateViewControllerWithIdentifier:@"CodeLoginVC"];
    [self.navigationController pushViewController:codeLoginVC animated:YES];
    
}

-(BOOL)verificationParam:(ZMRegisterParamModel *)paramModel{
    if(IsStrEmpty(paramModel.phone)){
        [ZMProgressHUD showErrorWithStatus:NSLocalizedString(@"PhoneCan'tBeEmpty", nil)];
        return NO;
    }
    
    if(IsStrEmpty(paramModel.verifySmsCode)){
        [ZMProgressHUD showErrorWithStatus:NSLocalizedString(@"VerifySmsCodeCan'tBeEmpty", nil)];
        return NO;
    }
    
//    if([paramModel.phone length] != 10){ 
//        [ZMProgressHUD showErrorWithStatus:NSLocalizedString(@"MobilePhoneFormatError", nil)];
//        return NO;
//    }
    return YES;
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
    self.signUpBtn.enabled = !IsStrEmpty(self.verificationCodeTextField.text) && !IsStrEmpty(self.phoneTextField.text);
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
    [self.phoneTextField resignFirstResponder];
    [self.verificationCodeTextField resignFirstResponder];
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
