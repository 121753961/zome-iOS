//
//  ZMTimeDayViewCell.m
//  zome-iOS
//
//  Created by CFW on 2017/12/9.
//  Copyright © 2017年 KunagBing. All rights reserved.
//

#import "ZMTimeDayViewCell.h"

@implementation ZMTimeDayViewCell

+(NSString *)ID{
    return NSStringFromClass([self class]);
}

+(id)myInit{
    return [[[NSBundle mainBundle]loadNibNamed:NSStringFromClass([self class]) owner:nil options:nil]lastObject];
}





- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

@end
