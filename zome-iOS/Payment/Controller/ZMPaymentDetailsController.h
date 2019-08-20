//
//  ZMPaymentDetailsController.h
//  zome-iOS
//
//  Created by CFW on 2017/12/16.
//  Copyright © 2017年 KunagBing. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZMPaymentCardModel.h"

@interface ZMPaymentDetailsController : UIViewController

@property (nonatomic, strong) ZMPaymentCardModel *cardModel;

@property (weak, nonatomic) IBOutlet UILabel *viewTitle;

@property (weak, nonatomic) IBOutlet UILabel *cardNumberLabel;

@property (weak, nonatomic) IBOutlet UILabel *dateLabel;


@end
