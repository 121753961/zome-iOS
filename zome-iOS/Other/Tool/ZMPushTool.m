//
//  ZMPushTool.m
//  zome-iOS
//
//  Created by CFW on 2017/12/6.
//  Copyright © 2017年 KunagBing. All rights reserved.
//

#import "ZMPushTool.h"
#import "ZMCodeLoginViewController.h"
#import "ZMLoginViewController.h"
#import "ZMPayMentListController.h"

@implementation ZMPushTool

/**
 * 跳转到Login
 */
+(void)pushLoginViewWithTarget:(UINavigationController *)target{
    NSArray *ctrlArray = target.viewControllers;
    BOOL isPush = YES;
    for (UIViewController *vc in ctrlArray) {
        if ([vc isKindOfClass:[ZMLoginViewController class]]) {
            ZMLoginViewController *codeLoginVC = (ZMLoginViewController *)vc;
            isPush = NO;
            [target popToViewController:codeLoginVC animated:YES];
        }
    }
    if (isPush) {
        [target popViewControllerAnimated:YES];
    }
}

/**
 * 跳转到CodeLogin
 */
+(void)pushCodeLoginViewWithTarget:(UINavigationController *)target{
    NSArray *ctrlArray = target.viewControllers;
    BOOL isPush = YES;
    for (UIViewController *vc in ctrlArray) {
        if ([vc isKindOfClass:[ZMCodeLoginViewController class]]) {
            ZMCodeLoginViewController *codeLoginVC = (ZMCodeLoginViewController *)vc;
            isPush = NO;
            [target popToViewController:codeLoginVC animated:YES];
        }
    }
    if (isPush) {
        [target popViewControllerAnimated:YES];
    }
}

/**
 * 跳转到PayMentList
 */
+(void)pushPayMentListViewWithTarget:(UINavigationController *)target{
    NSArray *ctrlArray = target.viewControllers;
    BOOL isPush = YES;
    for (UIViewController *vc in ctrlArray) {
        if ([vc isKindOfClass:[ZMPayMentListController class]]) {
            ZMPayMentListController *codeLoginVC = (ZMPayMentListController *)vc;
            isPush = NO;
            [target popToViewController:codeLoginVC animated:YES];
        }
    }
    if (isPush) {
        [target popViewControllerAnimated:YES];
    }
}




@end
