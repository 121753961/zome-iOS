//
//  ZMTodayViewController.h
//  zome-iOS
//
//  Created by CFW on 2017/12/9.
//  Copyright © 2017年 KunagBing. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ZMTodayViewController;

@protocol ZMTodayViewDelegate <NSObject>
@optional
-(void)todayView:(ZMTodayViewController *)vc leftBtnAction:(UIButton *)btn;

-(void)todayView:(ZMTodayViewController *)vc rigthBtnAction:(UIButton *)btn;

@end

@interface ZMTodayViewController : UIViewController

@property (nonatomic, assign) NSInteger timeType;

@property(nonatomic, weak) id<ZMTodayViewDelegate> delegate;


@end
