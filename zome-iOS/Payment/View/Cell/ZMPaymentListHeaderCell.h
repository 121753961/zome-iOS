//
//  ZMPaymentListHeaderCell.h
//  zome-iOS
//
//  Created by CFW on 2017/12/16.
//  Copyright © 2017年 KunagBing. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZMPaymentListHeaderCell : UITableViewCell

+(NSString *)ID;

+(id)myInit;

+(instancetype)cellWithTableView:(UITableView *)tableView;

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@end
