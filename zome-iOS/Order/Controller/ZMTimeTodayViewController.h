//
//  ZMTimeTodayViewController.h
//  zome-iOS
//
//  Created by CFW on 2017/12/9.
//  Copyright © 2017年 KunagBing. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZMOrderGotripDetail.h"
#import "ZMOrderTripReqParams.h"
@class ZMTimeTodayViewController;


@protocol ZMTimeTodayViewDelegate <NSObject>

/** 修改的代理方法 */
-(void)timeTodayView:(ZMTimeTodayViewController *)vc gotripDetail:(ZMOrderGotripDetail *)detail;



@end

@interface ZMTimeTodayViewController : UIViewController

@property (nonatomic, strong) ZMOrderGotripDetail *gotripDetail;

@property (nonatomic, strong) ZMOrderTripReqParams *orderTripReqParams;


// 1:正常   2：返程  3:修改
@property (nonatomic,assign) NSInteger goTripType;

@property (nonatomic,weak) id<ZMTimeTodayViewDelegate> delegate;

@end
