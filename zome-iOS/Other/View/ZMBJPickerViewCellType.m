//
//  ZMBJPickerViewCellType.m
//  zome-iOS
//
//  Created by CFW on 2017/12/19.
//  Copyright © 2017年 KunagBing. All rights reserved.
//

#import "ZMBJPickerViewCellType.h"

@implementation ZMBJPickerViewCellType

-(instancetype)myInit{
    return [[[NSBundle mainBundle]loadNibNamed:NSStringFromClass([self class]) owner:nil options:nil]lastObject];
}

@end
