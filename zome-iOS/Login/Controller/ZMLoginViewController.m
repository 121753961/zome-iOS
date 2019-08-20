//
//  ZMLoginViewController.m
//  zome-iOS
//
//  Created by CFW on 2017/11/26.
//  Copyright © 2017年 KunagBing. All rights reserved.
//

#import "ZMLoginViewController.h"
#import "ZMSignUpViewController.h"
#import "ZMCodeLoginViewController.h"
#import <GoogleSignIn/GoogleSignIn.h>

// Facebook
//#import <FBSDKCoreKit/FBSDKCoreKit.h>
//#import <FBSDKLoginKit/FBSDKLoginKit.h>

#import <FBSDKLoginKit/FBSDKLoginButton.h>
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import <FBSDKLoginKit/FBSDKLoginKit.h>

#import "ZMRegisterParamModel.h"

#import "ZMBuidPhoneViewController.h"

#import "ZMHomeViewController.h"
#import "ZMNavigationController.h"



@interface ZMLoginViewController ()<GIDSignInUIDelegate,GIDSignInDelegate>
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *logo_top;

@end

@implementation ZMLoginViewController

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
    // Do any additional setup after loading the view.
    
     [GIDSignIn sharedInstance].uiDelegate = self;
    [GIDSignIn sharedInstance].delegate = self;
    [GIDSignIn sharedInstance].scopes = @[@"email",@"profile"];
    

    /*
     应用一次只能允许一位用户登录。我们会以 [FBSDKAccessToken currentAccessToken] 代表登录应用的每位用户。
     FBSDKLoginManager 将为您设置此口令，且在设置 currentAccessToken 时，还会自动将口令写入 keychain 缓存。
     FBSDKAccessToken 包含 userID，您可以使用此编号识别用户。
     */
    
//    if ([FBSDKAccessToken currentAccessToken]) {
//        // User is logged in, do work such as go to next view controller.
//    }
    
    [self setLogoTop];
}


- (IBAction)gotoGoogle:(id)sender {
    NSLog(@"gotoGoogle");
    [[GIDSignIn sharedInstance] signOut];
    [[GIDSignIn sharedInstance] signIn];
}

- (IBAction)gotoFacebook:(id)sender {
    NSLog(@"gotoFacebook");
    
    FBSDKLoginManager *login = [[FBSDKLoginManager alloc] init];
    [login logInWithReadPermissions:@[@"public_profile",@"email"] handler:^(FBSDKLoginManagerLoginResult *result, NSError *error) {
        NSLog(@"facebook login result.grantedPermissions = %@,error = %@",result.grantedPermissions,error);
        if (error) {
            NSLog(@"Process error");
        } else if (result.isCancelled) {
            NSLog(@"Cancelled");
        } else {
            NSLog(@"Logged in");
            NSString *token = result.token.tokenString;
            NSDictionary *params = @{@"facebookToken":token};
            [ZMProgressHUD show];
            [ZMHttpTool postWithPath:@"api/user/facebooklogin" params:params success:^(NSDictionary *result) {
                ZMLog(@"%@",result);
                [ZMProgressHUD dismiss];
                ZMCommonResult *resultModel = [ZMCommonResult mj_objectWithKeyValues:result];
                if (resultModel.status == 0) {
                    NSDictionary *data = resultModel.data;
                    if ([data[@"action"] isEqualToString:@"register"]) {
                        ZMRegisterParamModel *param = [ZMRegisterParamModel mj_objectWithKeyValues:data[@"info"]];
                        [self gotoSignUp:param];
                    }else if([data[@"action"] isEqualToString:@"login"]){
                        ZMUserInfo *userInfo = [ZMUserInfo mj_objectWithKeyValues:data[@"info"]];
                        [[ZMAppInfomationSingleton sharedInstance] setUserDefault:userInfo];
                        // [self.navigationController popViewControllerAnimated:YES];
                        [self tabRootController];
                    }
                }
            } failure:^(NSError *error) {
                [ZMProgressHUD dismiss];
                ZMLog(@"%@",error);
            }];
        }

    }];
}

