//
//  ZMBJPickerViewCellType_1.m
//  zome-iOS
//
//  Created by CFW on 2017/12/18.
//  Copyright © 2017年 KunagBing. All rights reserved.
//

#import "ZMBJPickerViewCellType_1.h"

@implementation ZMBJPickerViewCellType_1

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

-(instancetype)myInit{
    return [[[NSBundle mainBundle]loadNibNamed:NSStringFromClass([self class]) owner:nil options:nil]lastObject];
}

-(void)awakeFromNib{
    [super awakeFromNib];
    _icon.backgroundColor = kRandomColor;
    _icon.layer.masksToBounds = YES;
    _icon.layer.cornerRadius = 8.f;
}



@end
