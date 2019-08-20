//
//  ZMOrderSeatsViewController.h
//  zome-iOS
//
//  Created by CFW on 2017/12/10.
//  Copyright © 2017年 KunagBing. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZMOrderGotripDetail.h"
#import "ZMOrderTripReqParams.h"
@class ZMOrderSeatsViewController;

@protocol ZMOrderSeatsViewDelegate <NSObject>

/** 修改的代理方法 */
-(void)orderSeatsView:(ZMOrderSeatsViewController *)vc gotripDetail:(ZMOrderGotripDetail *)detail;

@end

@interface ZMOrderSeatsViewController : UIViewController

@property (nonatomic, strong) ZMOrderGotripDetail *gotripDetail;

@property (nonatomic, strong) ZMOrderTripReqParams *orderTripReqParams;

// 1:正常   2：返程  3:修改
@property (nonatomic,assign) NSInteger goTripType;

@property (nonatomic, weak) id<ZMOrderSeatsViewDelegate> delegate;

@end
