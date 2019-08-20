//
//  ZMMapsPredictionCell.m
//  zome-iOS
//
//  Created by CFW on 2018/1/1.
//  Copyright © 2018年 KunagBing. All rights reserved.
//

#import "ZMMapsPredictionCell.h"

@implementation ZMMapsPredictionCell

+(NSString *)ID{
    return NSStringFromClass([self class]);
}

+(id)myInit{
    return [[[NSBundle mainBundle]loadNibNamed:NSStringFromClass([self class]) owner:nil options:nil]lastObject];
}

+(instancetype)cellWithTableView:(UITableView *)tableView{
    ZMMapsPredictionCell *cell = [tableView dequeueReusableCellWithIdentifier:[self ID]];
    if (cell == nil) {
        cell = [ZMMapsPredictionCell myInit];
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
