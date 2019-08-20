//
//  ZMPaymentListCell.m
//  zome-iOS
//
//  Created by CFW on 2017/12/16.
//  Copyright © 2017年 KunagBing. All rights reserved.
//

#import "ZMPaymentListCell.h"
#import "ZMPaymentCardModel.h"

@implementation ZMPaymentListCell

+(NSString *)ID{
    return NSStringFromClass([self class]);
}

+(id)myInit{
    return [[[NSBundle mainBundle]loadNibNamed:NSStringFromClass([self class]) owner:nil options:nil]lastObject];
}

+(instancetype)cellWithTableView:(UITableView *)tableView{
    ZMPaymentListCell *cell = [tableView dequeueReusableCellWithIdentifier:[self ID]];
    if (cell == nil) {
        cell = [ZMPaymentListCell myInit];
    }
    return cell;
}


-(void)setCardModel:(ZMPaymentCardModel *)cardModel{
    
    _cardModel = cardModel;
    
    _brandLabel.text = cardModel.brand;
    
    
    _lastFourLabel.text = [NSString stringWithFormat:@"**** **** **** %@",cardModel.lastFour?cardModel.lastFour:@""];
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
