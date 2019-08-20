//
//  ZMEditCardController.h
//  zome-iOS
//
//  Created by CFW on 2017/12/16.
//  Copyright © 2017年 KunagBing. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZMPaymentCardModel.h"

@interface ZMEditCardController : UIViewController

@property(nonatomic, strong) ZMPaymentCardModel *cardModel;



@property (nonatomic, copy) NSString *titleStr;

@end
