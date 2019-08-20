//
//  ZMProgressHUD.h
//  zome-iOS
//
//  Created by CFW on 2017/12/6.
//  Copyright © 2017年 KunagBing. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface ZMProgressHUD : NSObject

+(void)showWithStatus:(NSString*)status;

+(void)showErrorWithStatus:(NSString*)status;

+(void)showSuccessWithStatus:(NSString*)status;

+(void)show;

+(void)dismiss;

@end
