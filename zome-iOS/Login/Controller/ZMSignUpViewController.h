//
//  ZMSignUpViewController.h
//  zome-iOS
//
//  Created by CFW on 2017/11/26.
//  Copyright © 2017年 KunagBing. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ZMRegisterParamModel;

@interface ZMSignUpViewController : UIViewController

@property(nonatomic, strong) ZMRegisterParamModel *paramModel;

@property(nonatomic, assign) BOOL isReg;


@end
