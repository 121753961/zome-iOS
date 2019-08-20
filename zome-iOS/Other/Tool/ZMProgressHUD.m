//
//  ZMProgressHUD.m
//  zome-iOS
//
//  Created by CFW on 2017/12/6.
//  Copyright © 2017年 KunagBing. All rights reserved.
//

#import "ZMProgressHUD.h"


@implementation ZMProgressHUD

+(void)showWithStatus:(NSString*)status{
    [SVProgressHUD setDefaultStyle:SVProgressHUDStyleDark];
    [SVProgressHUD showWithStatus:status];
}

+(void)showErrorWithStatus:(NSString*)status{
    [SVProgressHUD setDefaultStyle:SVProgressHUDStyleDark];
    [SVProgressHUD setMinimumDismissTimeInterval:0.5];
    [SVProgressHUD showErrorWithStatus:status];
}

+(void)showSuccessWithStatus:(NSString*)status{
    [SVProgressHUD setDefaultStyle:SVProgressHUDStyleDark];
    [SVProgressHUD setMinimumDismissTimeInterval:0.5];
    [SVProgressHUD showSuccessWithStatus:status];
}

+(void)show{
    [SVProgressHUD setDefaultStyle:SVProgressHUDStyleDark];
    [SVProgressHUD show];
}

+(void)dismiss{
    [SVProgressHUD dismiss];
}



@end
