//
//  ZMTimeDayCollectionViewCell.h
//  zome-iOS
//
//  Created by CFW on 2017/12/9.
//  Copyright © 2017年 KunagBing. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZMTimeDayCollectionViewCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UILabel *dayLabel;
@property (weak, nonatomic) IBOutlet UILabel *dayInWeekLabel;
@property (weak, nonatomic) IBOutlet UILabel *monthLabel;


@property (strong, nonatomic) NSDate *date;
+(NSString *)ID;



@end
