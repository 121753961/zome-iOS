//
//  ZMPickDateViewController.h
//  zome-iOS
//
//  Created by CFW on 2017/12/9.
//  Copyright © 2017年 KunagBing. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <FSCalendar.h>
@class ZMPickDateViewController;

@protocol ZMPickDateViewDelegate <NSObject>

@required
/**  */
-(void)pickDateView:(ZMPickDateViewController *)VC didSelectDate:(NSDate *)date timeStr:(NSString *)time;


@end

@interface ZMPickDateViewController : UIViewController<FSCalendarDelegate,FSCalendarDataSource>

@property (weak,nonatomic) FSCalendar *calendar;

@property (nonatomic, weak) id<ZMPickDateViewDelegate> delegate;

@end
