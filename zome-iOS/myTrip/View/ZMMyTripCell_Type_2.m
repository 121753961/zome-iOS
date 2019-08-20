//
//  ZMMyTripCell_Type_2.m
//  zome-iOS
//
//  Created by CFW on 2018/1/2.
//  Copyright © 2018年 KunagBing. All rights reserved.
//

#import "ZMMyTripCell_Type_2.h"

@implementation ZMMyTripCell_Type_2

+(NSString *)ID{
    return NSStringFromClass([self class]);
}

+(id)myInit{
    return [[[NSBundle mainBundle]loadNibNamed:NSStringFromClass([self class]) owner:nil options:nil]lastObject];
}

+(instancetype)cellWithTableView:(UITableView *)tableView{
    ZMMyTripCell_Type_2 *cell = [tableView dequeueReusableCellWithIdentifier:[self ID]];
    if (cell == nil) {
        cell = [ZMMyTripCell_Type_2 myInit];
    }
    return cell;
}




- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
