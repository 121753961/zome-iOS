//
//  ZMMapsViewController.h
//  zome-iOS
//
//  Created by CFW on 2017/12/8.
//  Copyright © 2017年 KunagBing. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZMOrderGotripDetail.h"
#import "ZMOrderTripReqParams.h"
@class ZMMapsViewController;

@protocol ZMMapsViewDelegate <NSObject>

/** 修改的代理方法 */
-(void)mapsView:(ZMMapsViewController *)vc gotripDetail:(ZMOrderGotripDetail *)detail;

@end

@interface ZMMapsViewController : UIViewController

@property (nonatomic, strong) ZMOrderGotripDetail *gotripDetail;

@property (nonatomic, strong) ZMOrderGotripDetail *tripDetail;

@property (nonatomic, strong) ZMOrderTripReqParams *orderTripReqParams;

// 1:正常   2：返程  3:修改
@property (nonatomic,assign) NSInteger goTripType;

@property (nonatomic, weak) id<ZMMapsViewDelegate> delegate;

@end
