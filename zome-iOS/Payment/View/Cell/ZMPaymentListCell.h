//
//  ZMPaymentListCell.h
//  zome-iOS
//
//  Created by CFW on 2017/12/16.
//  Copyright © 2017年 KunagBing. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ZMPaymentCardModel;

@interface ZMPaymentListCell : UITableViewCell
+(NSString *)ID;

+(id)myInit;

+(instancetype)cellWithTableView:(UITableView *)tableView;

@property (nonatomic, strong) ZMPaymentCardModel *cardModel;

@property (weak, nonatomic) IBOutlet UILabel *brandLabel;

@property (weak, nonatomic) IBOutlet UILabel *lastFourLabel;


@end
