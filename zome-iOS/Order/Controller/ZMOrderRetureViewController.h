//
//  ZMOrderRetureViewController.h
//  zome-iOS
//
//  Created by CFW on 2017/12/10.
//  Copyright © 2017年 KunagBing. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZMOrderTripReqParams.h"

@interface ZMOrderRetureViewController : UIViewController

@property (nonatomic, strong) ZMOrderTripReqParams *orderTripReqParams;

// 1:正常   2：返程  3:修改
@property (nonatomic,assign) NSInteger goTripType;

@end
