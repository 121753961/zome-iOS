//
//  ZMCarStyleYearColorModel.m
//  zome-iOS
//
//  Created by CFW on 2017/12/23.
//  Copyright © 2017年 KunagBing. All rights reserved.
//

#import "ZMCarStyleYearColorModel.h"

@implementation ZMCarStyleYearColorModel

-(void)setColor:(NSString *)color{
    _color = color;
    NSArray *array = [color componentsSeparatedByString:@","];
    _colorArray = array;
}

-(void)setYear:(NSString *)year{
    _year = year;
    NSArray *array = [year componentsSeparatedByString:@","];
    _yearArray = array;
}

@end
