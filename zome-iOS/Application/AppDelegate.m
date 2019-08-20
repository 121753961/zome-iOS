//
//  AppDelegate.m
//  zome-iOS
//
//  Created by CFW on 2017/11/26.
//  Copyright © 2017年 KunagBing. All rights reserved.
//
#import <UIKit/UIKit.h>
#import "AppDelegate.h"
#import <IQKeyboardManager.h>
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import <GoogleMaps/GoogleMaps.h>
#import <GooglePlaces/GooglePlaces.h>
#import <Stripe/Stripe.h>
#import <Bugtags/Bugtags.h>
#import "ZMHomeViewController.h"
#import "ZMLoginViewController.h"
#import "ZMNavigationController.h"
#import "ZMLocation.h"
#import "ZMNavigationController.h"



@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    //关闭设置为NO, 默认值为NO.
    [IQKeyboardManager sharedManager].enable = YES;
    // 是否显示占位文字
    [IQKeyboardManager sharedManager].shouldShowTextFieldPlaceholder= NO;
    // 工具条 
    [IQKeyboardManager sharedManager].enableAutoToolbar = NO;
    
    // google Maps
    [GMSServices provideAPIKey:GoogleMapKey];
    [GMSPlacesClient provideAPIKey:GooglePlacesKey];
    
    //控件外观设置
    [self setupLookAndFeel];
    
    // google Sign in
    [GIDSignIn sharedInstance].clientID = GIDSignInClientID;
    
    // Facebook
//    [FBSDKSettings setAppID:FacebookKey];
    [[FBSDKApplicationDelegate sharedInstance] application:application didFinishLaunchingWithOptions:launchOptions];
    
    [[STPPaymentConfiguration sharedConfiguration] setPublishableKey:kStripePublishableKey];
    
    // 定位
    [self getUserLocation];
    
    //Bugtags
//    #if DEBUG
    
    BugtagsOptions *options = [[BugtagsOptions alloc] init];
    options.trackingUserSteps = YES;
    [Bugtags startWithAppKey:BugtagsKey invocationEvent:BTGInvocationEventBubble options:options];
    
//    #endif
    self.window = [[UIWindow alloc] initWithFrame: [[UIScreen mainScreen] bounds]];
    if (![[ZMAppInfomationSingleton sharedInstance] getoginCode]) {
        UIStoryboard *styoryBoard = [UIStoryboard storyboardWithName:@"ZMLoginReg" bundle:nil];
        ZMLoginViewController *loginView = [styoryBoard instantiateViewControllerWithIdentifier:@"LoginVC"];
        ZMNavigationController *navVC = [[ZMNavigationController alloc] initWithRootViewController:loginView];
        self.window.rootViewController = navVC;
    }else{
        UIStoryboard *styoryBoard = [UIStoryboard storyboardWithName:@"ZMHome" bundle:nil];
        ZMHomeViewController *homeVC = [styoryBoard instantiateViewControllerWithIdentifier:@"HomeVC"];
        ZMNavigationController *navVC = [[ZMNavigationController alloc] initWithRootViewController:homeVC];
        self.window.rootViewController = navVC;
    }
    [self.window makeKeyAndVisible];
    
    
    
    return YES;
}


- (BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<UIApplicationOpenURLOptionsKey,id> *)options {
    
    BOOL handled = YES;
    ZMLog(@"%@",[url scheme]);
    if([[url scheme] isEqualToString:GiDSignInKey]){
        //  google Sign in
        if (@available(iOS 9.0, *)) {
            handled  = [[GIDSignIn sharedInstance] handleURL:url sourceApplication:options[UIApplicationOpenURLOptionsSourceApplicationKey] annotation:options[UIApplicationOpenURLOptionsAnnotationKey]];
        }
    }else{
        // Facebook
        FBSDKApplicationDelegate *FBSDK = [FBSDKApplicationDelegate sharedInstance];
        if (@available(iOS 9.0, *)) {
            handled = [FBSDK application:app
                                 openURL:url
                       sourceApplication:options[UIApplicationOpenURLOptionsSourceApplicationKey]
                              annotation:options[UIApplicationOpenURLOptionsAnnotationKey]];
        }
    }
    return handled;
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {
    BOOL handled;
    if([[url scheme] isEqualToString:GiDSignInKey]){
        //  google Sign in google Sign in
        handled = [[GIDSignIn sharedInstance] handleURL:url
                                      sourceApplication:sourceApplication
                                             annotation:annotation];
    }else{
        // Facebook
        FBSDKApplicationDelegate *shared = [FBSDKApplicationDelegate sharedInstance];
        handled = [shared application:application
                                   openURL:url
                         sourceApplication:sourceApplication
                                annotation:annotation];
    }
    return handled;
}



- (void)applicationWillResignActive:(UIApplication *)application {}


- (void)applicationDidEnterBackground:(UIApplication *)application {}


- (void)applicationWillEnterForeground:(UIApplication *)application {}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    
    // Facebook
    [FBSDKAppEvents activateApp];
}


- (void)applicationWillTerminate:(UIApplication *)application {}



-(void)getUserLocation{
    ZMLocation *location = [ZMLocation sharedLocation];
    if ([ZMLocation isLocationServicesEnabled]) {

    }
    [location currentPlaceWithCallback:^(GMSPlaceLikelihoodList * _Nullable likelihoodList, NSError * _Nullable error) {
        
    }];
}


#pragma mark - 设置外观
- (void)setupLookAndFeel {
    // 显示状态栏(只对iOS6有效)
    [UIApplication sharedApplication].statusBarHidden = NO;
    
    // 修改状态栏文字颜色
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    
    // 启动时隐藏状态栏
    [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationFade];
    
    NSDictionary *navbarTitleTextAttributes = @{NSForegroundColorAttributeName:[UIColor whiteColor]};
    [[UINavigationBar appearance] setTitleTextAttributes:navbarTitleTextAttributes];
    [[UINavigationBar appearance] setTintColor:[UIColor whiteColor]];
}



@end
