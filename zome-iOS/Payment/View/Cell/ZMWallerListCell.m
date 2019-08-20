//
//  ZMWallerListCell.m
//  zome-iOS
//
//  Created by CFW on 2017/12/17.
//  Copyright © 2017年 KunagBing. All rights reserved.
//

#import "ZMWallerListCell.h"

@implementation ZMWallerListCell

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
    ZMWallerListCell *cell = [tableView dequeueReusableCellWithIdentifier:[self ID]];
    if (cell == nil) {
        cell = [ZMWallerListCell myInit];
    }
    return cell;
}



@end
