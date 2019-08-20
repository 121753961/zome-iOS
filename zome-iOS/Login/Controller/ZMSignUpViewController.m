//
//  ZMSignUpViewController.m
//  zome-iOS
//
//  Created by CFW on 2017/11/26.
//  Copyright © 2017年 KunagBing. All rights reserved.
//

#import "ZMSignUpViewController.h"
#import "ZMBuidPhoneViewController.h"
#import "ZMUploadImage.h"
#import "ZMRegisterParamModel.h"
#import <CocoaSecurity/CocoaSecurity.h>

@interface ZMSignUpViewController ()<ZMUploadImageDelegate,UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITextField *nameTextField;
@property (weak, nonatomic) IBOutlet UITextField *emailTextField;
@property (weak, nonatomic) IBOutlet UITextField *passWordTextField;
@property (weak, nonatomic) IBOutlet UITextField *phoneTextField;
@property (weak, nonatomic) IBOutlet UIImageView *avatarImageView;
@property (weak, nonatomic) IBOutlet UIButton *maleBtn;
@property (weak, nonatomic) IBOutlet UIButton *female;
@property (nonatomic, copy) NSString *gender;

@property (weak, nonatomic) IBOutlet UILabel *line_1;
@property (weak, nonatomic) IBOutlet UILabel *line_2;
@property (weak, nonatomic) IBOutlet UILabel *line_3;
@property (weak, nonatomic) IBOutlet UIView *emailView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *emailViewH;


@property (weak, nonatomic) IBOutlet UILabel *line_4;
@property (weak, nonatomic) IBOutlet UIView *passwordView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *passwordViewH;



@end

@implementation ZMSignUpViewController


-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    self.navigationController.navigationBarHidden = YES;
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = YES;
}

-(void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    self.navigationController.navigationBarHidden = NO;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 如果产品需要当键盘弹起时，点击背景收起键盘
    [IQKeyboardManager sharedManager].shouldResignOnTouchOutside = YES;
    
    // defind
    self.gender = @"M";
    ZMLog(@"%@",self.paramModel);
    if (self.paramModel) {
        self.emailTextField.text = self.paramModel.email;
        self.nameTextField.text = self.paramModel.lastName;
        self.phoneTextField.text = self.paramModel.firstName;
        NSURL *url = [NSURL URLWithString:self.paramModel.avatar];
        [self.avatarImageView sd_setImageWithURL:url];
    }
    
    [self setUI];
    // Do any additional setup after loading the view.
}

- (IBAction)continueAction:(id)sender {
    ZMRegisterParamModel *paramModel = [[ZMRegisterParamModel alloc] init];
    paramModel.firstName = self.nameTextField.text;
    paramModel.lastName = self.phoneTextField.text;
    paramModel.gender = self.gender;
    CocoaSecurityResult *csResult = [CocoaSecurity md5:self.passWordTextField.text];
    paramModel.googleId = self.paramModel.googleId;
    paramModel.facebookId = self.paramModel.facebookId;
    paramModel.email = self.emailTextField.text;
    if (self.isReg) {
        paramModel.password = csResult.hexLower;
    }
    
    if([self verificationParam:paramModel]){
        if (self.isReg) {
            NSDictionary *paramsDic = [paramModel mj_keyValues];
            [ZMHttpTool postWithPath:kApi_userVerifyinfo params:paramsDic success:^(NSDictionary *result) {
                ZMLog(@"%@",result);
                NSInteger status = [result[@"status"] integerValue];
                NSString *message = result[@"message"];
                if(status == 0){
                    // reg
                    UIStoryboard *styoryBoard = [UIStoryboard storyboardWithName:@"ZMLoginReg" bundle:nil];
                    ZMBuidPhoneViewController *buidPhoneVC = [styoryBoard instantiateViewControllerWithIdentifier:@"BuidPhoneVC"];
                    buidPhoneVC.registerParamModel = paramModel;
                    [self.navigationController pushViewController:buidPhoneVC animated:YES];
                }else{
                    [ZMProgressHUD showErrorWithStatus:message];
                }
            } failure:^(NSError *error) {
                ZMLog(@"%@",error);
            }];
        }else{
            UIStoryboard *styoryBoard = [UIStoryboard storyboardWithName:@"ZMLoginReg" bundle:nil];
            ZMBuidPhoneViewController *buidPhoneVC = [styoryBoard instantiateViewControllerWithIdentifier:@"BuidPhoneVC"];
            buidPhoneVC.registerParamModel = paramModel;
            [self.navigationController pushViewController:buidPhoneVC animated:YES];
        }
    }
}