- (IBAction)gotoSignin:(id)sender {
    NSLog(@"gotoSignin");
    UIStoryboard *styoryBoard = [UIStoryboard storyboardWithName:@"ZMLoginReg" bundle:nil];
    ZMCodeLoginViewController *codeLoginView = [styoryBoard instantiateViewControllerWithIdentifier:@"CodeLoginVC"];
//    [self.navigationController  presentViewController:codeLoginView animated:YES completion:nil];
    [self.navigationController pushViewController:codeLoginView animated:YES];
}

- (IBAction)gotoSignup:(id)sender {
    NSLog(@"gotoSignup");
    [self gotoSignUp:nil];
    
}

-(void)gotoSignUp:(ZMRegisterParamModel*)paramModel{
    UIStoryboard *styoryBoard = [UIStoryboard storyboardWithName:@"ZMLoginReg" bundle:nil];
    ZMSignUpViewController *signUpView = [styoryBoard instantiateViewControllerWithIdentifier:@"SignupVC"];
    if (paramModel) {
        signUpView.paramModel = paramModel;
        signUpView.isReg = NO;
    }else{
        signUpView.isReg = YES;
    }
    [self.navigationController pushViewController:signUpView animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - GIDSignInDelegate
- (void)signIn:(GIDSignIn *)signIn didSignInForUser:(GIDGoogleUser *)user withError:(NSError *)error{
    if (error) {
//        [self ShowExclaHud:@"授权失败"];
    }else{
        NSString *token = user.authentication.idToken;
//        NSString *openId = user.userID;
//        NSString *nickname = user.profile.name;
//        NSDictionary *resultDic = @{@"openid":openId,
//                                    @"nickname":nickname,
//                                    @"account_type":@"google",
//                                    @"access_token":token,
//
//                                    @"third_appid":@""};
        //获得返回数据resultDic实现客户端登录
//        ZMLog(@"%@",resultDic);
        
        NSDictionary *params = @{@"googleIdToken":token};
        [ZMProgressHUD show];
        [ZMHttpTool postWithPath:@"api/user/googlelogin" params:params success:^(NSDictionary *result) {
            ZMLog(@"%@",result);
            [ZMProgressHUD dismiss];
            ZMCommonResult *resultModel = [ZMCommonResult mj_objectWithKeyValues:result];
            if (resultModel.status == 0) {
                NSDictionary *data = resultModel.data;
                if ([data[@"action"] isEqualToString:@"register"]) {
                    ZMRegisterParamModel *param = [ZMRegisterParamModel mj_objectWithKeyValues:data[@"info"]];
                    [self gotoSignUp:param];
                }else if([data[@"action"] isEqualToString:@"login"]){
                    ZMUserInfo *userInfo = [ZMUserInfo mj_objectWithKeyValues:data[@"info"]];
                    [[ZMAppInfomationSingleton sharedInstance] setUserDefault:userInfo];
                    // [self.navigationController popViewControllerAnimated:YES];
                    [self tabRootController];
                }
            }
        } failure:^(NSError *error) {
            [ZMProgressHUD dismiss];
            ZMLog(@"%@",error);
        }];
        
        
        
    }
}

-(void)tabRootController{
    self.window = [UIApplication sharedApplication].keyWindow;
    UIStoryboard *styoryBoard = [UIStoryboard storyboardWithName:@"ZMHome" bundle:nil];
    ZMHomeViewController *homeVC = [styoryBoard instantiateViewControllerWithIdentifier:@"HomeVC"];
    ZMNavigationController *navVC = [[ZMNavigationController alloc] initWithRootViewController:homeVC];
    self.window.rootViewController = navVC;
    [self.window makeKeyAndVisible];
}


-(void)setLogoTop{
    if (iPhone4) {
        self.logo_top.constant = 30.f;
    }else if (iPhone5){
        self.logo_top.constant = 60.f;
    }else{
        self.logo_top.constant = 130.f;
    }
}

-(UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleLightContent;
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
