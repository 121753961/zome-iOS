//
//  ZMPaymentListPayCell.m
//  zome-iOS
//
//  Created by CFW on 2017/12/17.
//  Copyright © 2017年 KunagBing. All rights reserved.
//

#import "ZMPaymentListPayCell.h"

@implementation ZMPaymentListPayCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

+(NSString *)ID{
    return NSStringFromClass([self class]);
}

+(id)myInit{
    return [[[NSBundle mainBundle]loadNibNamed:NSStringFromClass([self class]) owner:nil options:nil]lastObject];
}

+(instancetype)cellWithTableView:(UITableView *)tableView{
    ZMPaymentListPayCell *cell = [tableView dequeueReusableCellWithIdentifier:[self ID]];
    if (cell == nil) {
        cell = [ZMPaymentListPayCell myInit];
    }
    return cell;
}



@end