- (IBAction)backAction:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)avatarAction:(id)sender {
    [[ZMUploadImage shareUploadImage] showActionSheetInFatherViewController:self delegate:self];
}
//实现代理方法即可
#pragma mark - ZXUploadImageDelegate
- (void)uploadImageToServerWithImage:(UIImage *)image {
    //在这里处理得到的image
    ZMLog(@"%@",image);
    self.avatarImageView.image = image;
}

-(BOOL)verificationParam:(ZMRegisterParamModel *)paramModel{
    if(IsStrEmpty(paramModel.firstName)){
        [ZMProgressHUD showErrorWithStatus:NSLocalizedString(@"FirstNameCan'tBeEmpty", nil)];
        return NO;
    }
    
    if(IsStrEmpty(paramModel.lastName)){
        [ZMProgressHUD showErrorWithStatus:NSLocalizedString(@"LastNameCan'tBeEmpty", nil)];
        return NO;
    }
    
    // 注册才验证，第三方登录不验证
    if (self.isReg) {
        if(IsStrEmpty(paramModel.email)){
            [ZMProgressHUD showErrorWithStatus:NSLocalizedString(@"EmailCan'tBeEmpty", nil)];
            return NO;
        }
        
        if(IsStrEmpty(paramModel.password)){
            [ZMProgressHUD showErrorWithStatus:NSLocalizedString(@"PasswordCan'tBeEmpty", nil)];
            return NO;
        }
    }
    
    return YES;
}

- (IBAction)maleAction:(UIButton *)sender {
    if (sender.selected) {
        return;
    }
    sender.selected = YES;
    self.female.selected = NO;
    self.gender = @"M";
}

- (IBAction)femaleAction:(UIButton *)sender {
    if (sender.selected) {
        return;
    }
    sender.selected = YES;
    self.maleBtn.selected = NO;
    self.gender = @"F";
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
        case 3:
            self.line_3.backgroundColor = color;
            break;
        case 4:
            self.line_4.backgroundColor = color;
            break;
            
        default:
            break;
    }
}



-(void)removeResignFirstResponder{
    [self.nameTextField resignFirstResponder];
    [self.emailTextField resignFirstResponder];
    [self.phoneTextField resignFirstResponder];
    [self.passWordTextField resignFirstResponder];
}

-(void)setUI{if (!self.isReg) {
    self.emailView.hidden = YES;
    self.emailViewH.constant = 0.f;
    self.passwordView.hidden = YES;
    self.passwordViewH.constant = 0.f;
}
    [_avatarImageView setCornerRadius:45.f];
    [_nameTextField setValue:[UIColor lightGrayColor]
                  forKeyPath:@"_placeholderLabel.textColor"];
    _nameTextField.delegate = self;
    
    [_emailTextField setValue:[UIColor lightGrayColor] forKeyPath:@"_placeholderLabel.textColor"];
    _emailTextField.delegate = self;
    
    [_phoneTextField setValue:[UIColor lightGrayColor] forKeyPath:@"_placeholderLabel.textColor"];
    _phoneTextField.delegate = self;
    
    [_passWordTextField setValue:[UIColor lightGrayColor] forKeyPath:@"_placeholderLabel.textColor"];
    _passWordTextField.delegate = self;
    
}

-(UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleDefault;
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
